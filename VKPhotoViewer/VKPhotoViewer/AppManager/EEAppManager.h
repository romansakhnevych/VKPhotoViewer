//
//  EEAppManager.h
//  VKPhotoViewer
//
//  Created by admin on 7/20/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EEFriends.h"
#import "EEAlbum.h"
#import "EGOCache.h"
#import "EEPhoto.h"

@interface EEAppManager : NSObject


@property (nonatomic,retain)EEFriends *currentFriend;
@property (nonatomic,retain)EEAlbum *currentAlbum;
@property (nonatomic,retain)EEPhoto *currentPhoto;
@property (nonatomic,retain)NSMutableArray *allPhotos;
@property (nonatomic)NSInteger currentPhotoIndex;
@property (nonatomic,retain)EGOCache *cache;

+ (EEAppManager *)sharedAppManager;
 
- (void)getFriendsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure;

- (void)getDetailForUserWithCompletionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
                            completionFailure:(void (^)(NSError * error))failure;

- (void)getPhotoByLink:(NSString *)photoLink withCompletion:(void (^)(UIImage *image,BOOL animated))setImage;

- (void)getAlbumsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
                         Id:(NSString *)userId
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure;

- (void)getPhotosWithCount:(NSUInteger)count
                    offset:(NSUInteger)offset
                 fromAlbum:(NSString *)albumId
                   forUser:(NSString *)userId
         completionSuccess:(void (^)(id responseObject))success
         completionFailure:(void (^)(NSError * error))failure;

@end
