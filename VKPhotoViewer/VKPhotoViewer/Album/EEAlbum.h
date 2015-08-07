//
//  EEAlbum.h
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEAlbum : NSObject

@property (nonatomic,retain)NSString *albumID;
@property (nonatomic,retain)NSString *albumTitle;
@property (nonatomic,retain)NSString *albumDescription;
@property (nonatomic,retain)NSNumber *size;
@property (nonatomic,retain)NSString *albumThumbLink;

-(NSString *)getAlbumSize;
@end
