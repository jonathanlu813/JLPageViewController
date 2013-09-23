//
//  JLPageViewController.m
//  LoverToDo
//
//  Created by Jonathan Lu on 22/9/13.
//  Copyright (c) 2013 Jonathan Lu. All rights reserved.
//

#import "JLPageViewController.h"

@interface JLPageViewController ()

@end

@implementation JLPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [self.titles objectAtIndex:[self.viewControllers indexOfObject:self.selectedViewController]];
    
    [self.view addSubview:self.sideViewController.view];
    isSideViewShown = NO;
    [self addChildViewController:self.sideViewController];
    
    pageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    pageScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * [self.viewControllers count], self.view.bounds.size.height);
    for (UIViewController *controller in self.viewControllers) {
        [pageScrollView addSubview:controller.view];
        [self addChildViewController:controller];
    }
    [pageScrollView setBounces:NO];
    [pageScrollView setContentOffset:CGPointZero];
    [self.view addSubview:pageScrollView];
    
    pageScrollView.delegate = self;
    pageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    pageChangedByDragging = NO;
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = [self.viewControllers count];
    pageControl.currentPage = 0;
    [self.navigationController.navigationBar addSubview:pageControl];
    pageControl.center = self.navigationController.navigationBar.center;
    CGRect frame = pageControl.frame;
    frame.origin.y -= 5;
    pageControl.frame = frame;
    pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.frame;
    
    self.sideViewController.view.frame = CGRectMake(-self.sideViewWidth, 0, self.sideViewWidth, frame.size.height);
    
    for (int i = 0; i < [self.viewControllers count]; i++) {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        controller.view.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
    if (index == 0 || isSideViewShown){
        return YES;
    }
    else{
        return NO;
    }
}

- (IBAction)pan:(UIPanGestureRecognizer*)gestureRecognizer{
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (gestureRecognizer.view == self.view) {
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGRect frame = pageScrollView.frame;
            if (isSideViewShown) {
                frame.origin.x = self.sideViewWidth + translation.x;
            }
            else{
                frame.origin.x = translation.x;
            }
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            if (frame.origin.x > self.sideViewWidth) {
                frame.origin.x = self.sideViewWidth;
            }
            pageScrollView.frame = frame;
            
            frame = self.sideViewController.view.frame;
            if (isSideViewShown) {
                frame.origin.x = translation.x;
            }
            else{
                frame.origin.x = translation.x - self.sideViewWidth;
            }
            if (frame.origin.x < - self.sideViewWidth) {
                frame.origin.x = - self.sideViewWidth;
            }
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
            }
            self.sideViewController.view.frame = frame;
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.2f];
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [animation setType:kCATransitionFade];
            
            [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2f];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            if (!isSideViewShown) {
                if (translation.x > self.sideViewWidth / 2 || velocity.x > 500) {
                    CGRect frame = pageScrollView.frame;
                    frame.origin.x = self.sideViewWidth;
                    pageScrollView.frame = frame;
                    
                    frame = self.sideViewController.view.frame;
                    frame.origin.x = 0;
                    self.sideViewController.view.frame = frame;
                    
                    pageScrollView.alpha = isSideViewShown ? 1.0 : 0.5;
                    
                    pageControl.currentPageIndicatorTintColor = isSideViewShown ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
                    [self.navigationItem.rightBarButtonItem setEnabled:isSideViewShown];
                    
                    [UIView commitAnimations];
                    
                    [pageScrollView setUserInteractionEnabled:isSideViewShown];
                    for (UIPanGestureRecognizer *gr in pageScrollView.gestureRecognizers) {
                        gr.enabled = isSideViewShown;
                    }
                    
                    isSideViewShown = !isSideViewShown;
                    self.title = isSideViewShown ? self.sideViewTitle : [self.titles objectAtIndex:[self.viewControllers indexOfObject:self.selectedViewController]];
                }
                else{
                    CGRect frame = pageScrollView.frame;
                    frame.origin.x = 0;
                    pageScrollView.frame = frame;
                    
                    frame = self.sideViewController.view.frame;
                    frame.origin.x = -self.sideViewWidth;
                    self.sideViewController.view.frame = frame;
                    [UIView commitAnimations];
                }
            }
            if (isSideViewShown) {
                if (translation.x < -self.sideViewWidth / 2 || velocity.x < - 500) {
                    CGRect frame = pageScrollView.frame;
                    frame.origin.x = 0;
                    pageScrollView.frame = frame;
                    
                    frame = self.sideViewController.view.frame;
                    frame.origin.x = - self.sideViewWidth;
                    self.sideViewController.view.frame = frame;
                    pageScrollView.alpha = isSideViewShown ? 1.0 : 0.5;
                    
                    pageControl.currentPageIndicatorTintColor = isSideViewShown ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
                    [self.navigationItem.rightBarButtonItem setEnabled:isSideViewShown];
                    
                    [UIView commitAnimations];
                    
                    [pageScrollView setUserInteractionEnabled:isSideViewShown];
                    for (UIPanGestureRecognizer *gr in pageScrollView.gestureRecognizers) {
                        gr.enabled = isSideViewShown;
                    }
                    
                    isSideViewShown = !isSideViewShown;
                    self.title = isSideViewShown ? self.sideViewTitle : [self.titles objectAtIndex:[self.viewControllers indexOfObject:self.selectedViewController]];
                }
                else{
                    CGRect frame = pageScrollView.frame;
                    frame.origin.x = self.sideViewWidth;
                    pageScrollView.frame = frame;
                    
                    frame = self.sideViewController.view.frame;
                    frame.origin.x = 0;
                    self.sideViewController.view.frame = frame;
                    [UIView commitAnimations];
                }
            }
        }
    }
}

