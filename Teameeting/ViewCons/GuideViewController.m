//
//  GuideViewController.m
//  Teameeting
//
//  Created by yangyang on 16/3/1.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "GuideViewController.h"
#import "UIImage+Category.h"
#import "Common.h"
@interface GuideViewController ()<UIScrollViewDelegate>


@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *groudImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    groudImageView.translatesAutoresizingMaskIntoConstraints = NO;
    if (ISIPAD) {
        
        if (CGRectGetWidth(self.view.frame)>CGRectGetHeight(self.view.frame)) {
            
            groudImageView.image = [[UIImage imageNamed:@"homeBackGroundLandscape"] applyBlurWithRadius:0 tintColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8] saturationDeltaFactor:0 maskImage:nil];
            
        } else {
            
            groudImageView.image = [[UIImage imageNamed:@"homeBackGroundPortrait"] applyBlurWithRadius:0 tintColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8] saturationDeltaFactor:0 maskImage:nil];
        }

    } else {
        
        groudImageView.image = [[UIImage imageNamed:@"homeBackGround"] applyBlurWithRadius:0 tintColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8] saturationDeltaFactor:0 maskImage:nil];
    }
    [self.view addSubview:groudImageView];
    NSLayoutConstraint* groudImageControllerLeftConstraint = [NSLayoutConstraint constraintWithItem:groudImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
    NSLayoutConstraint* groudImageControllerTopConstraint = [NSLayoutConstraint constraintWithItem:groudImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
    groudImageControllerLeftConstraint.active = YES;
    groudImageControllerTopConstraint.active = YES;

    self.scrollview = [[UIScrollView alloc] init];
    self.scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollview];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 30, self.view.frame.size.width - 20, 20)];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControl];
    
    if (ISIPAD) {
        
        if (CGRectGetWidth(self.view.frame)>CGRectGetHeight(self.view.frame)) {
        
            self.array = [NSArray arrayWithObjects:@"ipadGuideFirstLandscape",@"ipadGuideSecondLandscape",@"ipadGuideThirdLandscape",@"", nil];
            
        } else {
            
            self.array = [NSArray arrayWithObjects:@"ipadGuideFirstPortrait",@"ipadGuideSecondPortrait",@"ipadGuideThirdPortrait",@"", nil];
        }

    } else {
        
        self.array = [NSArray arrayWithObjects:@"iphoneGuideFirst",@"iphoneGuideSecond",@"iphoneGuideThird",@"", nil];
    }
    self.imageArray = [[NSMutableArray alloc] init];
    self.scrollview.bounces = YES;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = YES;
    self.scrollview.showsVerticalScrollIndicator = YES;

    NSLayoutConstraint* scrollViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
    NSLayoutConstraint* scrollViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
    NSLayoutConstraint* scrollViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    NSLayoutConstraint* scrollViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
    scrollViewLeftConstraint.active = YES;
    scrollViewRightConstraint.active = YES;
    scrollViewTopConstraint.active = YES;
    scrollViewHeightConstraint.active = YES;
    
    NSLayoutConstraint* pageControllerLeftConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f];
    NSLayoutConstraint* pageControllerTopConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.f];
    pageControllerLeftConstraint.active = YES;
    pageControllerTopConstraint.active = YES;
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    static UIImageView *tempImageView = nil;
    NSArray* tempvConstraintArray = nil;
    for (int i = 0; i < [self.array count]; i ++) {
        
        if (i != 0) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.scrollview addSubview:imageView];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.image = [UIImage imageNamed:[self.array objectAtIndex:i]];
            [self.imageArray addObject:imageView];
            if (tempvConstraintArray) {
                
                [NSLayoutConstraint deactivateConstraints:tempvConstraintArray];
            }
            
            NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:@{@"imageView": imageView}];
            [NSLayoutConstraint activateConstraints:vConstraintArray];
            
            
            NSArray* v2ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView]-0-|" options:0 metrics:nil views:@{@"imageView": imageView}];
            [NSLayoutConstraint activateConstraints:v2ConstraintArray];
            
            
            NSArray* v4ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"[tempImageView]-0-[imageView]" options:0 metrics:nil views:@{@"imageView": imageView,@"tempImageView": tempImageView}];
            [NSLayoutConstraint activateConstraints:v4ConstraintArray];
            
            NSLayoutConstraint* imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollview attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
            NSLayoutConstraint* imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollview attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
            imageViewWidthConstraint.active = YES;
            imageViewHeightConstraint.active = YES;
            tempImageView = imageView;
            tempvConstraintArray = v2ConstraintArray;
        
        } else {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            tempImageView = imageView;
            [self.scrollview addSubview:imageView];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.image = [UIImage imageNamed:[self.array objectAtIndex:i]];
            [self.imageArray addObject:imageView];
            
            NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:@{@"imageView": imageView}];
            [NSLayoutConstraint activateConstraints:vConstraintArray];
            
            NSArray* v2ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:@{@"imageView": imageView}];
            [NSLayoutConstraint activateConstraints:v2ConstraintArray];
            
            NSLayoutConstraint* imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollview attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
            NSLayoutConstraint* imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollview attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
            imageViewWidthConstraint.active = YES;
            imageViewHeightConstraint.active = YES;
        }
        
    }
    self.pageControl.numberOfPages = [self.array count] - 1;
    self.pageControl.currentPage = 0;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (![scrollView isMemberOfClass:[UITableView class]]) {
        
        int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
        self.pageControl.currentPage = index;
        if (index == 3) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.view.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [self.view removeFromSuperview];
            }];
             
        }
    }
}

- (void)viewDidLayoutSubviews {
    
    if (!ISIPAD)
        return;
        
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
    
        self.array = [NSArray arrayWithObjects:@"ipadGuideFirstPortrait",@"ipadGuideSecondPortrait",@"ipadGuideThirdPortrait",@"", nil];
        for (int i = 0; i < [self.imageArray count]; i++) {
            
            UIImageView *item = [self.imageArray objectAtIndex:i];
            item.image = [UIImage imageNamed:[self.array objectAtIndex:i]];
            
        }
        
    } else if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        self.array = [NSArray arrayWithObjects:@"ipadGuideFirstLandscape",@"ipadGuideSecondLandscape",@"ipadGuideThirdLandscape",@"", nil];
        for (int i = 0; i < [self.imageArray count]; i++) {
            
            UIImageView *item = [self.imageArray objectAtIndex:i];
            item.image = [UIImage imageNamed:[self.array objectAtIndex:i]];
            
        }
        
    }
    [self performSelector:@selector(layoutScrollView) withObject:nil afterDelay:0.1];
}

- (void)layoutScrollView {
    
    
    [self.scrollview setContentOffset:CGPointMake(self.pageControl.currentPage*self.view.bounds.size.width, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
