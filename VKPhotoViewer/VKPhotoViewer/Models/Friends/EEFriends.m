//
//  EEFriends.m
//  VKPhotoViewer
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriends.h"
#import "EERequests.h"
#import "AFHTTPSessionManager.h"


@implementation EEFriends

- (NSString *)getFullName{
    return [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
}

- (NSString *)getPhotosCount{
    NSInteger lPhotosCount = _photosCount.intValue;
    NSString *lPhotosCountString = [NSString stringWithFormat:@"%lu",(long)lPhotosCount];
    return lPhotosCountString;
}

- (NSString *)getAlbumsCount{
    NSInteger lAlbumsCount = _albumsCount.intValue;
    NSString *lAlbumCountString = [NSString stringWithFormat:@"%lu",(long)lAlbumsCount];
    return lAlbumCountString;
}

- (NSString *)getSex{
    NSString *lSex;
    NSInteger lSexId = _sex.intValue;
    NSString *localizedMaleString = NSLocalizedString(@"MaleKey", @"");
     NSString *localizedFemaleString = NSLocalizedString(@"FemaleKey", @"");
    switch (lSexId) {
        case 1:
            lSex = localizedFemaleString;
            break;
        case 2:
            lSex = localizedMaleString;
            
        default:
            break;
    }
    return lSex;
}

- (NSString *)getLocation{
    
    NSString *lLocation;
    
    if (_city&&_country){
        lLocation = [NSString stringWithFormat:@"%@, %@",_city,_country];
    }
    else if (_city){
        lLocation = [NSString stringWithFormat:@"%@",_city];
    }
    else if (_country){
        lLocation = [NSString stringWithFormat:@"%@",_country];
    }
    else{
        lLocation = @"";
    }

    return lLocation;
}

- (NSDictionary *)getDetails {
    
    NSString *localizedSexString = NSLocalizedString(@"SexKey", @"");
    NSString *localizedBirthDayString = NSLocalizedString(@"BirthDayKey", @"");
    NSString *localizedLocationString = NSLocalizedString(@"LocationKey", @"");
    NSString *localizedDomainString = NSLocalizedString(@"DomainKey", @"");
    NSString *localizedStatusString = NSLocalizedString(@"StatusKey", @"");
    NSString *localizedOccupationString = NSLocalizedString(@"OccupationKey", @"");
    NSString *localizedSiteString = NSLocalizedString(@"SiteKey", @"");
    
    NSMutableDictionary *lDictionary = [[NSMutableDictionary alloc] init];
    if (_sex != nil){
        [lDictionary setObject:[self getSex] forKey:localizedSexString];
    }
    if (_birthdayDate){
        [lDictionary setObject:[self getBirthDay] forKey:localizedBirthDayString];
    }
    if ([self getLocation] && ![[self getLocation]  isEqual: @""]){
        [lDictionary setObject:[self getLocation] forKey:localizedLocationString];
    }
    if (_domain){
        [lDictionary setObject:_domain forKey:localizedDomainString];
    }
    if (_status && ![_status isEqual:@""]){
        [lDictionary setObject:_status forKey:localizedStatusString];
    }
    if (_occupation){
        [lDictionary setObject:_occupation forKey:localizedOccupationString];
    }
    if (_site && ![_site isEqual:@""]){
        [lDictionary setObject:_site forKey:localizedSiteString];
    }
    return lDictionary;
}

- (NSString *)getBirthDay{
    
    NSArray *lSeparatedDate = [_birthdayDate componentsSeparatedByString:@"."];
    NSString *day, *mounth, *year;
    NSString *lDate = _birthdayDate;
    
    if ([[lSeparatedDate objectAtIndex:0] length] == 1){
       day = [NSString stringWithFormat:@"0%@",[lSeparatedDate objectAtIndex:0]];
    }
    else{
        day = [lSeparatedDate objectAtIndex:0];
    }
    if ([[lSeparatedDate objectAtIndex:1] length] == 1){
        mounth = [NSString stringWithFormat:@"0%@",[lSeparatedDate objectAtIndex:1]];
    }
    else{
        mounth = [lSeparatedDate objectAtIndex:1];
    }
    if ([lSeparatedDate count] == 3){
    year = [NSString stringWithFormat:@".%@",[lSeparatedDate objectAtIndex:2]];
    }
    else{
        year = @"";
    }
    lDate = [NSString stringWithFormat:@"%@.%@%@",day,mounth,year];
    
    return lDate;
}

- (BOOL)isDeactivated{
    BOOL deactive = NO;
    if ([_deactivated isEqualToString:@"deleted"] || [_deactivated isEqualToString:@"banned"]) {
        deactive = YES;
    }
    
    return deactive;
}

@end
