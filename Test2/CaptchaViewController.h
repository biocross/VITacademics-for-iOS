//
//  CaptchaViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "CSNotificationView.h"




@interface CaptchaViewController : UIViewController 

- (IBAction)cancelrefresh:(id)sender;
- (IBAction)verifyCaptcha:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImage;
@property (weak, nonatomic) IBOutlet UITextField *captchaText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressDot;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property CSNotificationView *notificationController;

@property (weak, nonatomic) IBOutlet UIButton *reloadButtonOutlet;
- (IBAction)reloadButtonAction:(id)sender;

@end
