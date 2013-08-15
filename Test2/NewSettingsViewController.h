//
//  NewSettingsViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/20/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSettingsViewController : UIViewController <UITextFieldDelegate>
- (IBAction)cancelButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *registrationNumber;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirth;

- (IBAction)setDOBfromPicker:(id)sender;

-(BOOL)textFieldShouldBeginEditing:(UITextField *)dateOfBirth;


@end
