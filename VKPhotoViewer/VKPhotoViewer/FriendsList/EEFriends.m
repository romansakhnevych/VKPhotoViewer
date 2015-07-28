//
//  EEFriends.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriends.h"
#import "EERequests.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"

@implementation EEFriends

- (NSString *)getFullName{
    return [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
}

- (NSString *)getPhotosCount{
    NSInteger lPhotosCount = _photosCount.intValue;
    NSString *lPhotosCountString = [NSString stringWithFormat:@"%lu",(long)lPhotosCount];
    return lPhotosCountString;
}

- (NSString *)getAlbumsCount{
    NSInteger lAlbumsCount = _albumsCount.intValue;
    NSString *lAlbumCountString = [NSString stringWithFormat:@"%lu",(long)lAlbumsCount];
    return lAlbumCountString;
}

- (NSString *)getSex{
    NSString *lSex;
    NSInteger lSexId = _sex.intValue;
    switch (lSexId) {
        case 1:
            lSex = @"femail";
            break;
        case 2:
            lSex = @"mail";
            
        default:
            break;
    }
    
    return lSex;
}




@end
