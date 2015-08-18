//
//  EEGalleryCell.m
//  VKPhotoViewer
//
//  Created by admin on 8/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEGalleryCell.h"
#import "EEAppManager.h"

@implementation EEGalleryCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        NSArray *lArrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GalleryCell" owner:self options:nil];
        
        if ([lArrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[lArrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [lArrayOfViews objectAtIndex:0];
        
    }
    _zoomScrollView.delegate = self;
    _zoomScrollView.minimumZoomScale = 1.0f;
    _zoomScrollView.maximumZoomScale = 10.0f;
    [_zoomScrollView setClipsToBounds:YES];
    _photo = [EEAppManager sharedAppManager].currentPhoto;
    
   
    
    return  self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if (self.imageView.superview == scrollView) {
        return self.imageView;
    }
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX;
    CGFloat offsetY;
    
    
    
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    else{
        offsetX = 0.0f;
    }
    
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    else{
        offsetY = 0.0f;
    }
    
    
    
        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
}




- (IBAction)doubleTapHandle:(UITapGestureRecognizer *)sender {
    
    UIScrollView *scrollView = (UIScrollView*)self.imageView.superview;
    float scale = scrollView.zoomScale;
    scale += 2.0;
    if(scale > 3.0) scale = 1.0;
    [scrollView setZoomScale:scale animated:YES];
}
@end
