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
#import "CSNotificationView.h"
#import "SVProgressHUD.h"

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
    _captchaText.returnKeyType = UIReturnKeyGo;
    //[self.reloadButtonOutlet setAlpha:0];
    [self startLoadingCaptcha];
    
}

-(void)startLoadingCaptcha{
    [_progressDot startAnimating];
    VITxAPI *handler = [[VITxAPI alloc] init];
    dispatch_queue_t downloadQueue = dispatch_queue_create("captcha", nil);
    dispatch_async(downloadQueue, ^{
        UIImage *img = [handler loadCaptchaIntoImageView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_captchaImage setImage:img];
            [_progressDot stopAnimating];
            [_progressLabel setAlpha:0];
            [_progressDot setAlpha:0];
            [_captchaText becomeFirstResponder];
        });
    });//end of GCD
}


- (BOOL)textFieldShouldReturn:(UITextField *)captchaText {
    
    if (_captchaText == self.captchaText) {
        [_captchaText resignFirstResponder];
        
        if([_captchaText.text length] == 6){
            [self beginCaptchaVerification];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter exactly 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            [_captchaImage becomeFirstResponder];
        }
        
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelrefresh:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginCaptchaVerification{
    
    VITxAPI *handler = [[VITxAPI alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    //show progress
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
        self.notificationController = [CSNotificationView notificationViewWithParentViewController:self tintColor:[UIColor orangeColor] image:nil message:@"Submitting Captcha..."];
        [self.notificationController setShowingActivity:YES];
        [self.notificationController setVisible:YES animated:YES completion:nil];
    }
    
    else{
        [SVProgressHUD showWithStatus:@"Submitting Captcha..."];
    }
    
    
    
    //verify captcha in the background
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler verifyCaptchaWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth andCaptcha:_captchaText.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
                [self.notificationController setVisible:NO animated:YES completion:nil];
            }
            else{
                [SVProgressHUD dismiss];
            }
            
            
            if([result rangeOfString:@"timedout"].location != NSNotFound){

                NSString *notificationName = @"captchaError";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result rangeOfString:@"captchaerror"].location != NSNotFound){
                NSString *notificationName = @"captchaError";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                NSLog(@"We're In!");
                NSString *notificationName = @"captchaDidVerify";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
            else if([result isEqualToString:@"networkerror"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networkError" object:nil userInfo:nil];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    });//end of GCD
}

- (IBAction)verifyCaptcha:(id)sender {
    if (_captchaText == self.captchaText) {
        [_captchaText resignFirstResponder];
        
        if([_captchaText.text length] == 6){
            [self beginCaptchaVerification];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter exactly 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [_captchaImage becomeFirstResponder];
        }
        
    }
}
- (IBAction)reloadButtonAction:(id)sender {
    [self startLoadingCaptcha];
}
@end
