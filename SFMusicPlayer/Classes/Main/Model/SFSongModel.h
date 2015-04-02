//
//  SFSongModel.h
//  SFMusicPlayer
//
//  Created by yake on 15-4-2.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSongModel : NSObject
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * song_id;
@property (nonatomic,copy)NSString * author;
@property (nonatomic,copy)NSString * album_id;
@property (nonatomic,copy)NSString * album_title;
@property (nonatomic,copy)NSString * ting_uid;
@property (nonatomic,copy)NSString * is_first_publish;
@property (nonatomic,copy)NSString * share;

@end
