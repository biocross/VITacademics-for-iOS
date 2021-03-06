//
//  MasterViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "MasterViewController.h"
#import "Subjects.h"
#import "Subject.h"
#import "DetailViewController.h"
#import "VITxAPI.h"
#import "CaptchaViewController.h"
#import "iPhoneTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "RNFrostedSidebar.h"
#import "Helpshift.h"
#import "CSNotificationView.h"
#import "SVProgressHUD.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *MTheorySubjects;
    NSMutableArray *MLabSubjects;
    NSArray *marksArray;
    
    
}
@property (strong, nonatomic) Subjects *subjects;
@end

@implementation MasterViewController


-(Subjects *)subjects {
    if(! _subjects){
        _subjects = [[Subjects alloc] init];
    }
return _subjects;
}




- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didMoveToParentViewController:(UITableViewController *)parent
{
    // parent is nil if this view controller was removed
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
       // #import "CSNotificationView.h"

    }
    else{
        //#import "SVProgressHUD.h"
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshAttendance:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [self.tableView registerClass:[iPhoneTableViewCell class] forCellReuseIdentifier:@"iPhoneCell"];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Home View (Table)"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu:)] ;
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureR];
    
    
    
    //Load Attendance from cache
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences stringForKey:@"registrationNumber"]){
        if([preferences stringForKey:[preferences stringForKey:@"registrationNumber"]]){
            //NSLog(@"Loading attendance from cache! Yay!");
            self.attendanceCacheString = [preferences stringForKey:[preferences stringForKey:@"registrationNumber"]];
            NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
            self.marksCacheString = [preferences objectForKey:marksKey];
            [self completedProcess];
        }
        else{
            NSLog(@"Attendance is not cached currently for this user");
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Data Here"
                                                              message:@"It time to load/refresh your attendance!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Refresh", nil];
            
            [message show];
        }
    }
    else{
        //Show tutorial or open Settings View Controller
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
                [CSNotificationView showInViewController:self tintColor:[UIColor redColor] image:[UIImage imageNamed:@"CSNotificationView_checkmarkIcon"] message:@"Welcome to VITacademics!" duration:2.5f];
            }
            
            else{
                [SVProgressHUD showSuccessWithStatus:@"Welcome to VITacademics!"];
            }

            
            
            
            
            dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.05f * NSEC_PER_SEC));
            dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                [self openMenu:self];
                dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC));
                dispatch_after(popTime3, dispatch_get_main_queue(), ^(void){
                    [self.menuPointer dismissAnimated:YES];
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Welcome to VITacademics!"
                                                                      message:@"Let's begin by entering your credentials"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                            otherButtonTitles:@"Okay", nil];
                    [message show];
                });
            });
        });
    }//end of else

    
#pragma mark - Observers
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startLoadingAttendance:)
     name:@"captchaDidVerify"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(beginLoadingAttendance)
     name:@"settingsDidChange"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showCaptchaError)
     name:@"captchaError"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showNetworkError)
     name:@"networkError"
     object:nil];
    
}


-(void)refreshAttendance:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CaptchaViewNav"];
    [self presentViewController:vc animated:YES completion:NULL];
    [(UIRefreshControl *)sender endRefreshing];
    
}

-(void)showCaptchaError{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Incorrect captcha/credentials"];
        }
        
        else{
            [SVProgressHUD showErrorWithStatus:@"Incorrect captcha/credentials!"];
        }
        
    });
    
    
}

-(void)showNetworkError{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Network Error, Please check your internet connectivity."];
        }
        
        else{
            [SVProgressHUD showErrorWithStatus:@"Network Error, Please check your internet connectivity."];
        }
    });
}

-(void)beginLoadingAttendance{
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Credential Change Detected"
                                                      message:@"Looks like you changed your details. Let's refresh your attendance to reflect this."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Yup", nil];
    [message show];

}

