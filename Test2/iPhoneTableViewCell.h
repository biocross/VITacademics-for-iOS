//
//  iPhoneTableViewCell.h
//  VITacademics
//
//  Created by Siddharth Gupta on 04/11/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeAndSlot;
@property (weak, nonatomic) IBOutlet UILabel *percentage;

@end
