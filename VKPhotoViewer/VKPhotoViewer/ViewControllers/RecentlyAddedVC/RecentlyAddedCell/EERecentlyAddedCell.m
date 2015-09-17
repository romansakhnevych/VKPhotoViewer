//
//  EERecentlyAddedCell.m
//  VKPhotoViewer
//
//  Created by admin on 9/17/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EERecentlyAddedCell.h"

@implementation EERecentlyAddedCell

- (void)awakeFromNib {
    [_userPhotoImgView.layer setCornerRadius:_userPhotoImgView.frame.size.width / 2];
    _userPhotoImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