#pragma mark - New User Handling
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Okay"])
    {
        NSLog(@"New user clicked on Okay, now opening Settings.");
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    else if([title isEqualToString:@"Refresh"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CaptchaViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    else if([title isEqualToString:@"Yup"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CaptchaViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    
    
    else if([title isEqualToString:@"Oh Yeah!"]){
        NSLog(@"Opening Google+ Group");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/u/0/communities/112543766365145422569"]];
    }
    
    else if([title isEqualToString:@"Not Now"]){
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Some other time, then :)"];
        }
        
        else{
            [SVProgressHUD showSuccessWithStatus:@"Some other time, then :)"];
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int subjectsLength = [_subjects count];
    
    //Sort the subjects:
    MTheorySubjects = [[NSMutableArray alloc] init];
    MLabSubjects = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < subjectsLength; i++){
        if ([_subjects[i].subjectType rangeOfString:@"Theory"].location != NSNotFound){
            [MTheorySubjects addObject:_subjects[i]];
        }
        else if([_subjects[i].subjectType rangeOfString:@"Lab"].location != NSNotFound){
            [MLabSubjects addObject:_subjects[i]];
        }
    }
    
    self.theorySubjects = [[Subjects alloc] init];
    self.labSubjects = [[Subjects alloc] init];
    
    [self.theorySubjects setArray:MTheorySubjects];
    [self.labSubjects setArray:MLabSubjects];

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int returnValue = 0;
    
    if(section == 0){
        returnValue = [self.theorySubjects count];
    }
    else if(section == 1){
        returnValue = [self.labSubjects count];
    }
    
    return returnValue;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = @"Others";
    
    if(section == 0)
        returnString = @"Theory";
    if(section == 1)
        returnString = @"Lab";
    
    return returnString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"iPhoneCellNib" owner:self options:nil];
    iPhoneTableViewCell *cell = [nib objectAtIndex:0];
    
    if(indexPath.section == 0){
        cell.subjectTitle.text = self.theorySubjects[indexPath.row].subjectTitle;
        cell.subjectTypeAndSlot.text = [NSString stringWithFormat:@"%@ - %@", self.theorySubjects[indexPath.row].subjectType, self.theorySubjects[indexPath.row].subjectSlot];
        [cell.subjectTypeAndSlot setTextColor:[UIColor grayColor]];
        
        float calculatedPercentage = (float) self.theorySubjects[indexPath.row].attendedClasses / self.theorySubjects[indexPath.row].conductedClasses;
        float displayPercentageInteger = ceil(calculatedPercentage * 100);
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.percentage.text = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            cell.percentage.textColor = [UIColor redColor];
        }
        else if (displayPercentageInteger > 75 && displayPercentageInteger < 80){
            cell.percentage.textColor = [UIColor orangeColor];
        }
        else{
            cell.percentage.textColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
        }
        
    }
    else{
        cell.subjectTitle.text = self.labSubjects[indexPath.row].subjectTitle;
        cell.subjectTypeAndSlot.text = [NSString stringWithFormat:@"%@ - %@", self.labSubjects[indexPath.row].subjectType, self.labSubjects[indexPath.row].subjectSlot];
        [cell.subjectTypeAndSlot setTextColor:[UIColor grayColor]];
        
        float calculatedPercentage =(float) self.labSubjects[indexPath.row].attendedClasses / self.labSubjects[indexPath.row].conductedClasses;
        float displayPercentageInteger = ceil(calculatedPercentage * 100);
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.percentage.text = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            cell.percentage.textColor = [UIColor redColor];
        }
        else if (displayPercentageInteger > 75 && displayPercentageInteger < 80){
            cell.percentage.textColor = [UIColor orangeColor];
        }
        else{
            cell.percentage.textColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
    }
}//end of sections clause
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedRowIndex = indexPath;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    DetailViewController *detailViewController = [sb instantiateViewControllerWithIdentifier:@"DetailsView"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    if(selectedRowIndex.section == 0){
        int indexOfMatchedSubject = -1;
        int i = 0;
        for(NSArray *item in marksArray){
            if([item[1] isEqualToString:self.theorySubjects[selectedRowIndex.row].classNumber]){
                indexOfMatchedSubject = i;
                break;
            }
            i += 1;
        }
        
        detailViewController.subject = self.theorySubjects[selectedRowIndex.row];
        
        if(indexOfMatchedSubject < [marksArray count] && indexOfMatchedSubject != -1){
            detailViewController.subjectMarks = marksArray[indexOfMatchedSubject];
        }
        else{
            detailViewController.subjectMarks = [[NSArray alloc] init];
        }
        [detailViewController viewDidLoad];
        
    }
    else{
        detailViewController.subject = self.labSubjects[selectedRowIndex.row];
        detailViewController.subjectMarks = [[NSArray alloc] init];
        [detailViewController viewDidLoad];
    }
}

#pragma mark - VITx API Calls

- (void)startLoadingAttendance:(id)sender {
    
    
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
        self.notificationController = [CSNotificationView notificationViewWithParentViewController:self tintColor:[UIColor orangeColor] image:nil message:@"Loading Attendance..."];
        [self.notificationController setShowingActivity:YES];
        [self.notificationController setVisible:YES animated:YES completion:nil];
    }
    
    else{
        [SVProgressHUD showWithStatus:@"Loading Attendance..."];
    }
    
    //getting the regno, dob from preferences.
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences stringForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences stringForKey:@"dateOfBirth"];
    
    VITxAPI *attendanceManager = [[VITxAPI alloc] init];
    
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
         NSString *result = [attendanceManager loadAttendanceWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        NSString *marks = [attendanceManager loadMarksWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
           //update table here!
            //[alert dismissWithClickedButtonIndex:0 animated:YES];
            if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
                [self.notificationController setVisible:NO animated:YES completion:nil];
            }
            else {
                [SVProgressHUD dismiss];
            }
            
            self.attendanceCacheString = result;
            self.marksCacheString = marks;
        
            [preferences removeObjectForKey:[preferences objectForKey:@"registrationNumber"]];
            [preferences setObject:result forKey:[preferences objectForKey:@"registrationNumber"]];
            NSString *marksKey = [NSString stringWithFormat:@"MarksOf%@", [preferences objectForKey:@"registrationNumber"]];
            [preferences removeObjectForKey:marksKey];
            [preferences setObject:marks forKey:marksKey];
            NSDate *date = [[NSDate alloc] init];
            [preferences setObject:date forKey:@"lastUpdated"];
            
            [self completedProcess];
        });
        
    });//end of GCD    
        
}

