//
//  SFRankCell.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-24.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFRankItemModel;
@class SFContentItemModel;

@interface SFRankCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankOrderImage;
@property (weak, nonatomic) IBOutlet UIButton *discButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (nonatomic, strong)SFContentItemModel * contentItemModel;
@end
