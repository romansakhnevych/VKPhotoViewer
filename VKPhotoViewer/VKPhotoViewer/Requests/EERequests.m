//
//  EERequests.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EERequests.h"
#import "Constants.h"

@implementation EERequests

+ (NSString *)friendsGetRequestWithOffset:(NSInteger)offset
                                    count:(NSInteger)count {
    return [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?user_id=%@&order=%@&count=%li&offset=%li&fields=%@&name_case=%@&lang=ua&access_token=%@&version=5.8",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY], ORDER, (long)count, (long)offset, FIELDS, NAME_CASE,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY]];
}

+ (NSMutableURLRequest *)loginRequest{
    _request = [[NSMutableURLRequest alloc] init];
    
    NSString *lauthString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=%@&redirect_uri=%@&display=%@&v=%@&response_type=token", APP_ID,SCOPE,REDIRECT_URI,DISPLAY,API_VERSION];
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lauthString]];
    
    return _request;
}

+ (NSMutableURLRequest *)getPhotoRequestByLink:(NSString *)link{
    
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:link]];
    
}

+ (NSString *)getUserInfoRequestWithId:(NSString *)ID{
    
    return [NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_id=%@&fields=%@&name_case=%@&access_token=%@&v=5.8",ID,FIELDS_FOR_USER,NAME_CASE,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY]];
}

+ (NSString *)getAlbumWithId:(NSString* )albumId
                     forUser:(NSString *)userId{
    return [NSString stringWithFormat:@"https://api.vk.com/method/photos.getAlbums?owner_id=%@&album_ids=%@&access_token=%@&v=%@",userId, albumId,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString *)getAlbumsRequestWithOffset:(NSInteger)offset
                                   count:(NSInteger)count
                                    byId:(NSString *)userId{
    return [NSString stringWithFormat:@"https://api.vk.com/method/photos.getAlbums?owner_id=%@&offset=%lu&count=%lu&need_system=1&need_covers=1&photo_sizes=1&access_token=%@&v=%@",userId,(long)offset,(long)count,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString *)getPhotosRequestWithOffset:(NSInteger)offset
                            count:(NSInteger)count
                        fromAlbum:(NSString *)albumId
                          forUser:(NSString *)userId{
    
    return [NSString stringWithFormat:@"https://api.vk.com/method/photos.get?owner_id=%@&album_id=%@&rev=1&extended=1&offset=%lu&count=%lu&access_token=%@&v=%@",userId,albumId,(long)offset,count,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString *)addLikeWithOwnerId:(NSString *)ownerId itemId:(NSString *)itemId{
    
    return [NSString stringWithFormat:@"https://api.vk.com/method/likes.add?type=photo&owner_id=%@&item_id=%@&access_token=%@&v=%@",ownerId,itemId,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString *)deleteLikeWithOwnerId:(NSString *)ownerId itemId:(NSString *)itemId{
    
    return [NSString stringWithFormat:@"https://api.vk.com/method/likes.delete?type=photo&owner_id=%@&item_id=%@&access_token=%@&v=%@",ownerId,itemId,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString*) urlServiceForPhotoOn {
    return [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?access_token=%@&v=%@", [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString*) savePhoto: (NSString*)photo InServiceWithUserId: (NSString*)userId AndHash: (NSString*)hash AndServer: (NSString*)server {
    return [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&server=%@&photo=%@&hash=%@&access_token=%@&v=%@", userId, server, photo, hash, [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+(NSString*) postPhoto: (NSString*)photoId OnWall: (NSString*)idOfUser {
    return [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&attachment=%@access_token=%@&v=%@", idOfUser, photoId, [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY],API_VERSION];
}

+ (NSString *)newsfeedWithStartFrom:(NSString *)startsFrom{
    return [NSString stringWithFormat:@"https://api.vk.com/method/newsfeed.get?filters=photo&start_from=%@&v=%@&access_token=%@",startsFrom,API_VERSION,[[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY]];
}
@end
