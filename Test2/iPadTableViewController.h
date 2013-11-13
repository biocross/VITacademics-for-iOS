//
//  iPadTableViewController.h
//  VITacademics
//
//  Created by Siddharth Gupta on 22/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "Subjects.h"
#import "iPadTableViewCell.h"

@interface iPadTableViewController : UITableViewController <RNFrostedSidebarDelegate>
- (IBAction)openMenu:(id)sender;

@property (strong, nonatomic) iPadTableViewCell *cell;


- (void)startLoadingAttendance:(id)sender;
- (void)completedProcess;
- (void)processMarks;

@property NSString *attendanceCacheString;
@property NSString *marksCacheString;

@property (nonatomic, strong) Subjects *subjects;


@property (nonatomic, strong) Subjects *theorySubjects;
@property (nonatomic, strong) Subjects *labSubjects;

@property (nonatomic, strong) NSMutableIndexSet *menuOptionIndices;
@property (nonatomic) RNFrostedSidebar *menuPointer;
@end
