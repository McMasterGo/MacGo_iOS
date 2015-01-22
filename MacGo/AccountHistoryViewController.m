//
//  AccountHistoryViewController.m
//  MacGo
//
//  Created by David Elsonbaty on 2015-01-22.
//  Copyright (c) 2015 David Elsonbaty. All rights reserved.
//

#import "AccountHistoryViewController.h"
#import "PurchaseTableViewCell.h"
#import <Parse/Parse.h>

@interface AccountHistoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *purchasesArray;
@end

@implementation AccountHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"History";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(didTapClose:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PurchaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"PurchaseTableViewCell"];

    PFQuery *query = [PFQuery queryWithClassName:@"Purchase"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.purchasesArray = objects;
        [self.tableView reloadData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (IBAction)didTapClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDatasource Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.purchasesArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIColor *mainColor = indexPath.row%2? [UIColor whiteColor] : [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    
    cell.storeName.textColor = mainColor;
    cell.totalCost.textColor = mainColor;
    cell.purchaseDate.textColor = mainColor;
    
    PFObject* purchase = _purchasesArray[indexPath.row];
    cell.storeName.text = purchase[@"Description"];

    NSNumber *balance = purchase[@"totalCost"];
    cell.totalCost.text = [NSString stringWithFormat:@"$%.2f", [balance floatValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    cell.purchaseDate.text = [formatter stringFromDate:purchase.createdAt];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate Implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
