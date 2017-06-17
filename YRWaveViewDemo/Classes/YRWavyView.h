//
//  SecondView.h
//  DoubleWavesAnimation
//
//  Created by anyongxue on 2016/12/12.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRWavyView_Header.h"

@interface YRWavyView : UIView

@property(nonatomic, assign)CGFloat wavesSpeed;//水纹速度
@property(nonatomic, assign)CGFloat wave_amplitude ;//设置振幅
@property(nonatomic, assign)CGFloat wave_period ;//水纹周期
@property(nonatomic, assign)CGFloat waveCenterY; //波浪的中间点位置
@property(nonatomic, assign,readonly)CGFloat Max_amplitude; //最大的振幅高度
@property(nonatomic, assign,readonly)BOOL isMoving;

/** 如果需要处理点击事件 就 设置block, 不需要就不设置  */
@property(nonatomic, copy)void(^touchCallBack)(BOOL isMoving);

+(instancetype)wavyViewWithFrame:(CGRect)frame colors:(NSArray <UIColor *> *)colors ;



-(void)start;
-(void)end;
@end
