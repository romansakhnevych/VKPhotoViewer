//
//  EEPhotoBrowserVC.h
//  VKPhotoViewer
//
//  Created by admin on 8/11/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEPhoto.h"

@interface EEPhotoBrowserVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain)NSMutableArray *allPhotos;
@property (nonatomic)NSInteger index;

- (IBAction)tapHandle:(UITapGestureRecognizer *)sender;
- (IBAction)leftSwipeHandle:(UISwipeGestureRecognizer *)sender;
- (IBAction)rightSwipeHandle:(UISwipeGestureRecognizer *)sender;




@end
