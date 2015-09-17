//
//  EENews.m
//  VKPhotoViewer
//
//  Created by admin on 9/17/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EENews.h"

@implementation EENews

- (NSString *)getDate{
    
    double interval = [_date doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *lFormater = [NSDateFormatter new];
    [lFormater setDateFormat:@"dd.MM.yyyy"];
    
    
    
    return [lFormater stringFromDate:date];
}

- (NSString *)getUserId{
    NSInteger userId = _userId.integerValue;
    return [NSString stringWithFormat:@"%ld",(long)userId];
}

@end
