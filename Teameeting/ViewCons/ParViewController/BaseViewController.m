//
//  BaseViewController.m
//  Room
//
//  Created by zjq on 15/11/19.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.navigationController) {
        if (self.navigationController.navigationBarHidden) {
            self.height = self.view.bounds.size.height;
        }else{
             self.height = self.view.bounds.size.height-64;
        }
    }else{
        self.height = self.view.bounds.size.height;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
