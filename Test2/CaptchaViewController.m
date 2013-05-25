//
//  CaptchaViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "CaptchaViewController.h"
#import "VITxAPI.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"

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

- (BOOL)textFieldShouldReturn:(UITextField *)registrationNumber {
    if (_captchaText == self.captchaText) {
        [_captchaText resignFirstResponder];
    }
    return YES;
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
    
    [_captchaText resignFirstResponder];
    
    VITxAPI *handler = [[VITxAPI alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    //show progress
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Verifying";
    HUD.detailsLabelText = @"captcha";
    [HUD showUsingAnimation:YES];
    
    //verify captcha in the background
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler verifyCaptchaWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth andCaptcha:_captchaText.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUsingAnimation:YES];
            if([result rangeOfString:@"timedout"].location != NSNotFound){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please check your Captcha and/or Details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([result rangeOfString:@"captchaerror"].location != NSNotFound){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please check your Captcha and/or Details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                NSLog(@"We're In!");
                NSString *notificationName = @"captchaDidVerify";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    });//end of GCD
    
    
    
    
}
@end
