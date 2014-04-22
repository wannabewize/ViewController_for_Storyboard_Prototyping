//
//  UIViewController+Prototype.m
//  ScrollView
//
//  Created by wannabewize on 2014. 4. 21..
//  Copyright (c) 2014년 VanillaStep. All rights reserved.
//

// version 2014.04.22

#import "UIViewController+Prototype.h"

@implementation UIViewController (Prototype)

-(IBAction)didEndOnExit:(id)sender {
    
}

-(IBAction)dissmissModalScene:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)popupScene:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


-(CGSize)scrollViewContentSize {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"VC(%p)_SCROLLVIEW_CONTENTSIZE", self];
    NSDictionary *value = [setting valueForKey:key];
    if ( value ) {
        return CGSizeMake([value[@"WIDTH"] floatValue], [value[@"HEIGHT"] floatValue]);
    }
    else {
        return CGSizeZero;
    }
}

-(void)setScrollViewContentSize:(CGSize)scrollViewContentSize {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"VC(%p)_SCROLLVIEW_CONTENTSIZE", self];
    
    NSDictionary *value = @{@"WIDTH":@(scrollViewContentSize.width), @"HEIGHT":@(scrollViewContentSize.height)};
    [setting setObject:value forKey:key];
    [setting synchronize];
}

-(void)viewDidAppear:(BOOL)animated {
	// 키보드가 나타나고 사라지는 알림에 대한 감시 객체 설정
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
	
}

-(UIScrollView *)scrollView {
    for (UIView *child in self.view.subviews) {
        if ( [child isMemberOfClass:[UIScrollView class]]) {
            return (UIScrollView *)child;
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

-(void)viewWillDisappear:(BOOL)animated {
	// 감시 객체 해제
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)viewDidLoad {
    if ( self.scrollView ) {
        self.scrollViewContentSize = self.scrollView.contentSize;
    }
}

-(void)viewDidLayoutSubviews {
    if ( self.scrollView ) {
        self.scrollView.contentSize = self.scrollViewContentSize;
    }
}

@end
