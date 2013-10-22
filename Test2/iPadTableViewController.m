//
//  iPadTableViewController.m
//  VITacademics
//
//  Created by Siddharth Gupta on 22/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "iPadTableViewController.h"
#import "RNFrostedSidebar.h"

@interface iPadTableViewController ()

@end

@implementation iPadTableViewController

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iPadCell"];
    self.tableView.allowsSelection = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iPadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}



- (IBAction)openMenu:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"home"],
                        [UIImage imageNamed:@"settings"],
                        [UIImage imageNamed:@"beta_access"],
                        [UIImage imageNamed:@"share"],
                        [UIImage imageNamed:@"help"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.menuOptionIndices borderColors:colors];
    callout.delegate = self;
    callout.tintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.30 alpha:0.73];
    [callout show];
    
    self.menuPointer = callout;
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    if (index == 0) { //Home Button
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HomeNav"];
        [sidebar dismissAnimated:YES];
        double delayInSeconds = 0.25f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self presentViewController:vc animated:NO completion:nil];
        });
    }
    if(index == 1){ //Settings
        [sidebar dismissAnimated:YES];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsViewNav"];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    if(index == 2){ //Beta Access
        [sidebar dismissAnimated:YES];
        UIAlertView *betaAcess = [[UIAlertView alloc] initWithTitle:@"Early Access" message:@"Would you like to join our Google+ group, and get early access to testing builds of VITacademics and provide feedback to help us develop features into VITacademics faster?" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Oh Yeah!", nil];
        [betaAcess show];
    }
    if(index == 3){ //Share with friends
        NSString *message = @"https://itunes.apple.com/us/app/vine/id592447445?mt=8";
        //UIImage *imageToShare = [UIImage imageNamed:@"test.jpg"];
        NSArray *postItems = @[message]; //add image here if you want
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:postItems
                                                applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    if(index == 4){ //Helpshift
        [sidebar dismissAnimated:YES];
        //[[Helpshift sharedInstance] showSupport:self];
    }
    if(index == 5){ //About
        
    }
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.menuOptionIndices removeAllIndexes];
        [self.menuOptionIndices addIndex:index];
    }
    else {
        [self.menuOptionIndices removeIndex:index];
    }
}
@end
