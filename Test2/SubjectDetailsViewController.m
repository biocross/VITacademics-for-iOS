//
//  SubjectDetailsViewController.m
//  Test2
//
//  Created by Siddharth Gupta on 12/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "SubjectDetailsViewController.h"

@interface SubjectDetailsViewController (){
}

@end

@implementation SubjectDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DetailCell"];
    
    int totalLength = [_detailsArray count];
    
    _days = [[NSMutableArray alloc] init];
    _statuses = [[NSMutableArray alloc] init];
    
    for(int i=0 ; i < totalLength ; i++){
        if(i%2){
            [_statuses addObject: [_detailsArray objectAtIndex:i]];
        }
        else{
            [_days addObject:[_detailsArray objectAtIndex:i]];

        }
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                               style:UIBarButtonSystemItemDone
                                                                             target:self   action:@selector(dismissView)];
    self.navigationItem.title = @"Attendance Details";
    [self.tableView setAllowsSelection:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dismissView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    
    int daysCount = [_days count] - 1;
    int statusesCount = [_statuses count] - 1;
    
    cell.detailTextLabel.text = [_days objectAtIndex:daysCount - indexPath.row];
    cell.textLabel.text = [_statuses objectAtIndex:statusesCount - indexPath.row];
    
    if([[_statuses objectAtIndex: statusesCount - indexPath.row] isEqualToString:@"Absent"]){
        [cell.textLabel setTextColor:[UIColor redColor]];
    }
    
   
    
    return cell;
}


@end
