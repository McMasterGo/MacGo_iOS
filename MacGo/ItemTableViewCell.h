//
//  ItemTableViewCell.h
//  MacGo
//
//  Created by David Elsonbaty on 2015-01-22.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
