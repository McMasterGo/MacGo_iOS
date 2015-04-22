//
//  SettingsViewController.h
//  MacGo
//
//  Created by David Elsonbaty on 2015-04-11.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsProtocol <NSObject>

- (void)logout;

@end

@interface SettingsViewController : UIViewController

@property (assign, nonatomic) id <SettingsProtocol> delegate;

@end
