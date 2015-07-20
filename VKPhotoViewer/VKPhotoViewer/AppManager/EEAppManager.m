//
//  EEAppManager.m
//  VKPhotoViewer
//
//  Created by admin on 7/20/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEAppManager.h"
#import "EERequests.h"
#import "EEResponseBilder.h"
#import "AFHTTPSessionManager.h"

@implementation EEAppManager


static EEAppManager *sharedAppManager = NULL;

+ (EEAppManager *)sharedAppManager{
    
    if (!sharedAppManager || sharedAppManager == NULL){
        sharedAppManager = [EEAppManager new];
    }
    
    return sharedAppManager;
}

- (void)getFriendsWithCount:(NSUInteger)count offset:(NSUInteger)offset completionSuccess:(void (^)(id responseObject))success completionFailure:(void (^)(NSError * error))failure {
    _friendsList = [[NSMutableArray alloc] init];
    NSString *lGetFriendsURL = [EERequests friendsGetRequestWithOffset:offset count:count];
    AFHTTPSessionManager *lManager = [AFHTTPSessionManager manager];
    lManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [lManager GET:lGetFriendsURL parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *lArray = [responseObject objectForKey:@"response"];
        NSMutableArray *lFriendsList = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getFriendsFromArray:lArray]];
        success(lFriendsList);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(error);
    }];
}

@end
