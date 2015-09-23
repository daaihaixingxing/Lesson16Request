//
//  MainTabBarController.m
//  Lesson16Request
//
//  Created by lanouhn on 15/9/23.
//  Copyright (c) 2015年 大爱海星星. All rights reserved.
//

#import "MainTabBarController.h"
#import "GetViewController.h"
#import "PostViewController.h"
#import "imageViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GetViewController *getVC = [[GetViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *getNavi = [[UINavigationController alloc] initWithRootViewController:getVC];
    getVC.tabBarItem.title = @"GET";
    getVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover@2x"];
    getVC.navigationItem.title = @"GET";
    
    
    PostViewController *postVC = [[PostViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *postNavi = [[UINavigationController alloc] initWithRootViewController:postVC];
    postVC.tabBarItem.title = @"POST";
    postVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_mainframe@2x"];
    postVC.navigationItem.title = @"POST";
    
    imageViewController *imageVC = [[imageViewController alloc] init];
    UINavigationController *imageNavi = [[UINavigationController alloc] initWithRootViewController:imageVC];
    imageVC.tabBarItem.title = @"图片";
    imageVC.navigationItem.title = @"图片";
    imageVC.tabBarItem.image = [UIImage imageNamed:@"qr_toolbar_more_hl@2x"];
    
    self.viewControllers = @[getNavi,postNavi,imageNavi];
    
    [getVC release];
    [getNavi release];
    [postVC release];
    [postNavi release];
    [imageVC release];
    [imageNavi release];
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
