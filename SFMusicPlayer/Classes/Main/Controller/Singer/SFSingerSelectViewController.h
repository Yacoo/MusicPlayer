//
//  SFSingerSelectViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-4.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingerSelectDelegate<NSObject>
- (void)selectSingerWithClickedButton:(UIButton *)button;
@end
@interface SFSingerSelectViewController : UIViewController<UITableViewDelegate>
@property (nonatomic, assign)id<SingerSelectDelegate>selectDelegate;
@end
