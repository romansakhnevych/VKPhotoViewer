//
//  EEResponseBilder.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEResponseBilder.h"
#import "EEAlbum.h"
#import "EEPhoto.h"
#import "EENews.h"
#import <UIKit/UIKit.h>
#import "UIImageView+Haneke.h"


@implementation EEResponseBilder


+ (NSMutableArray *)getFriendsFromArray:(NSArray *)array{
    
    NSMutableArray *lArrayFriends = [NSMutableArray new];
      
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
        EEFriends *lUser = [[EEFriends alloc] init];
        lUser.firstName = [NSString stringWithFormat:@"%@",[obj objectForKey:@"first_name"]];
        lUser.lastName = [NSString stringWithFormat:@"%@",[obj objectForKey:@"last_name"]];
        lUser.userId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"user_id"]];
        lUser.smallPhotoLink = [NSString stringWithFormat:@"%@",[obj objectForKey:@"photo_100"]];
        lUser.bigPhotoLink = [NSString stringWithFormat:@"%@",[obj objectForKey:@"photo_200_orig"]];
        
        [lArrayFriends addObject:lUser];
            
        }];
    
    return lArrayFriends;
}

+ (EEFriends *)getDetailFromArray:(NSArray *)array forUser:(EEFriends *)user{
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        user.firstName = [obj objectForKey:@"first_name"];
        user.lastName = [obj objectForKey:@"last_name"];
        user.photosCount = [[obj objectForKey:@"counters"] objectForKey:@"photos"];
        user.albumsCount = [[obj objectForKey:@"counters"] objectForKey:@"albums"];
        user.city = [[obj objectForKey:@"city"] objectForKey:@"title"];
        user.country = [[obj objectForKey:@"country"] objectForKey:@"title"];
        user.sex = [obj objectForKey:@"sex"];
        user.domain = [obj objectForKey:@"domain"];
        user.site = [obj objectForKey:@"site"];
        user.birthdayDate = [obj objectForKey:@"bdate"];
        user.status = [obj objectForKey:@"status"];
        user.occupation = [[obj objectForKey:@"occupation"] objectForKey:@"name"];
        user.userId = [obj objectForKey:@"id"];
        user.smallPhotoLink = [obj objectForKey:@"photo_100"];
        user.bigPhotoLink = [obj objectForKey:@"photo_200_orig"];
    }];
    
    return user;
}

+ (NSMutableArray *)getAlbumsFromArray:(NSArray *)array{
    
    NSMutableArray *lAlbumsList = [NSMutableArray new];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EEAlbum *lAlbum = [[EEAlbum alloc] init];
        
        NSArray *lSizeArray = [obj objectForKey:@"sizes"];
        
        lAlbum.albumID = [obj objectForKey:@"id"];
        lAlbum.albumTitle = [obj objectForKey:@"title"];
        lAlbum.albumDescription = [obj objectForKey:@"description"];
        lAlbum.albumThumbLink = [[lSizeArray objectAtIndex:2] objectForKey:@"src"];
        lAlbum.size = [obj objectForKey:@"size"];
        
        [lAlbumsList addObject:lAlbum];
    }];
    return lAlbumsList;
}

