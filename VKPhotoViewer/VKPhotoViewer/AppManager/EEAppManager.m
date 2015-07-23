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

#import "UIImageView+AFNetworking.h"

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



- (void)getDetailForUserWithCompletionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success completionFailure:(void (^)(NSError * error))failure {
    
    NSString *lDetailUrl = [EERequests getUserInfoRequestWithId:_currentFriend.userId];
    AFHTTPSessionManager *lManager = [AFHTTPSessionManager manager];
    lManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [lManager GET:lDetailUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObjet) {
        
        NSArray *lUserDetailResponse = [responseObjet objectForKey:@"response"];
        [lUserDetailResponse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            _currentFriend.photosCount = [[obj objectForKey:@"counters"] objectForKey:@"photos"];
            _currentFriend.albumsCount = [[obj objectForKey:@"counters"] objectForKey:@"albums"];
            _currentFriend.city = [[obj objectForKey:@"city"] objectForKey:@"title"];
            _currentFriend.country = [[obj objectForKey:@"country"] objectForKey:@"title"];
                    }];
        
        success(YES, _currentFriend);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

- (void)getPhotoByLink:(NSString *)photoLink withCompletion:(void (^)(UIImage *image))setImage{
    
    NSMutableURLRequest *lRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:photoLink] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    UIImageView *lImageView = [[UIImageView alloc] init];
    [lImageView setImageWithURLRequest:lRequest
                      placeholderImage:[UIImage imageNamed:@"placeholder_png.jpg"]
                               success:^(NSURLRequest * request, NSHTTPURLResponse *response, UIImage *image) {
        setImage(image);
    }
                               failure:nil];
    
}

@end
