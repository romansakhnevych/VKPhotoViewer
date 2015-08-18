//
//  EEPhoto.h
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEPhoto : NSObject

@property (nonatomic,retain)NSString *photoId;
@property (nonatomic,retain)NSString *xsPhotoLink;
@property (nonatomic,retain)NSString *sPhotoLink;
@property (nonatomic,retain)NSString *mPhotoLink;
@property (nonatomic,retain)NSString *lPhotoLink;
@property (nonatomic,retain)NSString *xlPhotoLink;
@property (nonatomic,retain)NSString *xxlPhotoLink;
@property (nonatomic,retain)NSNumber *likesCount;
@property (nonatomic,retain)NSNumber *commentsCount;
@property (nonatomic,retain)NSString *photoWidth;
@property (nonatomic,retain)NSString *photoHeight;




@end
