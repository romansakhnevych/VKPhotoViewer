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
    [self.imageView hnk_setImageFromURL:[NSURL URLWithString:self.linkForPhoto]];
    [self testMethod];
}

-(void)testMethod {
    [[EEAppManager sharedAppManager] recieveLnkForPhotoCompletionSuccess:^(id responseObject) {
        self.linkInService = [[responseObject objectForKey:@"response"] objectForKey:@"upload_url"];
        NSLog(@"%@",responseObject);

        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.linkForPhoto]];
        
        //цей запит вертає помилку чомцсь
        [[EEAppManager sharedAppManager] postPhotoWithData:data onUrl:self.linkInService CompletionSuccess:^(id responseObject) {
            self.hashServ = [[responseObject objectForKey:@"response"] objectForKey:@"hash"];
            self.photoUrlId = [[responseObject objectForKey:@"response"] objectForKey:@"photo"];
            self.server = [[responseObject objectForKey:@"response"] objectForKey:@"server"];
            [[EEAppManager sharedAppManager] savePhoto:self.photoUrlId InServiceWithUserId: [EEAppManager sharedAppManager].currentFriend.userId AndHash:self.hashServ AndServer:self.server CompletionSuccess:^(id responseObject) {
                self.filtredPhoto = [EEPhoto new];
                self.filtredPhoto.photoId = [[responseObject valueForKey:@"response"] valueForKey:@"photoId"];
                
                [[EEAppManager sharedAppManager] postPhoto:self.filtredPhoto.photoId OnWall:[EEAppManager sharedAppManager].currentFriend.userId CompletionSuccess:^(id responseObject) {
                    NSLog(@"%@", responseObject);
                } CompletionFailure:^(NSError *error) {
                    NSLog(@"%@", error);
                }];
            } CompletitionFailure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
            
            
        } completionFailure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } completionFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
