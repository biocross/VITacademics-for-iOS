//
//  iPadTableViewCell.m
//  VITacademics
//
//  Created by Siddharth Gupta on 23/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "iPadTableViewCell.h"
#import "SubjectDetailsViewController.h"
#import "Subject.h"
#import "CSNotificationView.h"
#import "iPadTableViewController.h"

@implementation iPadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


- (void)configureView
{
    // Update the user interface for the detail item.
    
    if(self.subject){
        self.subjectCode.text = self.subject.subjectCode;
        self.subjectName.text = self.subject.subjectTitle;
        self.subjectSlot.text = self.subject.subjectSlot;
        self.subjectType.text = self.subject.subjectType;
        self.subjectAttended.text = [NSString stringWithFormat:@"%d",_subject.attendedClasses];
        self.subjectConducted.text = [NSString stringWithFormat:@"%d",_subject.conductedClasses];
        [self recalculateAttendance];
    }
    else{
        NSLog(@"NO DATA");
    }
    
    
    
}

- (void)recalculateAttendance{
    float calculatedPercentage =(float) [self.subjectAttended.text intValue] / [self.subjectConducted.text intValue];
    float displayPercentageInteger = calculatedPercentage * 100;
    int compararingVariable = (int) displayPercentageInteger;
    if(displayPercentageInteger > compararingVariable){
        displayPercentageInteger += 1;
    }
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f", displayPercentageInteger];
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
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots]];
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
        [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted - numberOfSlots]];
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
    [self.subjectConducted setText:[NSString stringWithFormat:@"%d", currentSubjectConducted + numberOfSlots]];
    
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

- (void)subjectDetailsButton:(id)sender{
    //SubjectDetailsViewController *forThisSubject = [[SubjectDetailsViewController alloc] init];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:forThisSubject];
    //[forThisSubject setDetailsArray:_subject.subjectDetails];
    
    
}

- (void)marksButton:(id)sender{
    
}


@end
