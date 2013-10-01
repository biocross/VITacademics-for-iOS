//
//  MasterViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptchaViewController.h"



@class DetailViewController;



@interface MasterViewController : UITableViewController 



@property (strong, nonatomic) DetailViewController *detailViewController;

- (IBAction)openSettings:(id)sender;
- (void)startLoadingAttendance:(id)sender;
- (void)completedProcess;

@property NSString *attendanceCacheString;




@end
