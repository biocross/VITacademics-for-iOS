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
#import "MBProgressHUD.h"
#import "TDBadgedCell.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@property (strong, nonatomic) Subjects *subjects;
@end

@implementation MasterViewController

//core data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

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
	// Do any additional setup after loading the view, typically from a nib.
    
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
    cell.textLabel.text = [NSString stringWithString:self.subjects[indexPath.row].subjectCode];
    cell.detailTextLabel.text = [NSString stringWithString:self.subjects[indexPath.row].subjectTitle];
        
    cell.badgeColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
    cell.badge.radius = 8;
    cell.badge.fontSize = 12;

    float calculatedPercentage =(float) self.subjects[indexPath.row].attendedClasses / self.subjects[indexPath.row].conductedClasses;
    float displayPercentageInteger = calculatedPercentage * 100;
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
    cell.badgeString = [displayPercentage stringByAppendingString:@"%"];
    
        
    }
    else{
        cell.textLabel.text = @"VITacademics";
        cell.detailTextLabel.text = @"Siddharth Gupta";
    }
    
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

- (void)startLoadingAttendance:(id)sender {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"Downloading Attendance";
    [HUD showUsingAnimation:YES];
    
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
            [HUD hideUsingAnimation:YES];
            self.attendanceCacheString = result;
            [self competedProcess];
        });
        
    });//end of GCD    
        
}

-(void)competedProcess{

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
             
             Subject *x = [[Subject alloc] initWithSubject:[item valueForKey:@"code"] title:[item valueForKey:@"title"] slot:[item valueForKey:@"slot"] attended:[[item valueForKey:@"attended"] integerValue] conducted:[[item valueForKey:@"conducted"] integerValue] number:[[item valueForKey:@"sl_no"] integerValue] type:[item valueForKey:@"type"]];
             
             [refreshedArray addObject:x];
             
             /*
             NSManagedObjectContext *context = [self managedObjectContext];
             NSManagedObject *subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:context];
             [subject setValue:[item valueForKey:@"code"] forKey:@"code"];
             [subject setValue:[item valueForKey:@"title"] forKey:@"title"];
             [subject setValue:[item valueForKey:@"slot"] forKey:@"slot"];
             [subject setValue:[item valueForKey:@"attended"] forKey:@"attendedClasses"];
             [subject setValue:[item valueForKey:@"conducted"] forKey:@"conductedClasses"];
             [subject setValue:[item valueForKey:@"sl_no"] forKey:@"number"];
             [subject setValue:[item valueForKey:@"type"] forKey:@"type"];
             
             NSError *error = nil;
             // Save the object to persistent store
             if (![context save:&error]) {
                 NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
             }
             */
        } //end of for
         NSLog(@"%d", [self.subjects.privateListOfSubjects count]);
         NSLog(@"ref array cintains %d", refreshedArray.count);
         [self.subjects setArray:refreshedArray];
         [self.tableView reloadData];
     } //end of else
    

}

@end









