//
//  SongInfo.h
//  MusicPlayer
//
//  Created by lanou3g on 14-8-6.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject
@property (nonatomic, strong)NSString * author;
@property (nonatomic, strong)NSString * lrclink;
@property (nonatomic, strong)NSString * pic_radio;
@property (nonatomic, strong)NSString * file_link;
@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * ting_uid;
@property (nonatomic, strong)NSString * song_id;
@property (nonatomic, strong)NSString * file_duration;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dic;
@end
