//
//  SFContentItemModel.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFContentItemModel : NSObject
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * comment;
@property (nonatomic,copy)NSString * web_url;
@property (nonatomic,copy)NSString * pic_s192;
@property (nonatomic,copy)NSString * pic_s444;
@property (nonatomic,copy)NSString * pic_s260;
@property (nonatomic,copy)NSString * pic_s210;
@property (nonatomic,copy)NSArray * content;
@end
