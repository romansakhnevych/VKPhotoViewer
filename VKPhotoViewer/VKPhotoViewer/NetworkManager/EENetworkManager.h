//
//  EENetworkManager.h
//  VKPhotoViewer
//
//  Created by admin on 9/8/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface EENetworkManager : AFHTTPSessionManager

+ (EENetworkManager *)sharedManager;
- (instancetype)init;

@end
