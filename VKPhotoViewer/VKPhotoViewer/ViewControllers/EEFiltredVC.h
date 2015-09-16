//
//  EEFiltredVC.h
//  VKPhotoViewer
//
//  Created by админ on 9/15/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEFriends.h"
#import "EEPhoto.h"

@interface EEFiltredVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString* linkForPhoto;
@property (strong, nonatomic) NSString* linkInService;
@property (strong, nonatomic) NSString* photoUrlId;
@property (strong, nonatomic) NSString* hashServ;
@property (strong, nonatomic) NSString* server;
@property (strong, nonatomic) EEPhoto* filtredPhoto;


@end
