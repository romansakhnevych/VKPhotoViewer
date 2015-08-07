//
//  EEResponseBilder.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEResponseBilder.h"
#import "EEAlbum.h"


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
     
@end


