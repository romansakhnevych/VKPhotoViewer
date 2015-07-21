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
#import "AFHTTPRequestOperation.h"
#import "Constants.h"


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

- (void)getUsersMainPhoto:(NSString *)photoLink completion:(void (^)(UIImage *image))imageSet{
    
    AFHTTPRequestOperation *lRequest = [[AFHTTPRequestOperation alloc] initWithRequest:[EERequests getPhotoRequestByLink:photoLink]];
    lRequest.responseSerializer = [AFImageResponseSerializer serializer];
    [lRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        imageSet(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error - %@",error);
    }];
    [lRequest start];
}

- (void)getUserInfoWithId:(NSString *)ID{
    
    NSString *lUserInfoUrl = [EERequests getUserInfoRequestWithId:ID];
    AFHTTPSessionManager *lManager = [AFHTTPSessionManager manager];
    lManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [lManager GET:lUserInfoUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *lDetailsArray = [responseObject objectForKey:@"response"];
        [lDetailsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            _userName = [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"first_name"],[obj objectForKey:@"last_name"]];
        
            _mainPhotoLink = [obj objectForKey:@"photo_200_orig"];
            _photosCount = [[obj objectForKey:@"counters"] objectForKey:@"photos"];
            _albumsCount = [[obj objectForKey:@"counters"] objectForKey:@"albums"];
        }];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        return;
    }];
}

@end
