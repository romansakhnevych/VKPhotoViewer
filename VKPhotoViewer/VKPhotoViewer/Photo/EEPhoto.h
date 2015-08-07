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
@property (nonatomic,retain)NSString *smallPhotoLink;
@property (nonatomic,retain)NSString *origPhotoLing;
@property (nonatomic,retain)NSNumber *likesCount;
@property (nonatomic,retain)NSNumber *commentsCount;



@end
