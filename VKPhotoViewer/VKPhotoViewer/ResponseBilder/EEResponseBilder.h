//
//  EEResponseBilder.h
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEFriends.h"

@interface EEResponseBilder : NSObject



+ (NSMutableArray *)getFriendsFromArray:(NSArray *)array;
+ (EEFriends *)getDetailFromArray:(NSArray *)array forUser:(EEFriends *)user;

@end