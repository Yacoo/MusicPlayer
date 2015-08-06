//
//  SongInfo.h
//  MusicPlayer
//
//  Created by lanou3g on 14-8-6.
//  Copyright (c) 2014年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject
@property (nonatomic, strong)NSString * album_id;
@property (nonatomic, strong)NSString * album_no;
@property (nonatomic, strong)NSString * album_title;
@property (nonatomic, strong)NSString * all_rate;
@property (nonatomic, strong)NSString * area;
@property (nonatomic, strong)NSString * artist_id;
@property (nonatomic, strong)NSString * author;
@property (nonatomic, strong)NSString * file_duration;
@property (nonatomic, strong)NSString * high_rate;

@property (nonatomic, strong)NSString * is_first_publish;
@property (nonatomic, strong)NSString * language;
@property (nonatomic, strong)NSString * lrclink;
@property (nonatomic, strong)NSString * pic_premium;
@property (nonatomic, strong)NSString * resource_type_ext;
@property (nonatomic, strong)NSString * song_id;
@property (nonatomic, strong)NSString * song_source;
@property (nonatomic, strong)NSString * ting_uid;
@property (nonatomic, strong)NSString * title;


- (instancetype)initWithDictionary:(NSMutableDictionary *)dic;
@end
