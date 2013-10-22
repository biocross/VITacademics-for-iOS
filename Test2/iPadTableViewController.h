//
//  iPadTableViewController.h
//  VITacademics
//
//  Created by Siddharth Gupta on 22/10/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface iPadTableViewController : UITableViewController <RNFrostedSidebarDelegate>
- (IBAction)openMenu:(id)sender;

@property (nonatomic, strong) NSMutableIndexSet *menuOptionIndices;
@property (nonatomic) RNFrostedSidebar *menuPointer;
@end
