//
//  EEFriendsListCell.m
//  VKPhotoViewer
//
//  Created by admin on 7/16/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriendsListTVCell.h"

@implementation EEFriendsListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_photo.layer setCornerRadius:_photo.frame.size.width / 2];
    _photo.layer.masksToBounds = YES;
}


@end
