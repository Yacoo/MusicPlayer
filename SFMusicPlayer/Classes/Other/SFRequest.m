//
//  SFRequest.m
//  SFMusicPlayer
//
//  Created by yake on 15-3-30.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "SFRequest.h"

@implementation SFRequest

- (AFHTTPRequestOperation *)request:(NSString *)url params:(NSDictionary *)params success:(DPSuccess)success failure:(DPFailure)failure
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   AFHTTPRequestOperation * operation = [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    return operation;
}
@end
