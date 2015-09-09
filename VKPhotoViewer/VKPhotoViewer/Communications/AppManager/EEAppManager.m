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
#import "EENetworkManager.h"

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
    
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests friendsGetRequestWithOffset:offset count:count] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        DLog(@"DEBUG - %@",responseObject);
        NSArray *lArray = [responseObject objectForKey:@"response"];
        NSMutableArray *lFriendsList = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getFriendsFromArray:lArray]];
        success(lFriendsList);
        
    } failure:^ (NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getDetailForUserWithCompletionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
                            completionFailure:(void (^)(NSError * error))failure {
    
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests getUserInfoRequestWithId:_currentFriend.userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        NSArray *lUserDetailResponse = [responseObject objectForKey:@"response"];
        _currentFriend = [EEResponseBilder getDetailFromArray:lUserDetailResponse forUser:_currentFriend];
        success(YES, _currentFriend);
    } failure:^ (NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getPhotoByLink:(NSString *)photoLink
        withCompletion:(void (^)(UIImage *image, BOOL animated))setImage {
    
    _cache = [[EGOCache alloc] init];
    if([_cache imageForKey:photoLink] != nil) {
        setImage([_cache imageForKey:photoLink],NO);
        
    } else{
        
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

- (void)getAlbumsWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                        Id:(NSString *)userId
         completionSuccess:(void (^)(id))success
         completionFailure:(void (^)(NSError *))failure {
    
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests getAlbumsRequestWithOffset:offset count:count byId:userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        NSArray *lArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
        NSMutableArray *lAlbums = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getAlbumsFromArray:lArray]];
        success(lAlbums);
    } failure:^ (NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getPhotosWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                 fromAlbum:(NSString *)albumId
                   forUser:(NSString *)userId
         completionSuccess:(void (^)(id responseObject))success
         completionFailure:(void (^)(NSError * error))failure{
    
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests getPhotosRequestWithOffset:offset count:count fromAlbum:albumId forUser:userId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        NSArray *lArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
        NSMutableArray *lPhotos = [[NSMutableArray alloc] initWithArray:[EEResponseBilder getPhotosFromArray:lArray]];
        success(lPhotos);
    } failure:^ (NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)addLikeForCurrentFriendPhotoWithCompletionSuccess:(void (^)(id responseObject))success
                                        completionFailure:(void (^)(NSError * error))failure{
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests addLikeWithOwnerId:_currentFriend.userId itemId:_currentPhoto.photoId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^ (NSURLSessionDataTask *task, NSError *error ) {
        failure(error);
    }];
}

- (void)deleteLikeForCurrentFriendPhotoWithCompletionSuccess:(void (^)(id responseObject))success
                                           completionFailure:(void (^)(NSError * error))failure{
    EENetworkManager *lManager = [EENetworkManager sharedManager];
    [lManager GET:[EERequests deleteLikeWithOwnerId:_currentFriend.userId itemId:_currentPhoto.photoId] parameters:nil success:^ (NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^ (NSURLSessionDataTask *task, NSError *error ) {
        failure(error);
    }];

}

@end
