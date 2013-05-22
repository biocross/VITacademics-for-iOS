//
//  CaptchaViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "CaptchaViewController.h"
#import "VITxAPI.h"

@interface CaptchaViewController ()

@end

@implementation CaptchaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// load the captcha here
    VITxAPI *handler = [[VITxAPI alloc] init];
    [handler loadCaptchaIntoImageView:_captchaImage];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelrefresh:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)verifyCaptcha:(id)sender {
    VITxAPI *handler = [[VITxAPI alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    //show progress
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Verifying Captcha...\n" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    //verify captcha in the background
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler verifyCaptchaWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth andCaptcha:_captchaText.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            if([result rangeOfString:@"timedout"].location != NSNotFound){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Sorry, Wrong Captcha" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                //go ahead and load attendnace;
                NSLog(@"We're In!");
            }
            
            
        });
    });//end of GCD
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
