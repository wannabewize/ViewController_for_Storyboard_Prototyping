//
//  UIViewController+Prototype.h
//  ScrollView
//
//  Created by wannabewize on 2014. 4. 21..
//  Copyright (c) 2014년 VanillaStep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Prototype)
-(UIView *)findViewByClass:(Class)class;
@end

@interface UIViewController (Keyboard_Prototype)
@end

@interface UIViewController (ScrollView_Prototype)
-(void)setScrollViewContentSize;
@end


@class AllDataSource;
@interface UIViewController (DataSource_Prototype)
@property (strong, nonatomic) AllDataSource *dataSource;
-(void)registTableViewDataSource;
@end


#pragma mark View-Extension

@interface UITableView(Prototype)
@property (strong, nonatomic) IBInspectable NSString *plistName;
@property (strong, nonatomic) IBInspectable NSString *cellID;
@end

@interface UIPickerView(Prototype)
@property (strong, nonatomic) IBInspectable NSString *plistName;
@end

@interface UIScrollView (Prototype)
@property IBInspectable CGSize scrollViewContentSize;
@end