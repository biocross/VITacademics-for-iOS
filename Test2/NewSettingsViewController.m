//
//  NewSettingsViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/20/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "NewSettingsViewController.h"

@interface NewSettingsViewController ()

@end

@implementation NewSettingsViewController

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
    NSDate *now = [NSDate date];
	[_datePicker setDate:now animated:YES];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    //set the currently saved values.
    if([preferences stringForKey:@"registrationNumber"]){
        [_registrationNumber setText:[preferences stringForKey:@"registrationNumber"]] ;
        [_dateOfBirth setText:[preferences stringForKey:@"dateOfBirth"]] ;
    }
    
	if([preferences stringForKey:@"dateOfBirth"]){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"ddMMYYYY"];;
        NSDate *anyDate = [dateFormat dateFromString:[preferences stringForKey:@"dateOfBirth"]];
        [_datePicker setDate:anyDate];
    }
    
        
        
    //set the date from NSUserPreferences here.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {

    //EDIT HERE FOR IPHONE AND IPAD IMPORTANT
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButton:(id)sender {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences removeObjectForKey:@"registrationNumber"];
    [preferences removeObjectForKey:@"dateOfBirth"];
    [preferences setObject:_registrationNumber.text forKey:@"registrationNumber"];
    [preferences setObject:_dateOfBirth.text forKey:@"dateOfBirth"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setDOBfromPicker:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMYYYY"];
    NSString *str = [dateFormatter stringFromDate:[_datePicker date]];
	_dateOfBirth.text = str;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)registrationNumber {
    if (_registrationNumber == self.registrationNumber) {
        [_registrationNumber resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)dateOfBirth{
    [_dateOfBirth resignFirstResponder];
    return YES;
}




@end
