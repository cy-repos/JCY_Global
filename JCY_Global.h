//
//  JCY_Global.h
//  MiMi
//
//  Created by WsdlDev on 15/12/3.
//  Copyright © 2015年 mazengyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JCY_Global : NSObject
//计算字符串的长度和宽度
+ (CGSize)sizeForNoticeTitle:(NSString*)text font:(UIFont*)font limitSize:(CGSize)limitSize;
+ (CGSize)sizeForMoreLineNoticeTitle:(NSString*)text font:(UIFont*)font limitSize:(CGSize)limitSize;
//根据矩形大小和文字长度，计算最合适的字体（一定是小于等于basefontsize）
+ (CGFloat)fontSizeWithRectSize:(CGSize)rSize text:(NSString*)text baseFontSize:(CGFloat)baseFontSize;
//绘制类似badge view一样的view
+(void)drawViewCircleBackground:(UIView*)view backgroundColor:(UIColor*)backColor text:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)textFont;
//绘制分割线背景
+(UIImage*)drawViewSeperateLineBackgorund:(CGSize)size lineWidth:(CGFloat)lineWidth lineColor:(UIColor*)lineColor fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
//按比例缩放,size是你要把图显示到多大区域。当图像高度大于宽度，则优先考虑填满宽度；否则相反
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//获取当前的presentcontroller
+(UIViewController*)getCurrentPresentController;
//显示警告命令框
+(void)alertWithTitle:(NSString*)title msg:(NSString*)msg action:(id)handler;
//显示提示框（规定时间内自动隐藏）(放在中心)
+(void)showTip:(NSString *)tipTitle hideAfter:(NSTimeInterval)interval;
//从底部显示提示框
+(void)showSmallTipFromBottom:(NSString *)tipTitle hideAfter:(NSTimeInterval)interval;
//绘制圆
+(UIImage*)drawCircleInRect:(CGRect)rect borderColor:(UIColor*)color borderWidth:(CGFloat)width fillColor:(UIColor*)fillColor;
//绘制多边形（边或填充）
+(UIImage*)drawClosedPolygonsInRect:(CGRect)rect borderColor:(UIColor*)color fillColor:(UIColor*)fillColor borderWidth:(CGFloat)width points:(NSArray*)points;
//获取汉字的拼音
+(NSString*)changeChineseIntoPinyin:(NSString*)astring;
//获取汉字拼音的首字母（大写）
+(NSString*)firstCharactorOfChineseString:(NSString*)astring;
//将字符串传为md5加密的字符串
+(NSString *)md5StringWithString:(NSString*)sourceSting;
//将unsigned char转为nsstring
//+(NSString*)convertUnsignedChar2String:(unsigned char *)bytes;
//判断手机输入时候有效
+(BOOL)checkPhoneNumInput:(NSString*)phoneNumber;
//字符串 整形判断
+(BOOL)isPureInt:(NSString *)string;
//字符串浮点形判断：
+(BOOL)isPureFloat:(NSString *)string;
//获取view对应的controller
+ (UIViewController *)viewControllerForView:(UIView*)view;
//将数转换为joson
+ (NSString *)toJSONData:(id)theData;
//计算经纬度距离(km)
+(CGFloat)distanceFromLocation:(CLLocation*)srcLocation dstLocation:(CLLocation*)dstLocation;
//将日期转换为字符串
+(NSString*)translateDateToString:(NSDate*)date;
//将时间戳转换成日期字符串
+(NSString*)translateTimeNumToDate:(unsigned long)time;
//将日期转换为时间戳
+(unsigned long)translateDateToTimeNum:(NSString*)date;
//根据颜色创建image
+ (UIImage *)createImageWithColor:(UIColor *)color;
//解决图片90旋转问题
+ (UIImage *)fixImageUpOrientation:(UIImage *)aImage ;
@end
