//
//  EEVkLoginVC.m
//  VKPhotoViewer
//
//  Created by Admin on 07.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEVkLoginVC.h"
#import "Constants.h"


@interface EEVkLoginVC ()
- (NSString *) stringBetween :(NSString*) start andString:(NSString*) end innerString:(NSString*)str;
- (void) getUserAthorizationData :(NSURL*) requestUrlString;
- (void) vkLoginCancel;
- (BOOL) connectedToInternet;
@end

@implementation EEVkLoginVC

@synthesize vkLoginWebView;
@synthesize indicator;

- (void)viewDidLoad
{
    
    //---------------
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@",AUTH_COMPLITED_KEY]];
    //---------------
    [super viewDidLoad];
    [indicator startAnimating];
    [[self navigationController]setNavigationBarHidden:YES];
    
    
    if(!vkLoginWebView){
        self.vkLoginWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        vkLoginWebView.delegate = self;
        vkLoginWebView.scalesPageToFit = YES;
        [self.view addSubview:vkLoginWebView];
    }
    
    NSString *lauthString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=%@&redirect_uri=%@&display=%@&v=%@&response_type=token", APP_ID,SCOPE,REDIRECT_URI,DISPLAY,API_VERSION];
    NSURL *lauthUrl = [NSURL URLWithString:lauthString];
    [vkLoginWebView loadRequest:[NSURLRequest requestWithURL:lauthUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (NSString*)stringBetween:(NSString *)start andString:(NSString *)end innerString:(NSString *)str {
    NSScanner *lscanner = [NSScanner scannerWithString:str];
    [lscanner setCharactersToBeSkipped:nil];
    [lscanner scanUpToString:start intoString:NULL];
    
    NSString *lresult = nil;
    
    if([lscanner scanString:start intoString:NULL]){
        [lscanner scanUpToString:end intoString:&lresult];
    }
    
    return lresult;
}

- (void)getUserAthorizationData:(NSURL *)requestUrlString {
    NSLog(@"URL - %@", requestUrlString.absoluteString);
    
    if([requestUrlString.absoluteString rangeOfString:@"access_token"].location != NSNotFound){
        
        NSString *laccessToken = [self stringBetween:@"access_token=" andString:@"&" innerString:[requestUrlString absoluteString]];
        NSString *ltokenLifeTime = [self stringBetween:@"expires_in=" andString:@"&" innerString:[requestUrlString absoluteString]];
        NSArray *luserArray = [[requestUrlString absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *luserID = [luserArray lastObject];
        
        NSLog(@"token:%@",laccessToken);
        NSLog(@"expires_in:%@",ltokenLifeTime);
        NSLog(@"user_id:%@",luserID);
        
        		
        if (luserID) {
            [[NSUserDefaults standardUserDefaults] setObject:luserID forKey:[NSString stringWithFormat:@"%@",USER_ID_KEY]];
        }
        if (ltokenLifeTime) {
            [[NSUserDefaults standardUserDefaults] setObject:ltokenLifeTime forKey:[NSString stringWithFormat:@"%@",TOKEN_LIFE_TIME_KEY]];
        }
        if (laccessToken) {
            [[NSUserDefaults standardUserDefaults] setObject:laccessToken forKey:[NSString stringWithFormat:@"%@",ACCESS_TOKEN_KEY]];
        }
        //------
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@",AUTH_COMPLITED_KEY]];
        //------
        [[NSUserDefaults standardUserDefaults] synchronize];

     
       //-------
        
        
        /*if([wView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound){
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }*/
        //------
        
        NSLog(@"vkLoginWebView response: %@",[[[vkLoginWebView request]URL]absoluteString]);
        
    } else if([vkLoginWebView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"error: %@", vkLoginWebView.request.URL.absoluteString);
    }

}

- (void) vkLoginCancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL) connectedToInternet{
    
    NSString *lUrlString = @"http://www.google.com/";
    NSURL *lUrl = [NSURL URLWithString:lUrlString];
    NSMutableURLRequest *lRequest = [NSMutableURLRequest requestWithURL:lUrl];
    [lRequest setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *lResponse;
    
    [NSURLConnection sendSynchronousRequest:lRequest returningResponse:&lResponse error: NULL];
    
    return ([lResponse statusCode] == 200) ? YES : NO;
}

#pragma mark - UIWebView delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if([self connectedToInternet] == NO){
        UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:@"Check internet connection!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [lAlert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
        
        
    }
    
    [self getUserAthorizationData:request.URL];
    
    if([request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound){
        [self dismissViewControllerAnimated:YES completion:nil];
           
        return NO;
    
    }
    
    if([request.URL.absoluteString isEqual:@"https://oauth.vk.com/blank.html#error=access_denied&error_reason=user_denied&error_description=User%20denied%20your%20request"]){
        UIAlertView *lAlert = [[UIAlertView alloc] initWithTitle:@"You must log in" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [lAlert show];
        return NO;
    }
    
        return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    
    [indicator stopAnimating];
    [indicator setHidden:YES];
    
    
}

- (IBAction)cancelBtnTap:(id)sender {
    
    
    
    [self vkLoginCancel];
}
@end
