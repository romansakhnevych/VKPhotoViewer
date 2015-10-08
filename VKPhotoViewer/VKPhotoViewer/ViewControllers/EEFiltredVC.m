//
//  EEFiltredVC.m
//  VKPhotoViewer
//
//  Created by админ on 9/15/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFiltredVC.h"
#import "Haneke.h"
#import "EEAppManager.h"

@implementation EEFiltredVC

-(void)viewDidLoad {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForPhoto]];
//    [self testMethod];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)saveButtonPressed {
    
}



#pragma mark - CollectionView delegate and data source methods
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EECollectionViewCellID" forIndexPath:indexPath];
    UIImageView* filtrImageView = (UIImageView*)[cell viewWithTag:111];
    //мають бути картинки з накладеними ефектами
    [filtrImageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForPhoto]];
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //amount of effects
    return 7;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

//-(void)testMethod {
//    [[EEAppManager sharedAppManager] recieveLnkForPhotoCompletionSuccess:^(id responseObject) {
//        self.linkInService = [[responseObject objectForKey:@"response"] objectForKey:@"upload_url"];
//        NSLog(@"%@",responseObject);
//
//        UIImage* imageD = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.linkForPhoto]]];
//        NSData* data = UIImagePNGRepresentation(imageD);
//        
//        //цей запит вертає помилку чомцсь
//        [[EEAppManager sharedAppManager] postPhotoWithData:data onUrl:self.linkInService CompletionSuccess:^(id responseObject) {
//            self.hashServ = [responseObject objectForKey:@"hash"];
//            self.photoUrlId = [responseObject objectForKey:@"photo"];
//            self.server = [responseObject objectForKey:@"server"];
//            [[EEAppManager sharedAppManager] savePhoto:self.photoUrlId InServiceWithUserId: [EEAppManager sharedAppManager].currentFriend.userId AndHash:self.hashServ AndServer:self.server CompletionSuccess:^(id responseObject) {
//                self.filtredPhoto = [EEPhoto new];
//                self.filtredPhoto.photoId = [[responseObject valueForKey:@"response"] valueForKey:@"photoId"];
//                
//                [[EEAppManager sharedAppManager] postPhoto:self.filtredPhoto.photoId OnWall:[EEAppManager sharedAppManager].currentFriend.userId CompletionSuccess:^(id responseObject) {
//                    NSLog(@"%@", responseObject);
//                } CompletionFailure:^(NSError *error) {
//                    NSLog(@"%@", error);
//                }];
//            } CompletitionFailure:^(NSError *error) {
//                NSLog(@"%@", error);
//            }];
//            
//            
//        } completionFailure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
//        
//    } completionFailure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}
@end
