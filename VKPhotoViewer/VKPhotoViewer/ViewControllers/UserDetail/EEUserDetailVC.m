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


@interface EEUserDetailVC ()

@end

@implementation EEUserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail";
    [_spinner setHidden:NO];
    [_spinner startAnimating];
    [_loadingView setHidden:NO];
    
    [_buttonWithAvatar.imageView.layer setCornerRadius:_buttonWithAvatar.frame.size.width/2];
    _buttonWithAvatar.imageView.layer.masksToBounds = YES;
    _buttonWithAvatar.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _buttonWithAvatar.imageView.layer.borderWidth = 2;
    [self.navigationController setNavigationBarHidden:NO];
    
    [[EEAppManager sharedAppManager] getDetailForUserWithCompletionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
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
    
    EEFriends *lUser = [EEAppManager sharedAppManager].currentFriend;
    
    _fullName.text = [lUser getFullName];
    [[EEAppManager sharedAppManager] getPhotoByLink:lUser.bigPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
        _buttonWithAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _buttonWithAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _buttonWithAvatar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _buttonWithAvatar.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [_buttonWithAvatar setImage:image forState:UIControlStateNormal];
        [_buttonWithAvatar setImage:image forState:UIControlStateHighlighted];
//        [_buttonWithAvatar setImage:image forState:UIControlStateDisabled];
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
    [[EEAppManager sharedAppManager] getPhotosWithCount:60 offset:0 fromAlbum:@"-6" forUser:[EEAppManager sharedAppManager].currentFriend.userId completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]){
            UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EEPhotoGalleryVC *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"PhotoView"];
            NSMutableArray *lArray = [NSMutableArray array];
            [lArray addObjectsFromArray:responseObject];
            [EEAppManager sharedAppManager].allPhotos = lArray;
            [EEAppManager sharedAppManager].currentPhotoIndex = 0;
            [EEAppManager sharedAppManager].currentPhoto = [[EEAppManager sharedAppManager].allPhotos objectAtIndex:0];
            
            lViewController.baseAlbumDelegate = [[EEAppManager alloc] init];
            [[self navigationController] pushViewController:lViewController animated:YES];
        }else{
            NSLog(@"error");
        }
    } completionFailure:^(NSError *error) {
        NSLog(@"error - %@",error);
    }];
}

- (void)setAlbum {
    
}

@end