-(void)completedProcess{

    
     NSError *e = nil;
     NSString *newString = [self.attendanceCacheString stringByReplacingOccurrencesOfString:@"valid%" withString:@""];
     NSData *attendanceDataFromString = [newString dataUsingEncoding:NSUTF8StringEncoding];
     NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
     
     if (!jsonArray) {
         NSLog(@"Error parsing JSON: %@", e);
         if([newString isEqualToString:@"networkerror"]){
             UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"There was a problem connecting to the internet. Please check your Data/Wi-Fi connection and try again." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles: nil];
             [errorMessage show];
             
         }
         else if([newString isEqualToString:@"timedout"] || [newString isEqualToString:@"captchaerror"]){
             UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Something went wrong. Please try again. If this keeps on happening, please let us know via the \"Help\" section." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles: nil];
            [errorMessage show];
        }
     }//end of if
     else {
         NSMutableArray *refreshedArray = [[NSMutableArray alloc] init];
         for(NSDictionary *item in jsonArray) {
             
             Subject *x = [[Subject alloc] initWithSubject:[item valueForKey:@"code"] title:[item valueForKey:@"title"] slot:[item valueForKey:@"slot"] attended:[[item valueForKey:@"attended"] integerValue] conducted:[[item valueForKey:@"conducted"] integerValue] number:[[item valueForKey:@"sl_no"] integerValue] type:[item valueForKey:@"type"] details:[item valueForKey:@"details"] classNumber:[item valueForKey:@"classnbr"]];
             
             [refreshedArray addObject:x];
             
        } //end of for
         [self.subjects setArray:refreshedArray];
         [self.tableView reloadData];
         
         
         NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
         if([preferences objectForKey:@"lastUpdated"]){
             NSDate *lastUpdated = [preferences objectForKey:@"lastUpdated"];
             NSString *cardMessage = [@"Last Updated: " stringByAppendingString:[lastUpdated timeAgo]];
             
             //Bug Fix fix for Empty Card -> Delay
             double delayInSeconds = 0.05f;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 
                 
                 
                 if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
                     [CSNotificationView showInViewController:self tintColor:[UIColor redColor] image:[UIImage imageNamed:@"CSNotificationView_checkmarkIcon"] message:cardMessage duration:2.5f];
                 }
                 
                 else{
                     [SVProgressHUD showSuccessWithStatus:cardMessage];
                 }

                 
                 
             });
             
             
            }
         [self processMarks];
         
     } //end of else
    

}

- (void)processMarks{

    NSError *e = nil;
    NSData *attendanceDataFromString = [self.marksCacheString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: attendanceDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    marksArray = jsonArray[0];
    
}

#pragma mark - Frost Menu Methods and Protocol Implementation

-(IBAction)openMenu:(id)sender {
    
    NSArray *images = @[
                        [UIImage imageNamed:@"home"],
                        [UIImage imageNamed:@"settings"],
                        [UIImage imageNamed:@"beta_access"],
                        [UIImage imageNamed:@"share"],
                        [UIImage imageNamed:@"help"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.menuOptionIndices borderColors:colors];
    callout.delegate = self;
    callout.tintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.30 alpha:0.73];
    [callout show];

    self.menuPointer = callout;
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    if (index == 0) { //Home Button
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HomeNav"];
        [sidebar dismissAnimated:YES];
        double delayInSeconds = 0.25f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self presentViewController:vc animated:NO completion:nil];
        });
    }
    if(index == 1){ //Settings
        [sidebar dismissAnimated:YES];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    if(index == 2){ //Beta Access
        [sidebar dismissAnimated:YES];
        UIAlertView *betaAcess = [[UIAlertView alloc] initWithTitle:@"Early Access" message:@"Would you like to join our Google+ group, and get early access to testing builds of VITacademics and provide feedback to help us develop features into VITacademics faster?" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Oh Yeah!", nil];
        [betaAcess show];
    }
    if(index == 3){ //Share with friends
        NSString *message = @"https://itunes.apple.com/in/app/vitacademics/id727796987?mt=8";
        //UIImage *imageToShare = [UIImage imageNamed:@"test.jpg"];
        NSArray *postItems = @[message]; //add image here if you want
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    if(index == 4){ //Helpshift
        [sidebar dismissAnimated:YES];
        //[[Helpshift sharedInstance] showSupport:self];
        [[Helpshift sharedInstance] showFAQs:self withOptions:nil];
    }
    if(index == 5){ //About
        
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.menuOptionIndices removeAllIndexes];
        [self.menuOptionIndices addIndex:index];
    }
    else {
        [self.menuOptionIndices removeIndex:index];
    }
}

@end
