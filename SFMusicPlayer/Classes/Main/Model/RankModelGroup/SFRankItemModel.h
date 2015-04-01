//
//  SFRankItemModel.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFRankItemModel : NSObject
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * author;
@property (nonatomic,copy)NSString * song_id;
@property (nonatomic,copy)NSString * album_id;
@property (nonatomic,copy)NSString * album_title;
@property (nonatomic,copy)NSString * rank_change;
@property (nonatomic,copy)NSString * all_rate;

@end
