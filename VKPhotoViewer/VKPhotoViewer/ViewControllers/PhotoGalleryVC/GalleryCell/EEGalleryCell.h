//
//  EEGalleryCell.h
//  VKPhotoViewer
//
//  Created by admin on 8/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEPhoto.h"

@interface EEGalleryCell : UICollectionViewCell <UIScrollViewDelegate>{
    BOOL isZooming;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *zoomScrollView;
@property (nonatomic, retain) EEPhoto *photo;

- (IBAction)doubleTapHandle:(UITapGestureRecognizer *)sender;

@end
