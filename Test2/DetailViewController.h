//
//  DetailViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "Subjects.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Subjects *subject;

- (void) setDetailItem:(id)newDetailItem;
- (void) recalculateAttendance;

@property (weak, nonatomic) IBOutlet UILabel *subjectCode;
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *subjectPercentage;
@property (weak, nonatomic) IBOutlet UILabel *subjectType;
@property (weak, nonatomic) IBOutlet UILabel *subjectSlot;
@property (weak, nonatomic) IBOutlet UILabel *subjectAttended;
@property (weak, nonatomic) IBOutlet UILabel *subjectConducted;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)missPlus:(id)sender;
- (IBAction)missMinus:(id)sender;
- (IBAction)attendPlus:(id)sender;
- (IBAction)attendMinus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *missLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;


@end
