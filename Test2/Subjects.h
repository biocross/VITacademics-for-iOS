//
//  Subjects.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subjects : NSObject

@property (nonatomic, copy) NSMutableArray *privateListOfSubjects;
@property (nonatomic) NSInteger subjectNumber;
@property (copy, nonatomic) NSString *subjectTitle;

//after
@property (copy, nonatomic) NSString *subjectCode;
@property (copy, nonatomic) NSString *subjectSlot;
@property (nonatomic) NSInteger conductedClasses;
@property (nonatomic) NSInteger attendedClasses;
@property (copy, nonatomic) NSString *subjectType;
@property (nonatomic) NSArray *subjectDetails;
@property (nonatomic) NSString *classNumber;

-(NSUInteger)count;
-(Subjects *)objectAtIndexedSubscript:(NSUInteger)subjectNumber;
- (void)setArray:(NSArray *)newArray;
- (NSString *)percentage;
@end
