//
//  SFContentItemModel.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-31.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFContentItemModel.h"
#import <MJExtension.h>
#import "SFRankItemModel.h"

@implementation SFContentItemModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"content" : [SFRankItemModel class]};
}
@end
