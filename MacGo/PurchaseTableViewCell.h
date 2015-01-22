//
//  PurchaseTableViewCell.h
//  MacGo
//
//  Created by David Elsonbaty on 2015-01-22.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *purchaseDate;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;

@end
