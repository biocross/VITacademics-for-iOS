//
//  MarksViewController.m
//  VITacademics
//
//  Created by Siddharth Gupta on 19/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "MarksViewController.h"

@interface MarksViewController ()

@end

@implementation MarksViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MarksCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonSystemItemDone
                                                                             target:self   action:@selector(dismissView)];
    self.navigationItem.title = @"Marks";
    [self.tableView setAllowsSelection:NO];
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
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = @"Others";
    
    if(section == 0)
        returnString = @"CAT";
    if(section == 1)
        returnString = @"Quiz";
    if(section == 2)
        returnString = @"Assignment";
    if(section == 3)
        returnString = @"Total Internals";
    
    return returnString;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noOfRows = 0;
    
    if(section == 0)
        noOfRows = 2;
    if(section == 1)
        noOfRows = 3;
    if(section == 2)
        noOfRows = 1;
    if(section == 3)
        noOfRows = 1;
    
    return noOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MarksCell"];

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"CAT I";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 50", self.marksArray[6]];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"CAT II";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 50", self.marksArray[8]];
        }
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Quiz I";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[10]];
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"Quiz II";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[12]];
        }
        if(indexPath.row == 2){
            cell.textLabel.text = @"Quiz II";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[14]];
        }
    }
    
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Assignment";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / 5", self.marksArray[16]];
        }
    }
    
    float cat1Marks = [self.marksArray[6]  isEqual: @""] ? 0 : [self.marksArray[6] floatValue];
    cat1Marks = (cat1Marks/50)*15;
    float cat2Marks = [self.marksArray[8]  isEqual: @""] ? 0 : [self.marksArray[8] floatValue];
    cat2Marks = (cat2Marks/50)*15;
    float quiz1Marks = [self.marksArray[10]  isEqual: @""] ? 0 : [self.marksArray[10] floatValue];
    float quiz2Marks = [self.marksArray[12]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float quiz3Marks = [self.marksArray[14]  isEqual: @""] ? 0 : [self.marksArray[12] floatValue];
    float assignmentMarks = [self.marksArray[16]  isEqual: @""] ? 0 : [self.marksArray[16] floatValue];

    float totalInternals = cat1Marks + cat2Marks + quiz1Marks + quiz2Marks + quiz3Marks + assignmentMarks;
    
    if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Total Internal Marks";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.0f / 50", totalInternals];
        }
    }
    
    
    return cell;
}

@end
