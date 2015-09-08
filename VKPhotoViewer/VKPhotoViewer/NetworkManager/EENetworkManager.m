//
//  EENetworkManager.m
//  VKPhotoViewer
//
//  Created by admin on 9/8/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EENetworkManager.h"
#import "Constants.h"

@implementation EENetworkManager

+ (EENetworkManager *)sharedManager {
    static EENetworkManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}


@end
