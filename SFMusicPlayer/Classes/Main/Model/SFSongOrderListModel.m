//
//  SFSongOrderListModel.m
//  SFMusicPlayer
//
//  Created by yake on 15-4-2.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFSongOrderListModel.h"
#import <MJExtension.h>
#import "SFSongModel.h"

@implementation SFSongOrderListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"content" : [SFSongModel class]};
}

@end
