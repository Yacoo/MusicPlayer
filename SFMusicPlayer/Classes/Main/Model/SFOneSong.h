//
//  SFOneSong.h
//  SFMusicPlayer
//
//  Created by yake on 15/8/6.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFOneSong : NSObject
@property (nonatomic, strong)NSString * error_code;
@property (nonatomic, strong)NSDictionary * songinfo;
@property (nonatomic, strong)NSDictionary * songurl;

@end
