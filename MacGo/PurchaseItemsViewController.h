//
//  PurchaseItemsViewController.h
//  MacGo
//
//  Created by David Elsonbaty on 2015-01-22.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PurchaseItemsViewController : UIViewController
@property (weak, nonatomic) PFObject *purchaseItem;
@end
