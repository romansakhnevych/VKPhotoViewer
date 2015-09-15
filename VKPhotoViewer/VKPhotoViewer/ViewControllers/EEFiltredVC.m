//
//  EEFiltredVC.m
//  VKPhotoViewer
//
//  Created by админ on 9/15/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFiltredVC.h"
#import "Haneke.h"

@implementation EEFiltredVC

-(void)viewDidLoad {
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForPhoto]];
}
@end
