//
//  UIViewController+Prototype.m
//  ScrollView
//
//  Created by wannabewize on 2014. 4. 21..
//  Copyright (c) 2014년 VanillaStep. All rights reserved.
//

// version 2014.04.22

#import "UIViewController+Prototype.h"
#import <objc/runtime.h>


@implementation UIViewController (Prototype)

-(IBAction)dissmissModalScene:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)popScene:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
  // 키보드가 나타나고 사라지는 알림에 대한 감시 객체 설정
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  [self loadWebPage];
}

-(void)loadWebPage {
  UIWebView *webView = (UIWebView *)[self findViewByClass:[UIWebView class]];
  
  if ( [webView respondsToSelector:@selector(url)]) {
    NSString *urlStr = [webView performSelector:@selector(url)];

    NSURL *url = [[NSBundle mainBundle] URLForResource:urlStr withExtension:nil];
    if ( url == nil ) {
      url = [NSURL URLWithString:urlStr];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
  }
}


-(void)viewWillDisappear:(BOOL)animated {
  // 감시 객체 해제
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews {
  // viewWillAppear 에서 ScrollView가 subview에 없음! 왜?
  [self setScrollViewContentSize];
}

-(UIView *)findViewByClass:(Class)class {
  for (UIView *view in self.view.subviews) {
    if ( [view isMemberOfClass:class] ) {
      return view;
    }
  }
  return nil;
}

-(UIScrollView *)scrollView {
  return (UIScrollView *)[self findViewByClass:[UIScrollView class]];
}

@end

@implementation UIViewController (ImagePicker_Prototype)

-(void)pickImage:(id)sender {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.delegate = self;
  
  if ( [sender isMemberOfClass:[UIButton class]]) {
    UIButton *button = (UIButton *)sender;
    UIImageView *imageView = button.pickedImageView;
    if ( imageView ) {
      objc_setAssociatedObject(picker, @"ResultImageView", imageView, OBJC_ASSOCIATION_ASSIGN);
    }
  }
  
  [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImageView *imageView = objc_getAssociatedObject(picker, @"ResultImageView");
  if ( imageView ) {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    imageView.image = originalImage;
  }
  
  [picker dismissViewControllerAnimated:YES completion:nil];
}

@end




@implementation UIScrollView (Prototype)

-(CGSize)scrollViewContentSize {
  NSValue *value = (objc_getAssociatedObject(self, @"ContentSize"));
  return [value CGSizeValue];
}

-(void)setScrollViewContentSize:(CGSize)size {
  NSValue *value = [NSValue valueWithCGSize:size];
  objc_setAssociatedObject(self, @"ContentSize", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIButton (ImagePicker_Prototype)

-(UIImageView *)pickedImageView {
  return objc_getAssociatedObject(self, @"ImageView");
}

-(void)setPickedImageView:(UIImageView *)pickedImageView {
  objc_setAssociatedObject(self, @"ImageView", pickedImageView, OBJC_ASSOCIATION_ASSIGN);
}

@end


@interface AllDataSource : NSObject <UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *data;

-(instancetype)initWithDataFile:(NSString *)fileName;

@end

@implementation AllDataSource

-(instancetype)initWithDataFile:(NSString *)fileName {
  self = [super init];
  if ( self ) {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    self.data = [NSArray arrayWithContentsOfFile:filePath];
  }
  return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.data.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return self.data[row];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *cellID = tableView.cellID ? tableView.cellID : @"CellID";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  if ( !cell ) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  // Alternatively
  if ( nil == cell )
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
  cell.textLabel.text = [NSString stringWithFormat:@"%@", self.data[indexPath.row]];
  return cell;
}

@end

@implementation UITableView (Prototype)

-(void)setPlistName:(NSString *)plistName {
  AllDataSource *ds = [[AllDataSource alloc] initWithDataFile:plistName];
  self.dataSource = ds;
  objc_setAssociatedObject(self, @"DS", ds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)plistName {
  return nil;
}

-(void)setCellID:(NSString *)cellID {
  objc_setAssociatedObject(self, @"Cell_ID", cellID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)cellID {
  return objc_getAssociatedObject(self, @"Cell_ID");
}

@end

@implementation UIWebView (Prototype)

-(NSString *)url {
  return objc_getAssociatedObject(self, @"URL");
}

-(void)setUrl:(NSString *)url {
  objc_setAssociatedObject(self, @"URL", url, OBJC_ASSOCIATION_RETAIN);
}


@end

@implementation UIPickerView (Prototype)

-(void)setPlistName:(NSString *)plistName {
  AllDataSource *ds = [[AllDataSource alloc] initWithDataFile:plistName];
  self.dataSource = ds;
  self.delegate = ds;
  objc_setAssociatedObject(self, @"DS", ds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)plistName {
  return nil;
}

@end


@implementation UIViewController (Keyboard_Prototype)
-(IBAction)didEndOnExit:(id)sender {
}

// 자식뷰 구조에서 편집 상태의 텍스트필드 찾아서 키보드 감추기
-(IBAction)dismissKeyboard:(id)sender {
  UIResponder *firstResponder = [self firstResponderInView:self.view];
  [firstResponder resignFirstResponder];
  
}

// 자식뷰 구조에서 편집 상태의 텍스트필드 찾기
-(UIResponder *)firstResponderInView:(UIView *)view {
  for (UIView *childView in view.subviews) {
    if ( [childView isFirstResponder]) {
      return childView;
    }
    else if ( [childView.subviews count] > 0 ) {
      UIResponder *ret = [self firstResponderInView:childView];
      if ( ret ) {
        return ret;
      }
    }
  }
  return nil;
}

// 키보드가 나타나면 동작하는 감시 메소드
- (void)keyboardWillShow:(NSNotification*)aNotification {
  // 키보드 높이 구하기
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  // 스크롤 뷰의 컨텐츠 표시 영역을 키보드의 높이만큼 제하기
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
  // 뷰의 크기에서 키보드의 높이를 제한 영역을 구하기
  CGRect aRect = self.view.frame;
  aRect.size.height = aRect.size.height - kbSize.height;
  
  UIView *activeField = (UIView *)[self firstResponderInView:self.view];
  
  // 편집 중인 텍스트 필드가 키보드에 가려진 영역인지 체크
  if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    // 스크롤 시키는 범위 구하기
    
    CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
  }
}

// 키보드가 사라지면 동작하는 감시 메소드
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
  // 애니메이션
  [UIView animateWithDuration:0.25 animations:^{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
  }];
}

@end


#pragma mark ScrollView-Extension

@implementation UIViewController (ScrollView_Prototype)

-(void)setScrollViewContentSize {
  UIScrollView *scrollView = (UIScrollView *)[self findViewByClass:[UIScrollView class]];
  if ( scrollView ) {
    CGSize size = scrollView.scrollViewContentSize;
    NSLog(@"Setting ScrollView Content size : %@", NSStringFromCGSize(size));
    scrollView.contentSize = size;
  }
}

@end


