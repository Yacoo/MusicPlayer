//
//  SFRequest.h
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef void (^DPSuccess)(id json);
typedef void (^DPFailure)(NSError * error);
@interface SFRequest : NSObject
- (AFHTTPRequestOperation *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure;
@end
