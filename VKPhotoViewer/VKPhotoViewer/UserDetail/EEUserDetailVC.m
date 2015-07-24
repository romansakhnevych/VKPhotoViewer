//
//  EEUserDetailVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEUserDetailVC.h"
#import "EEAppManager.h"

@interface EEUserDetailVC ()

@end

@implementation EEUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail";
    [_spinner startAnimating];
    
   [_mainPhoto.layer setCornerRadius:_mainPhoto.frame.size.width/2];
    _mainPhoto.layer.masksToBounds = YES;
    
    [[EEAppManager sharedAppManager] getDetailForUserWithCompletionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
        
       dispatch_async(dispatch_get_main_queue(), ^{
         
           if (friendModel.city&&friendModel.country){
            _city.text = [NSString stringWithFormat:@"from %@, %@",friendModel.city,friendModel.country];
           }
           else if (friendModel.city){
               _city.text = [NSString stringWithFormat:@"from %@",friendModel.city];
           }
           else if (friendModel.country){
               _city.text = [NSString stringWithFormat:@"from %@",friendModel.country];
           }
           else{
               _city.text = @"";
           }
           [_spinner stopAnimating];
           [_spinner setHidden:YES];
           [_loadingView setHidden:YES];

       });
        
    } completionFailure:^(NSError *error) {
        
    }];
    EEFriends *lUser = [EEAppManager sharedAppManager].currentFriend;
    _fullName.text = [lUser getFullName];
    [[EEAppManager sharedAppManager] getPhotoByLink:lUser.bigPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
        _mainPhoto.image = image;
            }];
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 6;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell1";
    UITableViewCell *lCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(lCell==nil){
        
        lCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    
    
    
    return lCell;
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
