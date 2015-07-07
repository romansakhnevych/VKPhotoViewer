//
//  EEUserAuthorization.h
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEUserAuthorization : NSObject{
    NSString *_accessToken;
    NSString *_userID;
    NSString *_tokenLifeTime;
}

@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) NSString *userID;
@property (nonatomic,retain) NSString *tokenLifeTime;



@end
