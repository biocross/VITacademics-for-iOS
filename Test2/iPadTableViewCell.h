//
//  iPadTableViewCell.h
//  VITacademics
//
//  Created by Siddharth Gupta on 23/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subjects.h"
#import "Subject.h"

@interface iPadTableViewCell : UITableViewCell

@property (strong, nonatomic) Subjects *subject;
@property (strong, nonatomic) NSArray *subjectMarks;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;


- (void)recalculateAttendance;

@property (strong) IBOutlet UILabel *subjectCode;
@property (strong) IBOutlet UILabel *subjectName;
@property (strong) IBOutlet UILabel *subjectPercentage;
@property (strong) IBOutlet UILabel *subjectType;
@property (strong) IBOutlet UILabel *subjectSlot;
@property (strong) IBOutlet UILabel *subjectAttended;
@property (strong) IBOutlet UILabel *subjectConducted;
@property (strong) IBOutlet UIProgressView *progressBar;

- (IBAction)missPlus:(id)sender;
- (IBAction)missMinus:(id)sender;
- (IBAction)attendPlus:(id)sender;
- (IBAction)attendMinus:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *missLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendLabel;

- (IBAction)subjectDetailsButton:(id)sender;
- (IBAction)marksButton:(id)sender;

- (void)configureView;

@end
