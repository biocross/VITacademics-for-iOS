//
//  iPhoneTableViewCell.m
//  VITacademics
//
//  Created by Siddharth Gupta on 04/11/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "iPhoneTableViewCell.h"

@implementation iPhoneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
