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




+ (EEAppManager *)sharedAppManager{
   
    static dispatch_once_t once;
    static id sharedAppManager;
    
    dispatch_once(&once, ^{
        sharedAppManager = [[self alloc] init];
    });
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

- (void)getDetailForUser:(EEFriends *)friend{
    
    NSString *lDetailUrl = [EERequests getUserInfoRequestWithId:friend.userId];
    AFHTTPSessionManager *lManager = [AFHTTPSessionManager manager];
    lManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [lManager GET:lDetailUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObjet) {
        
        NSArray *lUserDetailResponse = [responseObjet objectForKey:@"response"];
        [lUserDetailResponse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            EEFriends *user = [[EEFriends alloc] init];
            friend.photosCount = [[obj objectForKey:@"counters"] objectForKey:@"photos"];
            friend.albumsCount = [[obj objectForKey:@"counters"] objectForKey:@"albums"];
            friend.cityId = [obj objectForKey:@"city"];
                    }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    _currentFriend = friend;

    
}


@end
