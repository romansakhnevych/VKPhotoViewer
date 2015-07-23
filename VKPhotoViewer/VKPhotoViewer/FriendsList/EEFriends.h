//
//  EEFriends.h
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EEFriends : NSObject

@property (nonatomic, retain)NSString *firstName;
@property (nonatomic, retain)NSString *lastName;
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, retain)NSString *smallPhotoLink;
@property (nonatomic, retain)NSString *bigPhotoLink;
@property (nonatomic, retain)NSNumber *photosCount;
@property (nonatomic, retain)NSNumber *albumsCount;
@property (nonatomic, retain)NSString *city;
@property (nonatomic, retain)NSString *country;


- (NSString *)getFullName;
- (NSString *)getPhotosCount;
- (NSString *)getAlbumsCount;


@end