- (IBAction)showSideView:(id)sender{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.2f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setType:kCATransitionFade];
    
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    CGRect frame = pageScrollView.frame;
    frame.origin.x = isSideViewShown ? 0 : self.sideViewWidth;
    pageScrollView.frame = frame;
    
    frame = self.sideViewController.view.frame;
    frame.origin.x = isSideViewShown ? -self.sideViewWidth : 0;
    self.sideViewController.view.frame = frame;
    
    pageScrollView.alpha = isSideViewShown ? 1.0 : 0.5;
    
    pageControl.currentPageIndicatorTintColor = isSideViewShown ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor;
    [self.navigationItem.rightBarButtonItem setEnabled:isSideViewShown];
    
    [UIView commitAnimations];
    
    [pageScrollView setUserInteractionEnabled:isSideViewShown];
    for (UIPanGestureRecognizer *gr in pageScrollView.gestureRecognizers) {
        gr.enabled = isSideViewShown;
    }
    isSideViewShown = !isSideViewShown;
    self.title = isSideViewShown ? self.sideViewTitle : [self.titles objectAtIndex:[self.viewControllers indexOfObject:self.selectedViewController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (fabs(velocity.x) > 0.5 && !pageChangedByDragging) {
        NSInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
        if (velocity.x > 0 && index < [self.viewControllers count] - 1) {
            self.selectedViewController = [self.viewControllers objectAtIndex:index + 1];
            targetContentOffset->x = self.selectedViewController.view.frame.origin.x;
        }
        else if (velocity.x < 0 && index > 0){
            self.selectedViewController = [self.viewControllers objectAtIndex:index - 1];
            targetContentOffset->x = self.selectedViewController.view.frame.origin.x;
        }
    }
    else{
        targetContentOffset->x = self.selectedViewController.view.frame.origin.x;
        if (pageChangedByDragging) {
            pageChangedByDragging = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging && !scrollView.decelerating) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
        CGFloat left = -1000;
        if (index != 0) {
            CGRect leftFrame = ((UIViewController*)[self.viewControllers objectAtIndex:index - 1]).view.frame;
            left = leftFrame.origin.x + leftFrame.size.width / 2;
        }
        CGFloat right = -1000;
        if (index != [self.viewControllers count] - 1) {
            CGRect middleFrame = ((UIViewController*)[self.viewControllers objectAtIndex:index]).view.frame;
            right = middleFrame.origin.x + middleFrame.size.width / 2;
        }
        
        if (left > 0 && x < left) {
            self.selectedViewController = [self.viewControllers objectAtIndex:index - 1];
            pageChangedByDragging = YES;
        }
        else if (right > 0 && x < right){
            
        }
        else if (right > 0){
            self.selectedViewController = [self.viewControllers objectAtIndex:index + 1];
            pageChangedByDragging = YES;
        }
    }
    
    NSInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
    
    if (index) {
        [scrollView setBounces:YES];
    }
    else{
        [scrollView setBounces:NO];
    }
    
    pageControl.currentPage = index;
    self.title = [self.titles objectAtIndex:index];
}

@end

