//
//  MasterViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptchaViewController.h"
#import "Subjects.h"
#import "RNFrostedSidebar.h"
#import "CSNotificationView.h"



@class DetailViewController;



@interface MasterViewController : UITableViewController <UIAlertViewDelegate, RNFrostedSidebarDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)startLoadingAttendance:(id)sender;
- (void)completedProcess;
- (void)processMarks;
- (IBAction)openMenu:(id)sender;

@property NSString *attendanceCacheString;
@property NSString *marksCacheString;
@property CSNotificationView *notificationController;


@property (nonatomic, strong) Subjects *theorySubjects;
@property (nonatomic, strong) Subjects *labSubjects;
@property (nonatomic, strong) NSMutableIndexSet *menuOptionIndices;
@property (nonatomic) RNFrostedSidebar *menuPointer;

@end
