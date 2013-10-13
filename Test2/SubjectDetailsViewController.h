//
//  SubjectDetailsViewController.h
//  Test2
//
//  Created by Siddharth Gupta on 12/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectDetailsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *detailsArray;
@property (strong) NSMutableArray *days;
@property (strong) NSMutableArray *statuses;

@end