+ (NSMutableArray *)getPhotosFromArray:(NSArray *)array{
    
    NSMutableArray *lPhotosList = [NSMutableArray new];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EEPhoto *lPhoto = [[EEPhoto alloc] init];
        NSNumber *lPhotoId = [obj objectForKey:@"id"];
        lPhoto.photoId = [NSString stringWithFormat:@"%u",lPhotoId.intValue];
        lPhoto.xsPhotoLink = [obj objectForKey:@"photo_75"];
        lPhoto.sPhotoLink = [obj objectForKey:@"photo_130"];
        lPhoto.mPhotoLink = [obj objectForKey:@"photo_604"];
        lPhoto.lPhotoLink = [obj objectForKey:@"photo_807"];
        lPhoto.xlPhotoLink = [obj objectForKey:@"photo_1280"];
        lPhoto.xxlPhotoLink = [obj objectForKey:@"photo_2560"];
        lPhoto.likesCount = [[obj objectForKey:@"likes"] objectForKey:@"count"];
        lPhoto.Liked = [[obj objectForKey:@"likes"] objectForKey:@"user_likes"];
        lPhoto.commentsCount = [[obj objectForKey:@"comments"] objectForKey:@"count"];
        lPhoto.photoHeight = [obj objectForKey:@"height"];
        lPhoto.photoWidth = [obj objectForKey:@"width"];
        if ([obj objectForKey:@"height"] && ![[obj objectForKey:@"height"]  isEqual: @""]) {
            lPhoto.photoHeight = [obj objectForKey:@"height"];
            lPhoto.photoWidth = [obj objectForKey:@"width"];
        } else {
            NSString* photoURL;
            if (lPhoto.xxlPhotoLink){
                photoURL = lPhoto.xxlPhotoLink;
            }else if (lPhoto.xlPhotoLink){
                photoURL = lPhoto.xlPhotoLink;
                
            }else if (lPhoto.lPhotoLink){
                photoURL = lPhoto.lPhotoLink;
                
            }else if (lPhoto.mPhotoLink){
                photoURL = lPhoto.mPhotoLink;
                
            }else if (lPhoto.sPhotoLink){
                photoURL = lPhoto.sPhotoLink;
                
            }else if (lPhoto.xsPhotoLink){
                photoURL = lPhoto.xsPhotoLink;
            }
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleToFill;
            
            CGRect frame = CGRectMake(15, 14, 14, 13);
            imgView.frame = frame;
            [imgView hnk_setImageFromURL:[NSURL URLWithString:photoURL]  placeholder:nil success:^(UIImage *image) {
                lPhoto.photoHeight = [NSString stringWithFormat:@"%f",image.size.height];
                lPhoto.photoWidth = [NSString stringWithFormat:@"%f",image.size.width];
            } failure:^(NSError *error) {
                
            }];
        }
        
        
        [lPhotosList addObject:lPhoto];
    }];
    
    return lPhotosList;
}

+ (NSMutableArray *)getNewsfeedWithItems:(NSArray *)items profiles:(NSArray *)profiles{
    NSMutableArray *lNewsList = [NSMutableArray new];
    
    EENews *lNew;
    
    for (int i = 0; i < profiles.count; i++) {
        for (int j = 0; j < items.count; j++) {
            if ([[profiles objectAtIndex:i] objectForKey:@"id"] == [[items objectAtIndex:j] objectForKey:@"source_id"]) {
                
                NSDictionary *lProfile = [profiles objectAtIndex:i];
                NSDictionary *lItem = [items objectAtIndex:j];
                NSArray *lPhotosResponse = [[lItem objectForKey:@"photos"] objectForKey:@"items"];
                NSMutableArray *lPhotos = [NSMutableArray new];
    
                [lPhotosResponse enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    EEPhoto *lNewPhoto = [EEPhoto new];
                    
                    lNewPhoto.albumId = [obj objectForKey:@"album_id"];
                    lNewPhoto.photoWidth = [obj objectForKey:@"width"];
                    lNewPhoto.photoHeight = [obj objectForKey:@"height"];
                    lNewPhoto.photoId = [obj objectForKey:@"id"];
                    lNewPhoto.xsPhotoLink = [obj objectForKey:@"photo_75"];
                    lNewPhoto.sPhotoLink = [obj objectForKey:@"photo_130"];
                    lNewPhoto.mPhotoLink = [obj objectForKey:@"photo_604"];
                    lNewPhoto.lPhotoLink = [obj objectForKey:@"photo_807"];
                    lNewPhoto.xlPhotoLink = [obj objectForKey:@"photo_1280"];
                    lNewPhoto.xxlPhotoLink = [obj objectForKey:@"photo_2560"];
                    
                    [lPhotos addObject:lNewPhoto];
                }];

                lNew = [EENews new];
                lNew.photos = [[NSMutableArray alloc] initWithArray:lPhotos];
                lNew.firstName = [lProfile objectForKey:@"first_name"];
                lNew.lastName = [lProfile objectForKey:@"last_name"];
                lNew.userId = [lProfile objectForKey:@"id"];
                lNew.date = [lItem objectForKey:@"date"];
                lNew.userPhotoLink = [lProfile objectForKey:@"photo_100"];
                
                
            }
            
        }
        if (![lNewsList containsObject:lNew]) {
            [lNewsList addObject:lNew];

        }
            }
    
    return lNewsList;
}
     
@end


