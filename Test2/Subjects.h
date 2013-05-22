//
//  Subjects.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subjects : NSObject

@property (copy, nonatomic) NSArray *privateListOfSubjects;
@property (nonatomic) NSInteger subjectNumber;
@property (copy, nonatomic) NSString *subjectTitle;

//after
@property (copy, nonatomic) NSString *subjectCode;
@property (copy, nonatomic) NSString *subjectSlot;
@property (nonatomic) NSInteger conductedClasses;
@property (nonatomic) NSInteger attendedClasses;
@property (copy, nonatomic) NSString *subjectType;

-(NSUInteger)count;
-(Subjects *)objectAtIndexedSubscript:(NSInteger)subjectNumber;
@end
