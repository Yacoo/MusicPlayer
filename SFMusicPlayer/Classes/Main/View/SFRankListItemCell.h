//
//  SFRankListItemCell.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-3.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFRankListItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end
