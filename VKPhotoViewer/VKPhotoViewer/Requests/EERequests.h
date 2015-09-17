//
//  EERequests.h
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSMutableURLRequest* _request;
@interface EERequests : NSObject

+ (NSString *)friendsGetRequestWithOffset:(NSInteger)offset count:(NSInteger)count;
+ (NSMutableURLRequest *)loginRequest;
+ (NSMutableURLRequest *)getPhotoRequestByLink:(NSString *)link;
+ (NSString *)getUserInfoRequestWithId:(NSString *)ID;
+ (NSString *)getAlbumWithId:(NSString* )albumId
                     forUser:(NSString *)userId;
+ (NSString *)getAlbumsRequestWithOffset:(NSInteger)offset count:(NSInteger)count byId:(NSString *)userID;
+ (NSString *)getPhotosRequestWithOffset:(NSInteger)offset count:(NSInteger)count fromAlbum:(NSString *)albumId forUser:(NSString *)userId;
+ (NSString *)addLikeWithOwnerId:(NSString *)ownerId itemId:(NSString *)itemId;
+ (NSString *)deleteLikeWithOwnerId:(NSString *)ownerId itemId:(NSString *)itemId;
+ (NSString *)postPhotoWithOwnerId:(NSString *)ownerId PhotoId:(NSString*)photoId FriendId: (NSString*)friendId;
+ (NSString*) urlServiceForPhotoOn;
+ (NSString*) savePhoto: (NSString*)photo InServiceWithUserId: (NSString*)userId AndHash: (NSString*)hash AndServer: (NSString*)server;
+(NSString*) postPhoto: (NSString*)photoId OnWall: (NSString*)idOfUser;
@end
