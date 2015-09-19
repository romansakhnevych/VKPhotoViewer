//
//  LeftViewController.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEAppManager.h"
#import "EECustomTableHeaderView.h"

@interface LeftViewController : UITableViewController <EEAppManagerDelegate, EECustomTableHeaderViewDelegate>

@property (strong, nonatomic) UIColor *tintColor;

@end
