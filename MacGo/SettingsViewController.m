//
//  SettingsViewController.m
//  MacGo
//
//  Created by David Elsonbaty on 2015-04-11.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface SettingsViewController ()



@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(didTapClose:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                     NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:21]} forState:UIControlStateNormal];
}
- (IBAction)didTapClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)logout:(id)sender {

    if (self.delegate) {
        [self.delegate logout];
    }
    

}
- (IBAction)changePasscode:(id)sender {
}

- (IBAction)turnPasscodeOn:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
