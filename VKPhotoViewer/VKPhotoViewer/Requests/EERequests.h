//
//  EERequests.h
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSMutableURLRequest* _request;
@interface EERequests : NSObject

+ (NSString *)friendsGetRequestWithOffset:(NSInteger)offset count:(NSInteger)count;
+ (NSMutableURLRequest *)loginRequest;
+ (NSMutableURLRequest *)getPhotoRequestByLink:(NSString *)link;
+ (NSString *)getUserInfoRequestWithId:(NSString *)ID;
+ (NSString *)getCityRequestById:(NSString *)Id;

@end
