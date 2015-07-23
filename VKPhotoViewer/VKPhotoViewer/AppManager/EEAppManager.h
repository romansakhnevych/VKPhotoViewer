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

@interface EEAppManager : NSObject

@property (nonatomic,retain)NSMutableArray *friendsList;
@property (nonatomic,retain)EEFriends *currentFriend;


+ (EEAppManager *)sharedAppManager;
 
- (void)getFriendsWithCount:(NSUInteger)count
                     offset:(NSUInteger)offset
          completionSuccess:(void (^)(id responseObject))success
          completionFailure:(void (^)(NSError * error))failure;



- (void)getDetailForUserWithCompletionSuccess:(void (^)(BOOL successLoad, EEFriends *friendModel))success
       completionFailure:(void (^)(NSError * error))failure;


- (void)getPhotoByLink:(NSString *)photoLink withCompletion:(void (^)(UIImage *image))setImage;

@end
