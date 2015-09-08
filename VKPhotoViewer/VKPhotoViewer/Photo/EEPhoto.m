//
//  EEPhoto.m
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhoto.h"

@implementation EEPhoto

- (NSString *)getLikesCount{
    
    NSInteger lLikes = _likesCount.integerValue;
    NSString *lLikesString = [NSString stringWithFormat:@"%li",lLikes];
    
    return lLikesString;
}

- (NSString *)getCommentsCount{
    
    NSInteger lComments = _commentsCount.integerValue;
    NSString *lCommentsString = [NSString stringWithFormat:@"%li",lComments];
    
    return lCommentsString;
}

- (BOOL)isLiked{
    BOOL lIsLiked = NO;
    if (_Liked.integerValue == 1) {
        lIsLiked = YES;
    }
    return lIsLiked;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Object %@", @{
                              @"photoId" : _photoId,
                              @"xsPhotoLink" : _xsPhotoLink,
                              @"sPhotoLink" : _sPhotoLink
                              }];
}

@end
