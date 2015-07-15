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

+ (NSMutableURLRequest *)friendsGetRequestWithOffset:(int)offset{
    
    _request = [[NSMutableURLRequest alloc] init];
    
    NSString *lFriendsGetString = [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?user_id=%@&order=%@&count=30&offset=%d&fields=%@&name_case=%@&lang=ua",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY],ORDER,offset,FIELDS,NAME_CASE];
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lFriendsGetString]cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    return _request;
}

+ (NSMutableURLRequest *)loginRequest{
    _request = [[NSMutableURLRequest alloc] init];
    
    NSString *lauthString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=%@&redirect_uri=%@&display=%@&v=%@&response_type=token", APP_ID,SCOPE,REDIRECT_URI,DISPLAY,API_VERSION];
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:lauthString]];
    
    return _request;
}

@end
