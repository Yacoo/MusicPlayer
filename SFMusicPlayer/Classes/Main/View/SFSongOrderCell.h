//
//  SFSongOrderCell.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-24.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFSongOrderModel;
@class SFSongItemModel;

@interface SFSongOrderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *songOrderImage;
@property (weak, nonatomic) IBOutlet UILabel *listenNum;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (nonatomic, strong)SFSongOrderModel * songOrderModel;
@property (nonatomic, strong)SFSongItemModel * songItemModel;

@end
