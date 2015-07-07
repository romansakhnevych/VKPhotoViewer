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
    if([vkLoginWebView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound){
        
        NSString *laccessToken = [self stringBetween:@"access_token=" andString:@"&" innerString:[[[webView request]URL]absoluteString]];
        NSString *ltokenLifeTime = [self stringBetween:@"expires_in=" andString:@"&" innerString:[[[webView request]URL]absoluteString]];
        NSArray *luserArray = [[[[webView request]URL]absoluteString] componentsSeparatedByString:@"&user_id="];
        NSString *luserID = [luserArray lastObject];
        NSLog(@"token:%@",laccessToken);
        NSLog(@"expires_in:%@",ltokenLifeTime);
        NSLog(@"user_id:%@",luserID);
        
        
        if(luserID){
            [[NSUserDefaults standardUserDefaults] setObject:luserID forKey:@"vkUserId"];
        }
        if(ltokenLifeTime){
            [[NSUserDefaults standardUserDefaults] setObject:ltokenLifeTime forKey:@"vkTokenLifeTime"];
        }
        if(laccessToken){
            [[NSUserDefaults standardUserDefaults] setObject:laccessToken forKey:@"vkAccessToken"];
        }
        
        NSLog(@"vkLoginWebView response: %@",[[[vkLoginWebView request]URL]absoluteString]);
    }
    else if([vkLoginWebView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound){
        NSLog(@"error: %@", vkLoginWebView.request.URL.absoluteString);
    }
    
    [indicator stopAnimating];
    [indicator setHidden:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
