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

+ (NSString *)friendsGetRequestWithOffset:(NSInteger)offset count:(NSInteger)count {
    return [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?user_id=%@&order=%@&count=%li&offset=%li&fields=%@&name_case=%@&lang=ua&version=5.8",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY], ORDER, (long)count, (long)offset, FIELDS, NAME_CASE];
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
    
    return [NSString stringWithFormat:@"https://api.vk.com/method/users.get?user_id=%@&fields=%@&name_case=%@&version=5.8",ID,FIELDS_FOR_USER,NAME_CASE];
}

@end
