//
//  EEVkLoginVC.m
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEVkLoginVC.h"
#import "Constants.h"
#import "EERequests.h"



@interface EEVkLoginVC ()
- (BOOL)getUserAthorizationData:(NSURL *)requestUrlString;
- (void)vkLoginCancel;
- (BOOL)connectedToInternet;
@end

@implementation EEVkLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_indicator startAnimating];
    [[self navigationController]setNavigationBarHidden:YES];
    
    if(!_vkLoginWebView){
        self.vkLoginWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _vkLoginWebView.delegate = self;
        _vkLoginWebView.scalesPageToFit = YES;
        [self.view addSubview:_vkLoginWebView];
    }
    

    NSURLRequest *lRequest = (NSURLRequest *)[EERequests loginRequest];
    [_vkLoginWebView loadRequest:lRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (BOOL)getUserAthorizationData:(NSURL *)requestUrlString {
    BOOL lResult = NO;
    
    NSURLComponents *lUrlCmponets = [NSURLComponents componentsWithURL:requestUrlString resolvingAgainstBaseURL:NO];
    if ([lUrlCmponets.path isEqualToString:@"/blank.html"]) {
        lResult = YES;
        lUrlCmponets.query = lUrlCmponets.fragment;
        NSArray *lQueryItems = lUrlCmponets.queryItems;
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulLogin" object:nil];
        }];
        
        for (NSURLQueryItem *item in lQueryItems) {
            if ([item.name isEqualToString:ACCESS_TOKEN_KEY]) {
                
                [self saveLoginObject:item.value forKey:ACCESS_TOKEN_KEY];
                
            } else if ([item.name isEqualToString:USER_ID_KEY]) {
                
                [self saveLoginObject:item.value forKey:USER_ID_KEY];
                
            } else if ([item.name isEqualToString:TOKEN_LIFE_TIME_KEY]) {
                
                [self saveLoginObject:item.value forKey:TOKEN_LIFE_TIME_KEY];
            } else if ([item.name isEqualToString:@"error_description"]){
                
                [self showAlertWithMessage:item.value];
            }
      
        }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTH_COMPLITED_KEY];
    }
    return lResult;
}

- (void)vkLoginCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)connectedToInternet {
    NSString *lUrlString = @"http://www.google.com/";
    NSURL *lUrl = [NSURL URLWithString:lUrlString];
    NSMutableURLRequest *lRequest = [NSMutableURLRequest requestWithURL:lUrl];
    [lRequest setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *lResponse;
    
    [NSURLConnection sendSynchronousRequest:lRequest returningResponse:&lResponse error: NULL];
    
    return ([lResponse statusCode] == 200) ? YES : NO;
}

- (void)saveLoginObject:(id)value forKey:(id)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showAlertWithMessage:(NSString *)message{
    UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [lAlert show];
}

#pragma mark - UIWebView delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL lResult = YES;

    
    if([self connectedToInternet]){
    
        lResult = ![self getUserAthorizationData:request.URL];
       
    } else {
        [self showAlertWithMessage:@"Check internet connection!"];
        [self dismissViewControllerAnimated:YES completion:nil];
        lResult =  NO;
    }
    
    return lResult;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
}

- (IBAction)cancelBtnTap:(id)sender {
    [self vkLoginCancel];
    
}


@end
