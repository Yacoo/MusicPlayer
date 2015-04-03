//
//  SFRecViewController.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-26.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFRecViewController : UIViewController

@property (nonatomic, strong)UIScrollView * randomScrollview;
@property (nonatomic, strong)UIPageControl * pageControl;
@property (nonatomic, strong)UICollectionView * recCollection;
@property (nonatomic, strong)NSMutableArray * showImageviewArray;
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, strong)NSMutableArray * randPicModelArray;
@property (nonatomic, strong)NSMutableArray * songOrderArray;
@property (nonatomic, strong)NSMutableArray * discOnlineArray;
- (void)addTimer;
@end
