//
//  PurchaseItemsViewController.m
//  MacGo
//
//  Created by David Elsonbaty on 2015-01-22.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import "PurchaseItemsViewController.h"
#import "ItemTableViewCell.h"

@interface PurchaseItemsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *itemsArray;
@end

@implementation PurchaseItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(didTapClose:)];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemTableViewCell"];
    
}

- (IBAction)didTapClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPurchaseItem:(PFObject *)purchaseItem{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [titleLabel.font fontWithSize:21];
    titleLabel.text = purchaseItem[@"Description"];
    [view addSubview:titleLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 100, 20)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [dateLabel.font fontWithSize:14];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    dateLabel.text = [formatter stringFromDate:purchaseItem.createdAt];
    [view addSubview:dateLabel];
    
    self.navigationItem.titleView = view;
    
    PFQuery *query = [PFQuery queryWithClassName:@"PurchaseItem"];
    [query whereKey:@"purchase" equalTo:purchaseItem];
    [query orderByAscending:@"quantity"];
    [query includeKey:@"item"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.itemsArray = objects;
        [self.tableView reloadData];
    }];
    
}

#pragma mark - UITableViewDataSource Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIColor *mainColor = indexPath.row%2? [UIColor whiteColor] : [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    
    cell.quantityLabel.textColor = mainColor;
    cell.nameLabel.textColor = mainColor;
    
    PFObject* item = _itemsArray[indexPath.row];
    cell.nameLabel.text = item[@"item"][@"name"];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@", item[@"quantity"]];
    
    return cell;
    
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
