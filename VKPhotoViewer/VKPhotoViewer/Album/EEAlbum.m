//
//  EEAlbum.m
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEAlbum.h"

@implementation EEAlbum

- (NSString *)getAlbumSize{
    NSInteger size = _size.intValue;
    NSString *sizeStr = [NSString stringWithFormat:@"%lu",(long)size];
    return sizeStr;
}

@end
