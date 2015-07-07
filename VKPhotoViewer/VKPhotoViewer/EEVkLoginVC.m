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

@end

@implementation EEVkLoginVC

@synthesize vkLoginWebView;
@synthesize indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [indicator startAnimating];
    
    if(!vkLoginWebView){
        self.vkLoginWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        vkLoginWebView.delegate = self;
        vkLoginWebView.scalesPageToFit = YES;
        [self.view addSubview:vkLoginWebView];
    }
    
    NSString *lauthString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&scope=%@&redirect_uri=%@&display=%@&v=%@&response_tipe=token", APP_ID,SCOPE,REDIRECT_URI,DISPLAY,API_VERSION];
    NSURL *lauthUrl = [NSURL URLWithString:lauthString];
    [vkLoginWebView loadRequest:[NSURLRequest requestWithURL:lauthUrl]];
}

- (NSString*)stringBetween:(NSString *)start andString:(NSString *)end innerString:(NSString *)str
{
    NSScanner *lscanner = [NSScanner scannerWithString:str];
    [lscanner setCharactersToBeSkipped:nil];
    [lscanner scanUpToString:start intoString:NULL];
    if([lscanner scanString:start intoString:NULL]){
        NSString *lresult = nil;
        if([lscanner scanUpToString:end intoString:&lresult]){
            return lresult;
        }
    }
    
    return nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   // if([vkLoginWebView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound){
        
       // NSString *accessToken = [self]
        
    //}
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
