//
//  SFRecItemCell.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFDiscModel;

@interface SFRecItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recImage;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (nonatomic, strong)SFDiscModel * discModel;

@end
