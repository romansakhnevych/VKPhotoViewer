//
//  UIView+PMViewCreator.m
//  planckMailiOS
//
//  Created by admin on 5/24/15.
//  Copyright (c) 2015 LHlozhyk. All rights reserved.
//

#import "UIView+EEViewCreator.h"

@implementation UIView (EEViewCreator)

+ (instancetype)createView {
    UIView *lView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if ([lView isKindOfClass:[self class]]){
        return lView;
    } else {
        return nil;
    }
}

@end
