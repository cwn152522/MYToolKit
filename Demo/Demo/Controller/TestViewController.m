//
//  TestViewController.m
//  Demo
//
//  Created by cwn on 2018/11/28.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "TestViewController.h"
#import "MYToolKit-umbrella.h"
#import "Demo-Swift.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    //oc调用pod第三方库 #import "MYToolKit-umbrella.h"
    [view cwn_makeConstraints:^(UIView *maker) {
        maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    //oc调用项目的swift #import "Demo-Swift.h"
    ViewController *vc =[[ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    // Do any additional setup after loading the view from its nib.
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
