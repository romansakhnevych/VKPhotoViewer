//
//  EEFriendsCountCell.m
//  VKPhotoViewer
//
//  Created by Lyubomyr Hlozhyk on 9/12/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "EEFriendsCountCell.h"

@interface EEFriendsCountCell ()
@property(nonatomic, strong) IBOutlet UILabel *countLabel;
@end

@implementation EEFriendsCountCell

- (void)setCount:(NSInteger)count {
    _count = count;
    _countLabel.text = [NSString stringWithFormat:@"%li", _count];
}

@end
