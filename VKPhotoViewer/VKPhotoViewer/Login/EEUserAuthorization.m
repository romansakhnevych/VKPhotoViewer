//
//  EEUserAuthorization.m
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEUserAuthorization.h"
#import "Constants.h"

@implementation EEUserAuthorization

@synthesize accessToken;
@synthesize tokenLifeTime;
@synthesize userId;

static EEUserAuthorization *sharedUserAuthorizationData = NULL;

+ (EEUserAuthorization *)sharedUserAuthorizationData{
    if(!sharedUserAuthorizationData||sharedUserAuthorizationData == NULL){
        
        sharedUserAuthorizationData = [EEUserAuthorization new];
    }
    
    return sharedUserAuthorizationData;
}

- (void) setUserAuthorizationData{
    
    if (!accessToken||accessToken == nil){
        
        accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN_KEY];
    }
    if (!userId||userId == nil){
        
        userId = [[NSUserDefaults standardUserDefaults]objectForKey:USER_ID_KEY];
    }
    if (!tokenLifeTime||tokenLifeTime == nil){
        
        tokenLifeTime = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN_LIFE_TIME_KEY];
    }
}



@end
