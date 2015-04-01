//
//  SFDiscModel.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFDiscModel : NSObject
@property (nonatomic,copy)NSString * album_id;
@property (nonatomic,copy)NSString * artist_id;
@property (nonatomic,copy)NSString * all_artist_id;
@property (nonatomic,copy)NSString * author;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * publishcompany;
@property (nonatomic,copy)NSString * country;
@property (nonatomic,copy)NSString * pic_small;
@property (nonatomic,copy)NSString * pic_big;
@property (nonatomic,copy)NSString * pic_radio;
@property (nonatomic,copy)NSString * songs_total;
@property (nonatomic,copy)NSString * is_recommend_mis;
@property (nonatomic,copy)NSString * is_first_publish;
@property (nonatomic,copy)NSString * is_exclusive;
@end
