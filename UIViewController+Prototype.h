//
//  UIViewController+Prototype.h
//  ScrollView
//
//  Created by wannabewize on 2014. 4. 21..
//  Copyright (c) 2014년 VanillaStep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Prototype)

@property CGSize scrollViewContentSize;
@property (readonly) UIScrollView *scrollView;

@end
