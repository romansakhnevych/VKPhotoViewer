//
//  EEUserAuthorization.m
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEUserAuthorization.h"

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


@end
