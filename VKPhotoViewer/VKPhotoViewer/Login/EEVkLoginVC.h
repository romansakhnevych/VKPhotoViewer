//
//  EEVkLoginVC.h
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EEVkLoginVC : UIViewController <UIWebViewDelegate>
{
    UIWebView *_vkLoginWebView;
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic,retain) IBOutlet UIWebView *vkLoginWebView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;



@end
