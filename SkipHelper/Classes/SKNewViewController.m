//
//  SKNewViewController.m
//  SkipHelper
//
//  Created by kdatm on 2018/5/18.
//  Copyright © 2018年 kdatm. All rights reserved.
//

#import "SKNewViewController.h"
#import "UIImageView+WebCache.h"
#define SKScreenWidth [UIScreen mainScreen].bounds.size.width
#define SKScreenHeight [UIScreen mainScreen].bounds.size.height
@interface SKNewViewController ()
@property (nonatomic,strong)UIImageView *backgroudImage;
@property (nonatomic,strong)UIButton *startBtn;
@end
@implementation SKNewViewController

- (UIImageView *)backgroudImage {
    if (!_backgroudImage) {
        _backgroudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _backgroudImage;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:241/255.0 alpha:1];
        [_startBtn setTitle:@"开始赚钱" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _startBtn.layer.masksToBounds = YES;
        _startBtn.layer.cornerRadius = 10;
    }
    return _startBtn;
}

- (void)startBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    if (_clickUrl.length>0) {
        [self goSafari:self.clickUrl];
    }
    [self performSelector:@selector(enableSender) withObject:nil afterDelay:2];
}

- (void)enableSender {
    self.startBtn.enabled = YES;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
     [self initFrame];
     [self addViews];
}

- (void)goSafari:(NSString *)myUrl{
    
    NSURL *url = [NSURL URLWithString:[myUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) setBackImageUrl:(NSString *)backImageUrl {
    [self.backgroudImage sd_setImageWithURL:[NSURL URLWithString:backImageUrl]];
}

- (void)initFrame {
    self.backgroudImage.frame = CGRectMake(0,0, SKScreenWidth, SKScreenHeight);
    
    self.startBtn.frame = CGRectMake(SKScreenWidth/5, SKScreenHeight-50-40, SKScreenWidth*3/5, 50);
}

- (void)addViews {
    [self.view addSubview:self.backgroudImage];
    [self.view addSubview:self.startBtn];
}


@end
