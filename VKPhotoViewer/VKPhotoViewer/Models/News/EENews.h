//
//  EENews.h
//  VKPhotoViewer
//
//  Created by admin on 9/17/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EEPhoto.h"

@interface EENews : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) NSNumber *date;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, copy) NSString *userPhotoLink;

- (NSString *)getDate;
- (NSString *)getUserId;
@end
