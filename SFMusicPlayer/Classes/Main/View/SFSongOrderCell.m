//
//  SFSongOrderCell.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-24.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSongOrderCell.h"
#import <UIImageView+WebCache.h>
#import "SFSongOrderModel.h"
#import "SFSongItemModel.h"

@implementation SFSongOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSongOrderModel:(SFSongOrderModel *)songOrderModel
{
    _songOrderModel = songOrderModel;
    [self.songOrderImage sd_setImageWithURL:[NSURL URLWithString:songOrderModel.pic] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"]];
    self.orderNameLabel.text = songOrderModel.title;
    self.listenNum.text = songOrderModel.listenum;
}
- (void)setSongItemModel:(SFSongItemModel *)songItemModel
{
    _songItemModel = songItemModel;
    [self.songOrderImage sd_setImageWithURL:[NSURL URLWithString:songItemModel.pic_300] placeholderImage:[UIImage imageNamed:@"img_default_playlist546"]];
    self.orderNameLabel.text = songItemModel.title;
    self.listenNum.text = songItemModel.listenum;
}
@end
