//
//  JCY_Global.m
//  MiMi
//
//  Created by WsdlDev on 15/12/3.
//  Copyright © 2015年 jcYang. All rights reserved.
//

#import "JCY_Global.h"
#import <CommonCrypto/CommonDigest.h>  

@implementation JCY_Global

+ (CGSize)sizeForNoticeTitle:(NSString*)text font:(UIFont*)font limitSize:(CGSize)limitSize{
    if (!text) {
        return CGSizeZero;
    }
    if (limitSize.width==0) {
        CGRect screen = [UIScreen mainScreen].bounds;
         CGFloat maxWidth = screen.size.width;
        limitSize.width =maxWidth;;
    }
    if (limitSize.height==0) {
        limitSize.height =CGFLOAT_MAX;
    }
    CGSize maxSize =limitSize;
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = /*NSStringDrawingUsesLineFragmentOrigin |*/
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    }
    else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return textSize;
}
+ (CGSize)sizeForMoreLineNoticeTitle:(NSString*)text font:(UIFont*)font limitSize:(CGSize)limitSize;{
    if (limitSize.width==0) {
        CGRect screen = [UIScreen mainScreen].bounds;
        CGFloat maxWidth = screen.size.width;
        limitSize.width =maxWidth;;
    }
    if (limitSize.height==0) {
        limitSize.height =CGFLOAT_MAX;
    }
    CGSize maxSize =limitSize;
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin/* |
        NSStringDrawingUsesFontLeading*/;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    }
    else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return textSize;
}

+ (CGFloat)fontSizeWithRectSize:(CGSize)rSize text:(NSString*)text baseFontSize:(CGFloat)baseFontSize{
    UIFont *font =[UIFont systemFontOfSize:baseFontSize];
    CGSize currentSize =[JCY_Global sizeForNoticeTitle:text font:font limitSize:CGSizeZero];
    CGFloat availableFontSize =baseFontSize;
    //
    if (currentSize.width>rSize.width||currentSize.height>rSize.height) {
        while (YES) {
            if (currentSize.width<=rSize.width&&currentSize.height<=rSize.height) {
                break;
            }
            availableFontSize --;
            font =[UIFont systemFontOfSize:availableFontSize];
            currentSize =[JCY_Global sizeForNoticeTitle:text font:font limitSize:CGSizeZero];
        }
    }
    
    /*
    while (YES) {
        currentSize =[JCY_Global sizeForNoticeTitle:text font:font];
        if (currentSize.width<=rSize.width) {
            if (currentSize.height>=rSize.height) {
                break;
            }
            availableFontSize++;
        }else{
            if (currentSize.height<=rSize.height) {
                break;
            }
            availableFontSize--;
        }
        font =[UIFont systemFontOfSize:availableFontSize];
    }*/
    return availableFontSize;
}

+(void)drawViewCircleBackground:(UIView*)view backgroundColor:(UIColor*)backColor text:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)textFont{
    CGPoint centerPoint =CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0);
    CGFloat radius =view.bounds.size.width>view.bounds.size.height?view.bounds.size.height/2.0:view.bounds.size.width/2.0;
    //由于ios是支持retiana图片，按原控件大小绘制的出来的背景图会模糊，所以要宽和高都x2，然后再将图像的scale设为2，即为高清
    centerPoint.x*=2;
    centerPoint.y*=2;
    radius *=2;
    CGSize size =CGSizeMake(view.bounds.size.width*2, view.bounds.size.height*2);
    UIGraphicsBeginImageContext(size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);  //线宽
    if (backColor) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), backColor.CGColor);//填充颜色
    }
    /*if (textColor) {
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), textColor.CGColor);//线颜色
    }*/
    //填充圆
    CGContextAddArc(UIGraphicsGetCurrentContext(), centerPoint.x, centerPoint.y,radius-1 , 0, M_PI*2, NO);
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);
    //写字
    if (text&&text.length>0) {
        //
        UIColor *tempTextColor =textColor?textColor:[UIColor whiteColor];
        CGFloat fontSize =textFont?textFont.pointSize*2:15*2;
        UIFont *tempTextFont =[UIFont systemFontOfSize:fontSize];
        //
        CGSize availableSize =[JCY_Global sizeForNoticeTitle:text font:tempTextFont limitSize:CGSizeZero];
        CGPoint tempFontPoint =CGPointMake(centerPoint.x-availableSize.width/2.0, centerPoint.y-availableSize.height/2.0);
        //
        [text drawAtPoint:tempFontPoint withAttributes:@{NSFontAttributeName:tempTextFont,NSForegroundColorAttributeName:tempTextColor}];
        //[text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:tempTextColor}];
    }
    UIImage* backImage =[UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:2.0 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    //
    [view setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
}

+(UIImage*)drawViewSeperateLineBackgorund:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    //由于ios是支持retiana图片，按原控件大小绘制的出来的背景图会模糊，所以要宽和高都x2，然后再将图像的scale设为2，即为高清
    size.height *=2;
    size.width *=2;
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, lineWidth*2);
    CGContextSetStrokeColorWithColor(currentContext, lineColor.CGColor);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, fromPoint.x*2, fromPoint.y*2);
    CGContextAddLineToPoint(currentContext, toPoint.x*2, toPoint.y*2);
    CGContextDrawPath(currentContext, kCGPathStroke);
    UIImage *backImage =[UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:2.0 orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    return backImage;
}

