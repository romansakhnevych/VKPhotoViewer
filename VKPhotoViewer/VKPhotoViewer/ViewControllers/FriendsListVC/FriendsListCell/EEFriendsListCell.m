//
//  EEFriendsListCell.m
//  VKPhotoViewer
//
//  Created by admin on 7/16/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriendsListCell.h"

@implementation EEFriendsListCell

- (void)awakeFromNib {
    
    [_photo.layer setCornerRadius:_photo.frame.size.width/2];
    _photo.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
