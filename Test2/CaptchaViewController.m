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
#import "SJNotificationViewController.h"

@interface CaptchaViewController ()

@end

@implementation CaptchaViewController

-(void)hudWasHidden{
    //protocol conformation
}

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
	// load the captcha here
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
            [self verifyCaptcha:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter the complete captcha! (6 characters)" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
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

- (IBAction)verifyCaptcha:(id)sender {
    
    [_captchaText resignFirstResponder];
    
    VITxAPI *handler = [[VITxAPI alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences objectForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences objectForKey:@"dateOfBirth"];
    
    //show progress
    SJNotificationViewController *notificationController = [[SJNotificationViewController alloc] initWithNibName:@"SJNotificationViewController" bundle:nil];
    [notificationController setParentView:self.view];
    [notificationController setNotificationTitle:@"Submitting Captcha..."];
    [notificationController setNotificationLevel:SJNotificationLevelMessage];
    [notificationController setShowSpinner:YES];
    [notificationController setNotificationPosition:SJNotificationPositionBottom];
    [notificationController show];
    
    
    //verify captcha in the background
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
        NSString *result = [handler verifyCaptchaWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth andCaptcha:_captchaText.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [notificationController hide];
            if([result rangeOfString:@"timedout"].location != NSNotFound){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please check your Captcha and/or Details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([result rangeOfString:@"captchaerror"].location != NSNotFound){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please check your captcha and/or details" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([result rangeOfString:@"success"].location != NSNotFound){
                NSLog(@"We're In!");
                NSString *notificationName = @"captchaDidVerify";
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
            }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];

        });
    });//end of GCD
    
    
    
    
}
@end
