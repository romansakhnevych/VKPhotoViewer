//
//  EEFriendsListVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/13/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriendsListVC.h"
#import "Constants.h"
#import "EEFriends.h"
#import "EEResponseBilder.h"
#import "EERequests.h"

@interface EEFriendsListVC ()

@end

@implementation EEFriendsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _friendsList = [[NSMutableArray alloc] init];
    _count = 0;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout)];
    
    [self loadFirendsWithOffset];
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_friendsList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row] == [tableView numberOfRowsInSection:0]-1) {
        
        [self loadFirendsWithOffset];
        
    }
    
    
    static NSString *CellIdentifier=@"Cell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=self.view.backgroundColor;
    EEFriends *lUser = [_friendsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [lUser getFullName];
   
    
    return cell;
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)loadFirendsWithOffset{
    if(_endOfList == NO){
    NSMutableURLRequest *lRequest = [EERequests friendsGetRequestWithOffset:_count];
    
    [NSURLConnection sendAsynchronousRequest:lRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([data length] > 0 && connectionError == nil){
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"{\"response\":[]}"]){
                _endOfList = YES;
            }
            NSLog(@"FIREND -- %@",str);
             NSDictionary *lJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [_friendsList addObjectsFromArray:[EEResponseBilder getFriendsFromDictionary:lJson]];
            [self.tableView reloadData];
            
        }
        _count+=30;
    }];
    
    }

}

- (void)Logout{
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:lViewController animated:YES];
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY ];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
