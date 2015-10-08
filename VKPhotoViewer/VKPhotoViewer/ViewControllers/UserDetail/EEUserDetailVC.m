//
//  EEUserDetailVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/21/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEUserDetailVC.h"
#import "EEAppManager.h"
#import "UIImage+StackBlur.h"
#import "EEUserDetailCell.h"
#import "EEPhotoGalleryVC.h"
#import "MBProgressHUD.h"
#import "Constants.h"

@interface EEUserDetailVC ()

@end

@implementation EEUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *localizedDetailString = NSLocalizedString(@"DetailKey", @"");

    //self.navigationItem.title = @"Detail";
    self.navigationItem.title = localizedDetailString;
    [_spinner setHidden:NO];
    [_spinner startAnimating];
    [_loadingView setHidden:NO];
    
    [_buttonWithAvatar.imageView.layer setCornerRadius:_buttonWithAvatar.frame.size.width/2];
    _buttonWithAvatar.imageView.layer.masksToBounds = YES;
    _buttonWithAvatar.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _buttonWithAvatar.imageView.layer.borderWidth = 2;
    [self.navigationController setNavigationBarHidden:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[EEAppManager sharedAppManager] getDetailByUserId:[EEAppManager sharedAppManager].currentFriend.userId
                                         completionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 
                                                 _city.text = [friendModel getLocation];
                                                 _albumsCountLabel.text = [friendModel getAlbumsCount];
                                                 _photosCountLabel.text = [friendModel getPhotosCount];
                                                 _details = [friendModel getDetails];
                                                 _keys = [_details allKeys];
                                                 [self.tableView reloadData];
                                             });
                                             
                                         } completionFailure:^(NSError *error) {
                                             NSLog(@"%@",error);
                                         }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    EEFriends *lUser = [EEAppManager sharedAppManager].currentFriend;
    
    _fullName.text = [lUser getFullName];
    [[EEAppManager sharedAppManager] getPhotoByLink:lUser.bigPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
        _buttonWithAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _buttonWithAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _buttonWithAvatar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _buttonWithAvatar.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_buttonWithAvatar setImage:image forState:UIControlStateNormal];
        [_buttonWithAvatar setImage:image forState:UIControlStateHighlighted];
        [_buttonWithAvatar setImage:image forState:UIControlStateDisabled];
        _backgroundPhoto.image = [image stackBlur:6];
    }];
    
    
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
    [_loadingView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count;
    if ([_details count]){
        count = [_keys count];
    }
    else{
        count = 5;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"UserDetailCell";
    EEUserDetailCell *lCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(lCell==nil){
        NSArray *lNib = [[NSBundle mainBundle] loadNibNamed:@"UserDetailCell" owner:self options:nil];
        lCell = [lNib objectAtIndex:0];
    }
    if (_details){
        id lKey = [_keys objectAtIndex:indexPath.row];
        lCell.titleLable.text = (NSString *)lKey;
        lCell.mainTextLable.text = [_details objectForKey:lKey];
    }
    return lCell;
}

#pragma mark - Button Loading Methods

- (void)avatarCkicked:(id)sender {
    [[EEAppManager sharedAppManager] getAlbumWithId:ALBUM_WITH_AVATARS_ID completionSuccess:^(id responseObject){
        [EEAppManager sharedAppManager].currentAlbum = responseObject[0];
        [[EEAppManager sharedAppManager] getPhotosWithCount:60 offset:0 fromAlbum:ALBUM_WITH_AVATARS_ID forUser:[EEAppManager sharedAppManager].currentFriend.userId completionSuccess:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSMutableArray class]]){
            
                
                NSMutableArray *lArray = [NSMutableArray array];
                [lArray addObjectsFromArray:responseObject];
                [EEAppManager sharedAppManager].currentPhoto = [lArray objectAtIndex:0];
                EEPhotoGalleryVC *lViewController = [[EEPhotoGalleryVC alloc] initWithAllPhotos:lArray currentIndex:0];
                lViewController.isDetailed = YES;
                [[self navigationController] presentViewController:lViewController animated:YES completion:nil];
            }else{
                NSLog(@"error");
            }
        } completionFailure:^(NSError *error) {
            NSLog(@"error - %@",error);
        }];
    } completionFailure:^(NSError *error){
        
        NSLog(@"error - %@",error);
    }];
}

- (void)setAlbum {
    
}

@end