//按比例缩放,size是你要把图显示到多大区域。当图像高度大于宽度，则优先考虑填满宽度；否则相反
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIViewController*)getCurrentPresentController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
   
}

+(void)alertWithTitle:(NSString*)title msg:(NSString*)msg action:(/*void(^)(UIAlertAction *action)*/id)handler{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){//8.0版本
        if (handler==nil) {
            handler =^(UIAlertAction *action){};
        }
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleDefault
                                                              handler:handler];
        
        [alert addAction:defaultAction];
        UIViewController* controller =[JCY_Global getCurrentPresentController];
        [controller presentViewController:alert animated:YES completion:nil];
    }else{
        [[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK",nil), nil] show ];
    }
    
}

+(void)showTip:(NSString *)tipTitle hideAfter:(NSTimeInterval)interval{
    CGRect rect =[UIScreen mainScreen].bounds;
    UIView *backgroundView =[[UIView alloc] initWithFrame:rect];
    backgroundView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.6];
    NSMutableParagraphStyle *ps =[[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing =5;
    ps.alignment =NSTextAlignmentCenter;
    //
    NSAttributedString *attr =[[NSAttributedString alloc] initWithString:tipTitle attributes:@{NSParagraphStyleAttributeName:ps,NSFontAttributeName:[GlobalFont adapterFont:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    CGSize size =[attr boundingRectWithSize:CGSizeMake(WidthRatioFrom375(280), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    UILabel *tipLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0,WidthRatioFrom375(300),size.height+40)];
    tipLabel.numberOfLines =-1;
    tipLabel.attributedText =attr;
//    tipLabel.textAlignment =NSTextAlignmentCenter;
//    tipLabel.text =tipTitle;
    tipLabel.layer.cornerRadius =5.0;
    tipLabel.clipsToBounds =YES;
    //tipLabel.font =[UIFont systemFontOfSize:17];
    tipLabel.backgroundColor =[UIColor whiteColor];
//    tipLabel.textColor =[UIColor darkGrayColor];
    [backgroundView addSubview:tipLabel];
    tipLabel.center =backgroundView.center;
    backgroundView.alpha =0.1;
    //[currentController.view addSubview:backgroundView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:backgroundView];
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha =0.9;
    }];
    dispatch_time_t time_t =dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*interval);
    dispatch_after(time_t, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            backgroundView.alpha =0.1;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
        }];
    });
}

+(void)showSmallTipFromBottom:(NSString *)tipTitle hideAfter:(NSTimeInterval)interval{
    if (!tipTitle||tipTitle.length==0) {
        return;
    }
    CGRect secreenRect =[UIScreen mainScreen].bounds;
    CGSize textSize =[JCY_Global sizeForNoticeTitle:tipTitle font:[UIFont systemFontOfSize:15] limitSize:CGSizeZero];
    textSize.width+=10;
    textSize.height +=6;
    UILabel *textLabel =[[UILabel  alloc] initWithFrame:CGRectMake((secreenRect.size.width-textSize.width)/2.0, secreenRect.size.height, textSize.width, textSize.height)];
    textLabel.font =[UIFont systemFontOfSize:15];
    textLabel.textColor =[UIColor darkGrayColor];
    textLabel.text =tipTitle;
    textLabel.textAlignment =NSTextAlignmentCenter;
    //
    textLabel.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    textLabel.alpha =0.95;
    textLabel.layer.cornerRadius =3.0;
    textLabel.clipsToBounds =YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:textLabel];
    //上滑隐藏
    [UIView animateWithDuration:0.3 animations:^{
        //textLabel.alpha =0;
        CGRect rect =textLabel.frame;
        rect.origin.y -=100;
        textLabel.frame =rect;
    } completion:^(BOOL finished) {
        //
        dispatch_time_t time_t =dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*interval);
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                textLabel.alpha =0.1;
            } completion:^(BOOL finished) {
                [textLabel removeFromSuperview];
            }];
        });
    }];
}

