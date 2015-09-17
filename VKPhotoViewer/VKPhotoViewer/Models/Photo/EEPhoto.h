//
//  EEPhoto.h
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEPhoto : NSObject

@property (nonatomic,copy)NSString *photoId;
@property (nonatomic,copy)NSString *xsPhotoLink;
@property (nonatomic,copy)NSString *sPhotoLink;
@property (nonatomic,copy)NSString *mPhotoLink;
@property (nonatomic,copy)NSString *lPhotoLink;
@property (nonatomic,copy)NSString *xlPhotoLink;
@property (nonatomic,copy)NSString *xxlPhotoLink;
@property (nonatomic,retain)NSNumber *likesCount;
@property (nonatomic,retain)NSNumber *commentsCount;
@property (nonatomic,copy)NSString *photoWidth;
@property (nonatomic,copy)NSString *photoHeight;
@property (nonatomic,copy)NSString *albumId;
@property (nonatomic,retain)NSNumber *Liked;


- (NSString *)getLikesCount;
- (NSString *)getCommentsCount;
- (BOOL)isLiked;

@end
