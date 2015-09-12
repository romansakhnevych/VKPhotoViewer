//
//  EEAlbumsVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEAlbumsVC.h"
#import "EEAppManager.h"
#import "EELoadingCellTableViewCell.h"
#import "EEAlbumCell.h"
#import "EEAlbum.h"
#import "UIImageView+Haneke.h"

@interface EEAlbumsVC ()

@end

@implementation EEAlbumsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Albums";
    _albumsList = [[NSMutableArray alloc] init];
    _count = 4;
    _offset = 0;
    _user = [EEAppManager sharedAppManager].currentFriend;
    [self updateDataWithCount:_count Offset:_offset Id:_user.userId];
    [self.navigationController setNavigationBarHidden:NO];
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
    return [_albumsList count];
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *lNib;
    if (indexPath.row == [tableView numberOfRowsInSection:0]-1 && _loadedAlbumsCount == _count){
        
        [self updateDataWithCount:_count Offset:_offset Id:_user.userId];
        
        static NSString *CellId = @"LoaingCell";
        EELoadingCellTableViewCell *lLastCell = (EELoadingCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
        
        if (lLastCell == nil){
            lNib = [[NSBundle mainBundle] loadNibNamed:@"LoadingCell" owner:self options:nil];
            lLastCell = [lNib objectAtIndex:0];
        }
        [lLastCell.spinner startAnimating];
        
        return lLastCell;
    }
    
    static NSString *CellId = @"AlbumCell";
    EEAlbumCell *lCell = (EEAlbumCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
    
    if (lCell == nil){
        lNib = [[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil];
        lCell = [lNib objectAtIndex:0];
    }
    lCell.albumCover.image = [UIImage imageNamed:@"placeholder.png"];
    EEAlbum *lAlbum = [_albumsList objectAtIndex:indexPath.row];
    lCell.albumTitle.text = lAlbum.albumTitle;
    lCell.albumSize.text = [lAlbum getAlbumSize];
    [lCell.albumCover hnk_setImageFromURL:[NSURL URLWithString:lAlbum.albumThumbLink]];
    return lCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"photosView"];
    [[self navigationController] pushViewController:lViewController animated:YES];
    [EEAppManager sharedAppManager].currentAlbum = [_albumsList objectAtIndex:indexPath.row];
}

#pragma mark - Private mathods
- (void)updateDataWithCount:(NSInteger)count
                     Offset:(NSInteger)offset
                         Id:(NSString *)userId{
    [[EEAppManager sharedAppManager] getAlbumsWithCount:count offset:offset Id:userId completionSuccess:^(id responseObject) {
        if([responseObject isKindOfClass:[NSMutableArray class]]){
            [_albumsList addObjectsFromArray:responseObject];
            _loadedAlbumsCount = [responseObject count];
            _offset+=4;
        }else{
            NSLog(@"Error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } completionFailure:^(NSError *error) {
        [[EEAppManager sharedAppManager] showAlertWithError:error];
        //NSLog(@"error - %@",error);
    }];
    
}



@end
