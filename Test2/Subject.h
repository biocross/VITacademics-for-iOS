//
//  Subject.h
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject

@property (nonatomic) NSInteger subjectNumber;
@property (copy, nonatomic) NSString *subjectTitle;
@property (copy, nonatomic) NSString *subjectCode;
@property (copy, nonatomic) NSString *subjectSlot;
@property (nonatomic) NSInteger conductedClasses;
@property (nonatomic) NSInteger attendedClasses;
@property (copy, nonatomic) NSString *subjectType;
@property (nonatomic) NSArray *subjectDetails;
@property (nonatomic) NSString *classNumber;

-(id)initWithSubject:(NSString *)subjectCode title:(NSString *)subjectTitle slot:(NSString *)subjectSlot attended:(NSInteger)attendedClasses conducted:(NSInteger)conductedClasses number:(NSInteger)subjectNumber type:(NSString *)subjectType details:(NSArray *)subjectDetails classNumber:(NSString *)classNumber;



@end
