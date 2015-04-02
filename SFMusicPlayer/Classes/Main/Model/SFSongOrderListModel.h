//
//  SFSongOrderListModel.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-2.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSongModel.h"

@interface SFSongOrderListModel : NSObject

@property (nonatomic,copy)NSString * listid;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * pic_300;
@property (nonatomic,copy)NSString * pic_500;
@property (nonatomic,copy)NSString * pic_w700;
@property (nonatomic,copy)NSString * listenum;
@property (nonatomic,copy)NSString * collectnum;
@property (nonatomic,copy)NSString * tag;
@property (nonatomic,copy)NSString * desc;
@property (nonatomic,copy)NSString * url;
@property (nonatomic, strong)NSMutableArray * content;
@end
