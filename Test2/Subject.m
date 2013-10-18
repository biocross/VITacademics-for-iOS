//
//  Subject.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "Subject.h"

@implementation Subject

-(id)initWithSubject:(NSString *)subjectCode title:(NSString *)subjectTitle slot:(NSString *)subjectSlot attended:(NSInteger)attendedClasses conducted:(NSInteger)conductedClasses number:(NSInteger)subjectNumber type:(NSString*)subjectType details:(NSArray *)subjectDetails classNumber:(NSString *)classNumber{
    self = [super init];
    if (self){
        _subjectCode = subjectCode;
        _subjectSlot = subjectSlot;
        _subjectTitle = subjectTitle;
        _attendedClasses = attendedClasses;
        _conductedClasses = conductedClasses;
        _subjectNumber = subjectNumber;
        _subjectType = subjectType;
        _subjectDetails = subjectDetails;
        _classNumber = classNumber;
    }
    return self;

}

-(id)init{
    return [self initWithSubject:@"SAM101" title:@"Sample Subject" slot:@"S1+TS1" attended:15 conducted:18 number:1 type:@"No Type" details:@[@"Date", @"Status"] classNumber:@"0000"];
}


@end
