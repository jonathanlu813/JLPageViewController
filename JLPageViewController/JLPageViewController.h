//
//  JLPageViewController.h
//  LoverToDo
//
//  Created by Jonathan Lu on 22/9/13.
//  Copyright (c) 2013 Jonathan Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLPageViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    BOOL pageChangedByDragging;
    BOOL isSideViewShown;
    UIPageControl *pageControl;
    UIScrollView *pageScrollView;
}

@property (retain, nonatomic) NSArray *viewControllers;
@property (retain, nonatomic) NSArray *titles;
@property (retain, nonatomic) NSString *sideViewTitle;
@property (retain, nonatomic) UIViewController *selectedViewController;
@property (retain, nonatomic) UIViewController *sideViewController;
@property (retain, nonatomic) UIColor *currentPageIndicatorTintColor;
@property (retain, nonatomic) UIColor *pageIndicatorTintColor;
@property (nonatomic) CGFloat sideViewWidth;

- (IBAction)showSideView:(id)sender;

@end
