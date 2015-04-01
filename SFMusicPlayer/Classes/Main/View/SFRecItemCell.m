//
//  SFRecItemCell.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRecItemCell.h"
#import <UIImageView+WebCache.h>
#import "SFDiscModel.h"

@implementation SFRecItemCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setDiscModel:(SFDiscModel *)discModel
{
    _discModel = discModel;
    [self.recImage sd_setImageWithURL:[NSURL URLWithString:discModel.pic_big] placeholderImage:[UIImage imageNamed:@"123"]];
    self.songName.text = discModel.title;
    self.singerName.text = discModel.author;
    
}
@end
