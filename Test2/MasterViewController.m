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
        }
    }
    else{
        //Show tutorial or open Settings View Controller
    }
    
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSString *notificationName = @"captchaDidVerify";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startLoadingAttendance:)
     name:notificationName
     object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.subjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell" forIndexPath:indexPath];
    
    if(indexPath.row < [self.subjects count]){
    cell.textLabel.text = [NSString stringWithString:self.subjects[indexPath.row].subjectTitle];
    cell.detailTextLabel.text = [NSString stringWithString:self.subjects[indexPath.row].subjectType];
    
    cell.badgeColor = [UIColor clearColor];
    cell.badge.radius = 8;
    cell.badge.fontSize = 12;
        
    float calculatedPercentage =(float) self.subjects[indexPath.row].attendedClasses / self.subjects[indexPath.row].conductedClasses;
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
    /*
    else{
        cell.textLabel.text = @"VITacademics";
        cell.detailTextLabel.text = @"Siddharth Gupta";
    }*/
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
        detailViewController.subject = self.subjects[selectedRowIndex.row];
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









