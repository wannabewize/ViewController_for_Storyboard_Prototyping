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
-(IBAction)dissmissModalScene:(id)sender;
-(IBAction)popScene:(id)sender;
@end

@interface UIViewController (ImagePicker_Prototype)
-(IBAction)pickImage:(id)sender;
@end

@interface UIViewController (Keyboard_Prototype)
@end

@interface UIViewController (ScrollView_Prototype)
-(void)setScrollViewContentSize;
@end

@interface UIViewController (TableView_Prototype)
-(void)registTableViewDataSource;
@end



@class AllDataSource;
@interface UIViewController (DataSource_Prototype)
@property (strong, nonatomic) AllDataSource *dataSource;
@end


#pragma mark View-Extension

@interface UITableView(Prototype)
@property (strong, nonatomic) IBInspectable NSString *plistName;
@property (strong, nonatomic) IBInspectable NSString *cellID;
@end

@interface UIScrollView (Prototype)
@property IBInspectable CGSize scrollViewContentSize;
@end


@interface UIButton(ImagePicker_Prototype)
@property (weak, nonatomic) IBOutlet UIImageView *pickedImageView;
@end