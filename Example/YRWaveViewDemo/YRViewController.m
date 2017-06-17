//
//  YRViewController.m
//  YRWaveViewDemo
//
//  Created by TangChangTomYang on 06/17/2017.
//  Copyright (c) 2017 TangChangTomYang. All rights reserved.
//

#import "YRViewController.h"
#import "YRWavyView.h"

@interface YRViewController ()


@property (nonatomic,strong)YRWavyView *wavyView;
@property (weak, nonatomic) IBOutlet UILabel *speedLb;
@property (weak, nonatomic) IBOutlet UILabel *hightLb;
@property (weak, nonatomic) IBOutlet UILabel *centeryLb;

@end

@implementation YRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //第二个波浪
    self.wavyView = [YRWavyView wavyViewWithFrame:CGRectMake(100, 100, 100, 100)
                                           colors:@[[UIColor redColor],
                                                    [UIColor purpleColor],
                                                    [UIColor greenColor],
                                                    [UIColor orangeColor]
                                                    ]
                     ];
    __weak typeof(self) weakSelf = self;
    self.wavyView.touchCallBack = ^(BOOL isMoving) {
        
        
        if (isMoving == YES) {
            
            [weakSelf doTouchMovingAction];
        }
        else{
        
            [weakSelf doTouchStopAction];
        }
    } ;
    
    self.wavyView.alpha=0.6;
    [self.view addSubview:self.wavyView];
    
    
    
}

#pragma mark- 点击控制 波浪
-(void)doTouchMovingAction{
    NSLog(@" 回调  开始");
}

-(void)doTouchStopAction{
    NSLog(@" 回调  停止");
}


#pragma mark- 其他方式控制波浪
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    static int i  =0;
    
    if (i == 0) {
        [self.wavyView start];
        i = 1;
    }else{
        [self.wavyView end];
        i = 0;
    }
}
- (IBAction)hightChange:(id)sender {
    
    [self.wavyView start];
    
    UISlider * slider = (UISlider *)sender;
    self.wavyView.wave_amplitude = self.wavyView.Max_amplitude * slider.value;
    self.speedLb.text = [NSString stringWithFormat:@"%f 高度",self.wavyView.wave_amplitude];
}

- (IBAction)SpeedChange:(id)sender {
    [self.wavyView start];
    
    UISlider * slider = (UISlider *)sender;
    self.wavyView.wavesSpeed = YRWavyView_Max_Speed * slider.value;
    self.speedLb.text = [NSString stringWithFormat:@"%f 倍速",self.wavyView.wavesSpeed ];
}

- (IBAction)centerYChange:(id)sender {
    
    [self.wavyView start];
    
    UISlider * slider = (UISlider *)sender;
    self.wavyView.waveCenterY = self.wavyView.frame.size.height * slider.value;
    self.speedLb.text = [NSString stringWithFormat:@"%f ",self.wavyView.waveCenterY];
}

@end
