//
//  DetailViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "DetailViewController.h"
#import "SubjectDetailsViewController.h"
#import "Subject.h"

@interface DetailViewController ()



@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    
        _subject = newDetailItem;
        
        // Update the view.
        [self configureView];
    
    

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    
    if (self.subject) {
        self.subjectCode.text = _subject.subjectCode;
        self.title = @"";
        self.subjectName.text = _subject.subjectTitle;
        self.subjectSlot.text = _subject.subjectSlot;
        self.subjectType.text = _subject.subjectType;
        self.subjectAttended.text = [NSString stringWithFormat:@"%d",_subject.attendedClasses];
        self.subjectConducted.text = [NSString stringWithFormat:@"%d",_subject.conductedClasses];
        
        [self recalculateAttendance];
    }
    
}

- (void)recalculateAttendance{
    float calculatedPercentage =(float) [self.subjectAttended.text intValue] / [self.subjectConducted.text intValue];
    float displayPercentageInteger = calculatedPercentage * 100;
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
    self.subjectPercentage.text = [displayPercentage stringByAppendingString:@"%"];
    [self.progressBar setProgress:calculatedPercentage animated:YES];
    
    if(displayPercentageInteger >= 80){
        [self.subjectPercentage setTextColor:[UIColor greenColor]];
        [self.progressBar setProgressTintColor:[UIColor greenColor]];
    }
    else if(displayPercentageInteger >= 75 && displayPercentageInteger < 80){
        [self.subjectPercentage setTextColor:[UIColor orangeColor]];
        [self.progressBar setProgressTintColor:[UIColor orangeColor]];
    }
    else{
        [self.subjectPercentage setTextColor:[UIColor redColor]];
        [self.progressBar setProgressTintColor:[UIColor redColor]];
    }
    
    int length = [_subject.subjectDetails count];
    if([[_subject.subjectDetails lastObject] isEqualToString:@"Absent"]){
        [self.lastUpdatedLabel setTextColor:[UIColor redColor]];
    }
    else{
        [self.lastUpdatedLabel setTextColor:[UIColor colorWithRed:0.05 green:0.52 blue:0.99 alpha:1]];
    }
    self.lastUpdatedLabel.text = [_subject.subjectDetails objectAtIndex:length - 2];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Subjects", @"Subjects");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Attendance Manipulations

- (IBAction)missPlus:(id)sender {
    int missPlusLabel = [_missLabel.text intValue] + 1;
    [_missLabel setText:[NSString stringWithFormat:@"%d", missPlusLabel]];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
    
    int numberOfSlots = 1;
    if(numberOfMatches){
        numberOfSlots = numberOfMatches;
    }

    
    int currentSubjectConducted = [self.subjectConducted.text intValue];
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots ]];
    [self recalculateAttendance];
    
}

- (IBAction)missMinus:(id)sender {
    int missPlusLabel = [_missLabel.text intValue];
    if(missPlusLabel > 0){
        [_missLabel setText:[NSString stringWithFormat:@"%d", missPlusLabel - 1 ]];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
        
        int numberOfSlots = 1;
        if(numberOfMatches){
            numberOfSlots = numberOfMatches;
        }
        
        int currentSubjectConducted = [self.subjectConducted.text intValue];
        [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted - numberOfSlots ]];
        [self recalculateAttendance];
    }
}

- (IBAction)attendPlus:(id)sender {
    int attendPlusLabel = [_attendLabel.text intValue];
    [_attendLabel setText:[NSString stringWithFormat:@"%d", attendPlusLabel + 1 ]];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
    
    int numberOfSlots = 1;
    if(numberOfMatches){
        numberOfSlots = numberOfMatches;
    }
    
    int currentSubjectAttended = [self.subjectAttended.text intValue];
    [self.subjectAttended setText:[NSString stringWithFormat:@"%d", currentSubjectAttended + numberOfSlots]];
    
    int currentSubjectConducted = [self.subjectConducted.text intValue];
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots ]];
    
    [self recalculateAttendance];
    
}

- (IBAction)attendMinus:(id)sender {
    int attendPlusLabel = [_attendLabel.text intValue];
    if(attendPlusLabel > 0){
        [_attendLabel setText:[NSString stringWithFormat:@"%d", attendPlusLabel - 1 ]];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"L" options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.subjectSlot.text options:0 range:NSMakeRange(0, [self.subjectSlot.text length])];
        
        int numberOfSlots = 1;
        if(numberOfMatches){
            numberOfSlots = numberOfMatches;
        }
        
        int currentSubjectAttended = [self.subjectAttended.text intValue];
        [self.subjectAttended setText:[NSString stringWithFormat:@"%d", currentSubjectAttended - numberOfSlots]];
        
        int currentSubjectConducted = [self.subjectConducted.text intValue];
        [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted - numberOfSlots]];
        
        [self recalculateAttendance];
    }
}

- (IBAction)subjectDetailsButton:(id)sender {
    SubjectDetailsViewController *forThisSubject = [[SubjectDetailsViewController alloc] init];
    NSLog(@"Sending Array with %d elements", [_subject.subjectDetails count]);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:forThisSubject];
    [self presentViewController:nav animated:YES completion:nil];
    [forThisSubject setDetailsArray:_subject.subjectDetails];

    
}

@end