+(UIImage*)drawCircleInRect:(CGRect)rect borderColor:(UIColor*)color borderWidth:(CGFloat)width fillColor:(UIColor*)fillColor{
    CGPoint centerPoint =CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius =rect.size.width>rect.size.height?rect.size.height/2.0:rect.size.width/2.0;
    radius=radius-width*2;
    if (radius<=0) {
        return nil;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);  //线宽
    BOOL isStroke =NO;
    CGPathDrawingMode mode =kCGPathStroke;
    if (color) {
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);//线颜色
        isStroke =YES;
        mode =kCGPathStroke;
    }
    if (fillColor) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), fillColor.CGColor);
        if (isStroke) {
            mode =kCGPathFillStroke;
        }
        else{
            mode =kCGPathFill;
        }
    }
    //画圆
    CGContextAddArc(UIGraphicsGetCurrentContext(), centerPoint.x, centerPoint.y,radius , 0, M_PI*2, NO);
    CGContextDrawPath(UIGraphicsGetCurrentContext(), mode);
    UIImage* backImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return backImage;
}

+(UIImage*)drawClosedPolygonsInRect:(CGRect)rect borderColor:(UIColor*)color fillColor:(UIColor*)fillColor borderWidth:(CGFloat)width points:(NSArray*)points{
    UIGraphicsBeginImageContext(rect.size);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);  //线宽
    BOOL isStroke =NO;
    CGPathDrawingMode mode =kCGPathStroke;
    if (color) {
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);//线颜色
        isStroke =YES;
        mode =kCGPathStroke;
    }
    if (fillColor) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), fillColor.CGColor);
        if (isStroke) {
            mode =kCGPathFillStroke;
        }
        else{
            mode =kCGPathFill;
        }
    }
    //画多型
    for(int idx = 0; idx < points.count; idx++)
    {
        CGPoint point = [[points objectAtIndex:idx] CGPointValue];//Edited
        if(idx == 0)
        {
            // move to the first point
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        }
        else
        {
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        }
    }
    if (mode!=kCGPathStroke) {
        CGContextClosePath(UIGraphicsGetCurrentContext());
    }
    CGContextDrawPath(UIGraphicsGetCurrentContext(), mode);
    UIImage* backImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return backImage;
}

+(NSString*)changeChineseIntoPinyin:(NSString*)aString{
    //参考http://www.cocoachina.com/bbs/read.php?tid-292560.html
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //再转换为不带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);//这一句不能少，否则下面一句没效果
    CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO);
    return str;
}

+(NSString *)firstCharactorOfChineseString:(NSString *)aString
{
    NSString *str =[JCY_Global changeChineseIntoPinyin:aString];
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+(NSString *)md5StringWithString:(NSString*)sourceSting
{
    if(!sourceSting)
        return nil;
    const char *str = [(NSString *)sourceSting UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

+(BOOL)checkPhoneNumInput:(NSString*)phoneNumber{
    
    NSString * MOBILE = @"^1([37][0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    BOOL res2 = [regextestcm evaluateWithObject:phoneNumber];
    BOOL res3 = [regextestcu evaluateWithObject:phoneNumber];
    BOOL res4 = [regextestct evaluateWithObject:phoneNumber];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//字符串 整形判断
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//字符串浮点形判断：
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
//获取view对应的controller
+ (UIViewController *)viewControllerForView:(UIView*)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (NSString *)toJSONData:(id)theData{
    
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:theData
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    NSString *jsonString = [[NSString alloc] initWithData:result
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}
//计算经纬度距离(km)
+(CGFloat)distanceFromLocation:(CLLocation*)srcLocation dstLocation:(CLLocation*)dstLocation{
    CLLocationDistance kilometers=[srcLocation distanceFromLocation:dstLocation]/1000.0;
    return kilometers;
}

+(NSString*)translateDateToString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString*)translateTimeNumToDate:(unsigned long)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [JCY_Global translateDateToString:date];
}
+(unsigned long)translateDateToTimeNum:(NSString*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:date];
    return destDate.timeIntervalSince1970;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)fixImageUpOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
