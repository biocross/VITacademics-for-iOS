//
//  TimeTable.h
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTable : NSObject

@property NSMutableArray *subjects;

- (void)printArrays;
- (id)initWithSample;
- (id)initWithTTString:(NSString *)TimeTableString;
- (void)parseSubjectAndAddToTT:(NSDictionary *)subject;

@property (retain) NSMutableArray *monday;
@property (retain) NSMutableArray *tuesday;
@property (retain) NSMutableArray *wednesday;
@property (retain) NSMutableArray *thursday;
@property (retain) NSMutableArray *friday;


@end
