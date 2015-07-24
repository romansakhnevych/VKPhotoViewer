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

- (void)getFriendsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure {
    
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



- (void)getDetailForUserWithCompletionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
                            completionFailure:(void (^)(NSError * error))failure {
    
    NSString *lDetailRequestString = [EERequests getUserInfoRequestWithId:_currentFriend.userId];
    
    AFHTTPSessionManager *lManager = [AFHTTPSessionManager manager];
    lManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [lManager GET:lDetailRequestString parameters:nil success:^(NSURLSessionDataTask *task, id responseObjet) {
        
        NSArray *lUserDetailResponse = [responseObjet objectForKey:@"response"];
        _currentFriend = [EEResponseBilder getDetailFromArray:lUserDetailResponse forUser:_currentFriend];
        success(YES, _currentFriend);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)getPhotoByLink:(NSString *)photoLink
        withCompletion:(void (^)(UIImage *image, BOOL animated))setImage{
    
    _cache = [[EGOCache alloc] init];
    if([_cache imageForKey:photoLink]){
        setImage([_cache imageForKey:photoLink],NO);
    }
    else{
        
        NSMutableURLRequest *lRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:photoLink] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        
        AFHTTPRequestOperation *lOperation = [[AFHTTPRequestOperation alloc] initWithRequest:lRequest];
        lOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [lOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_cache setImage:responseObject forKey:photoLink];
            setImage(responseObject,YES);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        [lOperation start];
    }
     
}

@end
