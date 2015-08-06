//
//  SFPlayIndicatorView.m
//  SFMusicPlayer
//
//  Created by yake on 15/8/6.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFPlayIndicatorView.h"

@implementation SFPlayIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviews];
    }
    return self;
    
}
- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.95;
    self.layer.cornerRadius = 7.0;
     UILabel *  indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
    indicatorLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.font = [UIFont systemFontOfSize:12.0];
    indicatorLabel.text = @"0.02";
    indicatorLabel.textColor = YKColor(34, 145, 231);
    indicatorLabel.tag = 100;
    [self addSubview:indicatorLabel];
}

- (void)setCurrentPlayTime:(NSString *)currentPlayTime
{
    UILabel * indicatorLabel = (UILabel *)[self viewWithTag:100];
    _currentPlayTime = currentPlayTime;
    indicatorLabel.text = currentPlayTime;
}
@end
