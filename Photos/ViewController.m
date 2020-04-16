//
//  ViewController.m
//  Photos
//
//  Created by qiyu on 2020/4/16.
//  Copyright © 2020 com.qiyu. All rights reserved.
//

#import "ViewController.h"
#import "AllAssetsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIViewController *VC = [[UIViewController alloc] init];
//    VC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
//    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:VC]];
    
    AllAssetsViewController *allAssetsVC = [[AllAssetsViewController alloc] init];
    allAssetsVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:2];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:allAssetsVC]];
    
    
}


@end
