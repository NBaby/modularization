//
//  ViewController.m
//  NMModularizationDemo
//
//  Created by 糯米 on 2018/5/20.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "ViewController.h"
#import "HSVideoLinkClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)jumpToVideController:(id)sender {
    UIViewController * controller = [[HSVideoLinkClass shareObject] getVideoController];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"视频分类模块未加载" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
