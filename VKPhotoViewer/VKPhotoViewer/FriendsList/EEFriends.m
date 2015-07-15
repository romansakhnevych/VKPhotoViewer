//
//  EEFriends.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriends.h"

@implementation EEFriends

- (NSString *)getFullName{
    return [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
}

@end
