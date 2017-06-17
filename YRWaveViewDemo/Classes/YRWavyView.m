//
//  SecondView.m
//  DoubleWavesAnimation
//
//  Created by anyongxue on 2016/12/12.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "YRWavyView.h"

@interface YRWavyView ()

@property (nonatomic,strong)CADisplayLink *wavesDisplayLink;

@property(nonatomic, strong)NSMutableArray *layers;
@property(nonatomic, strong)NSArray<UIColor *> *colors;
@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;
@end


@implementation YRWavyView{
    
    CGFloat _offsetX; //位移
    CGFloat _WavesWidth; //水纹宽度
}

-(NSMutableArray *)layers{
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

-(UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        
    }
    return _tapGesture;
}



+(instancetype)wavyViewWithFrame:(CGRect)frame colors:(NSArray <UIColor *> *)colors {
    YRWavyView *wavyView = [[self alloc]initWithFrame:frame];

    wavyView.colors = colors;
    return wavyView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.height *0.5;
        
        _WavesWidth = self.frame.size.width;
        //设置波浪流动速度
        
        self.wavesSpeed = YRWavyView_Max_Speed;
        //设置振幅
        self.wave_amplitude = self.Max_amplitude;
        //设置周期
        self.wave_period = YRWavyView_Max_period;
        
        self.waveCenterY = self.frame.size.height/2.0;
        
        _isMoving = NO;
       
    }
    
    return self;
}

-(CGFloat)Max_amplitude{
   return  self.frame.size.height * 0.5 - 3.0;
}

-(void)setColors:(NSArray<UIColor *> *)colors{
    _colors = colors;
    
    [self removeAllSubLayers];
    
    for (int i = 0; i< colors.count; i++) {
        UIColor *color = colors[i];
        [self addLayerWithColor:color];
    }
    
    [self moveWavyLayers:nil];
}

-(void)setTouchCallBack:(void (^)(BOOL))touchCallBack{
    if (touchCallBack != nil) {
        [self addGestureRecognizer:self.tapGesture];
        _touchCallBack = touchCallBack;
    }
    else{
        [self removeGestureRecognizer:self.tapGesture];
        _touchCallBack = nil;
    
    }
}

-(void)removeAllSubLayers{
    
    if (self.layers.count > 0) {
        
        [self.layers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.layers removeAllObjects];
        self.layers = nil;
        
        [self end];
    }
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tapGesture{

    if (_isMoving == YES) {
        [self end];
    }
    else{
        [self start];
    }
    
    if (self.touchCallBack != nil) {
        self.touchCallBack(self.isMoving);
    }
}

-(void)start{
    if (self.wavesDisplayLink == nil) {
        //启动定时器
        self.wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveWavyLayers:)];
        
        [self.wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
       
    }
    
    
    _isMoving = YES;
}

-(void)end{
    if (self.wavesDisplayLink != nil) {
        [self.wavesDisplayLink invalidate];
        self.wavesDisplayLink = nil;
    }
    
    _isMoving = NO;
}

-(CAShapeLayer *)addLayerWithColor:(UIColor *)color{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = 1.0;
    layer.strokeStart = 0.0;
    layer.strokeEnd = 1;
    
    [self.layer addSublayer:layer];
    [self.layers addObject:layer];
    
    return layer;
}

-(void)moveWavyLayers:(CADisplayLink *)displayLink{
    
    _offsetX += self.wavesSpeed;
    
    [self updateLayersPath];
}

-(void)updateLayersPath{
    
    CGFloat point_Y = self.waveCenterY;
    CGFloat point_X = 0;
    
    for (int a = 0; a < self.layers.count; a++) {
        
        
        CAShapeLayer *layer = self.layers[a];
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        
        CGFloat deltaAngle = a * (M_PI * 0.125 );
        for (NSInteger i = 0; i<=_WavesWidth; i++) {
            
            
            CGFloat currentAngle = self.wave_period * i + _offsetX  + deltaAngle;
            point_Y = self.wave_amplitude * cos(currentAngle) + self.waveCenterY;
            point_X = i;
            
            if (point_X == 0) {
                [bPath moveToPoint:CGPointMake(point_X, point_Y)];
            }else{
                [bPath addLineToPoint:CGPointMake(point_X, point_Y)];
            }
        }
        layer.path = bPath.CGPath;
    }
    
    
}

-(void)dealloc{
    [self end];
  
}


@end
