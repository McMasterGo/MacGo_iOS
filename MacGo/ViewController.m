//
//  ViewController.m
//  MacGo
//
//  Created by David Elsonbaty on 11/16/14.
//  Copyright (c) 2014 David Elsonbaty. All rights reserved.
//

#define kSecondsTimers 20

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "AccountHistoryViewController.h"

@interface ViewController () <PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *makePurchaseButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *accountHistoryButton;

@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;

@property (strong, nonatomic) NSTimer *closePurchaseTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[PFUser logOut];
    
    self.containerView.layer.borderWidth = 2;
    self.containerView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.refreshButton.layer.borderWidth = 2;
    self.refreshButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.accountHistoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.1 blue:0.11 alpha:1];
    
    
    //Set current balance label, then update and set again
    NSNumber *balance = [PFUser currentUser][@"balance"];
    self.currentBalanceLabel.text = [NSString stringWithFormat:@"$%.2f", [balance floatValue]];
    [self didTapRefresh:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{

    if (![PFUser currentUser]) {
        [self showLoginView];
    }else{
        [self populateUserInformation];
    }
    
}

- (void)showLoginView{
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.delegate = self;
    logInViewController.logInView.backgroundColor = [UIColor whiteColor];
    [logInViewController.logInView.signUpButton removeFromSuperview];
    [logInViewController.logInView.signUpButton removeFromSuperview];
    [logInViewController.logInView.dismissButton removeFromSuperview];
    [logInViewController.logInView.passwordForgottenButton removeFromSuperview];
    [logInViewController.logInView.logInButton removeFromSuperview];
    
    logInViewController.logInView.backgroundColor = [UIColor blackColor];
    logInViewController.logInView.usernameField.backgroundColor = [UIColor clearColor];
    logInViewController.logInView.passwordField.backgroundColor = [UIColor clearColor];
    logInViewController.logInView.usernameField.textAlignment = NSTextAlignmentCenter;
    logInViewController.logInView.passwordField.textAlignment = NSTextAlignmentCenter;
    logInViewController.logInView.usernameField.textColor = [UIColor whiteColor];
    logInViewController.logInView.passwordField.textColor = [UIColor whiteColor];
    
    UILabel *logo = [[UILabel alloc] initWithFrame:logInViewController.logInView.logo.frame];
    logo.text = @"MacGo";
    logo.font = [self.titleLabel.font fontWithSize:45];
    logo.textAlignment = NSTextAlignmentCenter;
    logo.textColor = [UIColor colorWithRed:0.82 green:0.76 blue:0.49 alpha:1];
    logInViewController.logInView.logo = logo;
    [self presentViewController:logInViewController animated:YES completion:nil];
    
}

- (void)populateUserInformation{
    PFUser *user = [PFUser currentUser];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
}

#pragma mark - IBActions implementations
- (IBAction)didTapRefresh:(id)sender {

    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object,    NSError *error) {
        
        NSNumber *balance = [PFUser currentUser][@"balance"];
        self.currentBalanceLabel.text = [NSString stringWithFormat:@"$%.2f", [balance floatValue]];
        
    }];
    
}
- (IBAction)didTapCancel:(id)sender{
    
    if ([self.refreshButton.titleLabel.text isEqualToString:@"Cancel"]) {
        
        self.containerView.backgroundColor = [UIColor clearColor];
        self.qrCodeImageView.image = nil;
        self.qrCodeImageView.hidden = YES;
        self.makePurchaseButton.hidden = NO;
        self.containerView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.makePurchaseButton.userInteractionEnabled = YES;
        
        [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
        [self.refreshButton removeTarget:self action:@selector(didTapCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.refreshButton addTarget:self action:@selector(didTapRefresh:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [_closePurchaseTimer invalidate];
    _closePurchaseTimer = nil;
    
}

- (IBAction)didTapAccountHistory:(id)sender {
    
    AccountHistoryViewController *accountHistoryVC = [[AccountHistoryViewController alloc] initWithNibName:@"AccountHistoryViewController" bundle:nil];
    UINavigationController *navigationBar = [[UINavigationController alloc] initWithRootViewController:accountHistoryVC];
    navigationBar.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navigationBar animated:YES completion:nil];
    
}

#pragma mark - QRCode Helpers
- (IBAction)makePurchaseButtonClicked:(id)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    
    //Set 'Refresh' Button to 'Cancel'
    [self.refreshButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.refreshButton removeTarget:self action:@selector(didTapRefresh:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshButton addTarget:self action:@selector(didTapCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = (UIButton*)sender;
    button.userInteractionEnabled = NO;
    
    PFObject *token = [PFObject objectWithClassName:@"Tokens"];
    token[@"user"] = [PFUser currentUser];
    token[@"active"] = @YES;
    token[@"expiry"] = [NSDate dateWithTimeIntervalSinceNow:kSecondsTimers];
    [token saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (succeeded){
         
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
                UIImage *qrcode = [self generateQRCodeWithString:[token objectId] scale:200];

                dispatch_async(dispatch_get_main_queue(), ^{

                    self.containerView.backgroundColor = [UIColor whiteColor];
                    self.qrCodeImageView.image = qrcode;
                    self.qrCodeImageView.hidden = NO;
                    self.makePurchaseButton.hidden = YES;
                    self.containerView.layer.borderColor = [[UIColor colorWithRed:0.45 green:0.75 blue:0.49 alpha:1] CGColor];
                    
                    _closePurchaseTimer = [NSTimer scheduledTimerWithTimeInterval:kSecondsTimers
                                                                           target:self
                                                                         selector:@selector(didTapCancel:)
                                                                         userInfo:nil
                                                                          repeats:NO];
                });
                
                
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSecondsTimers * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [self didTapCancel:nil];
//                    
//                });
//                
            });
            
        }
        
    }];
    
}
- (UIImage *) generateQRCodeWithString:(NSString *)string scale:(CGFloat) scale{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding ];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // Render the image into a CoreGraphics image
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:[filter outputImage] fromRect:[[filter outputImage] extent]];
    
    //Scale the image usign CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake([[filter outputImage] extent].size.width * scale, [filter outputImage].extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up .
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    // Rotate the image
    UIImage *qrImage = [UIImage imageWithCGImage:[preImage CGImage]
                                           scale:[preImage scale]
                                     orientation:UIImageOrientationDownMirrored];
    return qrImage;
}

#pragma mark - PFLogInViewControllerDelegate implementation
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self populateUserInformation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
