//
//  MyWindow.h
//  WKAlertViewDemo
//
//  Created by kt on 15-3-11.
//  Copyright (c) 2015年 keenteam. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @Author kt
 *
 *  点击样式
 */
typedef NS_ENUM(NSInteger, MyWindowClick){
    /**
     *  @Author kt
     *
     *  点击确定按钮
     */
    MyWindowClickForOK = 0,
    /**
     * @Author kt
     *
     *  点击取消按钮
     */
    MyWindowClickForCancel
};

/**
 *  @Author kt
 *
 *  提示框显示样式
 */
typedef NS_ENUM(NSInteger, WKAlertViewStyle)
{

    WKAlertViewStyleDefalut = 0,//默认样式 ——成功

    WKAlertViewStyleSuccess,//成功

    WKAlertViewStyleFail,//失败

    WKAlertViewStyleWaring//警告
};

typedef void (^callBack)(MyWindowClick buttonIndex);


@interface WKAlertView : UIWindow

@property (nonatomic, copy) callBack clickBlock ;//按钮点击事件的回调

+ (instancetype)shared;

/**
 *  @Author kt
 *
 *  创建AlertView并展示
 *
 *  @param style    绘制的图片样式
 *  @param title    警示标题
 *  @param detail   警示内容
 *  @param canle    取消按钮标题
 *  @param ok       确定按钮标题
 *  @param callBack 按钮点击时间回调
 *
 *  @return 返回AlertView
 */
+ (instancetype)showAlertViewWithStyle:(WKAlertViewStyle)style title:(NSString *)title detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok callBlock:(callBack)callBack;
//默认样式创建AlertView
+ (instancetype)showAlertViewWithTitle:(NSString *)title detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok callBlock:(callBack)callBack;

@end