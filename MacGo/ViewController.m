//
//  ViewController.m
//  MacGo
//
//  Created by David Elsonbaty on 11/16/14.
//  Copyright (c) 2014 David Elsonbaty. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ViewController () <PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *makePurchaseButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [PFUser logOut];
    
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
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
    
    UILabel *logo = [[UILabel alloc] initWithFrame:logInViewController.logInView.logo.frame];
    logo.text = @"MacGo";
    logo.font = [self.titleLabel.font fontWithSize:45];
    logInViewController.logInView.logo = logo;
    [self presentViewController:logInViewController animated:YES completion:nil];
    
}

- (void)populateUserInformation{
    PFUser *user = [PFUser currentUser];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
}

#pragma mark - QRCode Helpers
- (IBAction)makePurchaseButtonClicked:(id)sender {
    
    PFObject *token = [PFObject objectWithClassName:@"Tokens"];
    token[@"user"] = [PFUser currentUser];
    token[@"active"] = @YES;
    token[@"expiry"] = [NSDate dateWithTimeIntervalSinceNow:60*2];
    [token saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (succeeded){
         
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
                UIImage *qrcode = [self generateQRCodeWithString:[token objectId] scale:200];

                
                dispatch_async(dispatch_get_main_queue(), ^{

                    self.qrCodeImageView.image = qrcode;
                    self.qrCodeImageView.hidden = NO;
                    self.makePurchaseButton.hidden = YES;
                    self.containerView.layer.borderColor = [[UIColor greenColor] CGColor];
                    
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    self.qrCodeImageView.image = nil;
                    self.qrCodeImageView.hidden = YES;
                    self.makePurchaseButton.hidden = NO;
                    self.containerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                    
                });
                
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
