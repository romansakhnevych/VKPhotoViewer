//
//  EECustomTableHeaderView.m
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EECustomTableHeaderView.h"

@implementation EECustomTableHeaderView
- (IBAction)logOutButtonTapped:(id)sender {
    [self.delegate logOut];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_imageView.layer setCornerRadius:_imageView.frame.size.width/2];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageView.layer.borderWidth = 2;
}

@end
