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
#import "TDBadgedCell.h"
#import "SJNotificationViewController.h"
#import "NSDate+TimeAgo.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *MTheorySubjects;
    NSMutableArray *MLabSubjects;
    
    
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    
    //Load Attendance from cache
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if([preferences stringForKey:@"registrationNumber"]){
        if([preferences stringForKey:[preferences stringForKey:@"registrationNumber"]]){
            NSLog(@"Loading attendance from cache! Yay!");
            self.attendanceCacheString = [preferences stringForKey:[preferences stringForKey:@"registrationNumber"]];
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
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Welcome to VITacademics!"
                                                          message:@"Let's begin by entering your credentials"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Okay", nil];
        
        [message show];
        
        
    }
    
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Observers:
    NSString *notificationForCaptcha = @"captchaDidVerify";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startLoadingAttendance:)
     name:notificationForCaptcha
     object:nil];
    
    NSString *notificationForSettings = @"settingsDidChange";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(beginLoadingAttendance)
     name:notificationForSettings
     object:nil];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int subjectsLength = [_subjects count] - 1;
    
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
    
    NSLog(@"Found %d theories, and %d labs", [MTheorySubjects count], [MLabSubjects count]);
    
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
    
    NSLog(@"numberOfRowsInSection: Theory: %d, Lab: %d", [self.theorySubjects count], [self.labSubjects count]);
    
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
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    
    
    if(indexPath.section == 0){
        cell.textLabel.text = [NSString stringWithString:self.theorySubjects[indexPath.row].subjectTitle];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", self.theorySubjects[indexPath.row].subjectType, self.theorySubjects[indexPath.row].subjectSlot];
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        
        cell.badgeColor = [UIColor clearColor];
        cell.badge.radius = 8;
        cell.badge.fontSize = 12;
        
        float calculatedPercentage =(float) self.theorySubjects[indexPath.row].attendedClasses / self.theorySubjects[indexPath.row].conductedClasses;
        float displayPercentageInteger = calculatedPercentage * 100;
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.badgeString = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            cell.badgeTextColor = [UIColor redColor];
        }
        else if (displayPercentageInteger > 75 && displayPercentageInteger < 80){
            cell.badgeTextColor = [UIColor orangeColor];
        }
        else{
            cell.badgeTextColor = [UIColor greenColor];
        }
    }
    else{
        cell.textLabel.text = [NSString stringWithString:self.labSubjects[indexPath.row].subjectTitle];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", self.labSubjects[indexPath.row].subjectType, self.labSubjects[indexPath.row].subjectSlot];
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];

        cell.badgeColor = [UIColor clearColor];
        cell.badge.radius = 8;
        cell.badge.fontSize = 12;
        
        float calculatedPercentage =(float) self.labSubjects[indexPath.row].attendedClasses / self.labSubjects[indexPath.row].conductedClasses;
        float displayPercentageInteger = calculatedPercentage * 100;
        NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
        cell.badgeString = [displayPercentage stringByAppendingString:@"%"];
        
        if(displayPercentageInteger < 75){
            cell.badgeTextColor = [UIColor redColor];
        }
        else if (displayPercentageInteger > 75 && displayPercentageInteger < 80){
            cell.badgeTextColor = [UIColor orangeColor];
        }
        else{
            cell.badgeTextColor = [UIColor greenColor];
    }
}//end of sections clause
    
    
    
        
    
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Handled by Storyboards for iPhone
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.detailViewController setDetailItem:self.subjects[indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = [segue destinationViewController];
        
        
        if(selectedRowIndex.section == 0){
            detailViewController.subject = self.theorySubjects[selectedRowIndex.row];
        }
        else{
            detailViewController.subject = self.labSubjects[selectedRowIndex.row];
        }
    }
}

- (IBAction)openSettings:(id)sender {
    //handled by Storyboards
}


#pragma mark - VITx API Calls

- (void)startLoadingAttendance:(id)sender {
    
    SJNotificationViewController *notificationController = [[SJNotificationViewController alloc] initWithNibName:@"SJNotificationViewController" bundle:nil];
    [notificationController setParentView:self.view];
    [notificationController setNotificationTitle:@"Loading Attendance..."];
    [notificationController setNotificationLevel:SJNotificationLevelMessage];
    [notificationController setShowSpinner:YES];
    [notificationController setNotificationPosition:SJNotificationPositionTop];
    [notificationController show];
    
    //getting the regno, dob from preferences.
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences stringForKey:@"registrationNumber"];
    NSString *dateOfBirth = [preferences stringForKey:@"dateOfBirth"];
    
    
    VITxAPI *attendanceManager = [[VITxAPI alloc] init];
    
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
         NSString *result = [attendanceManager loadAttendanceWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        dispatch_async(dispatch_get_main_queue(), ^{
           //update table here!
            //[alert dismissWithClickedButtonIndex:0 animated:YES];
            [notificationController hide];
            self.attendanceCacheString = result;
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
            [preferences removeObjectForKey:[preferences objectForKey:@"registrationNumber"]];
            [preferences setObject:result forKey:[preferences objectForKey:@"registrationNumber"]];
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
        }
     else {
         NSMutableArray *refreshedArray = [[NSMutableArray alloc] init];
         for(NSDictionary *item in jsonArray) {
             
             Subject *x = [[Subject alloc] initWithSubject:[item valueForKey:@"code"] title:[item valueForKey:@"title"] slot:[item valueForKey:@"slot"] attended:[[item valueForKey:@"attended"] integerValue] conducted:[[item valueForKey:@"conducted"] integerValue] number:[[item valueForKey:@"sl_no"] integerValue] type:[item valueForKey:@"type"] details:[item valueForKey:@"details"]];
             
             [refreshedArray addObject:x];
             
        } //end of for
         [self.subjects setArray:refreshedArray];
         [self.tableView reloadData];
         
         
         NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
         if([preferences objectForKey:@"lastUpdated"]){
             NSDate *lastUpdated = [preferences objectForKey:@"lastUpdated"];
             
             SJNotificationViewController *notificationController = [[SJNotificationViewController alloc] initWithNibName:@"SJNotificationViewController" bundle:nil];
             [notificationController setParentView:self.view];
             [notificationController setNotificationTitle:[@"Last Updated: " stringByAppendingString:[lastUpdated timeAgo]]];
             [notificationController setNotificationLevel:SJNotificationLevelMessage];
             [notificationController setNotificationPosition:SJNotificationPositionTop];
             [notificationController showFor:2];
         }
     } //end of else
    

}

@end









