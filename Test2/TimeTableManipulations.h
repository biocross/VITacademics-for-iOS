//
//  TimeTableManipulations.h
//  Test2
//
//  Created by Vibhor Varshney on 09/08/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTable.h"

@interface TimeTableManipulations : NSObject


@property NSMutableArray *timeTheory;
@property NSMutableArray *timeLab;
@property NSInteger day;
@property TimeTable *tt;

-(void)setDayFromString:(NSString *)DayS;
-(NSArray *)findClassTimefromDay:(NSString *)day andClassNumber:(NSString*)classNumber;
-(NSInteger)checkIfUserIsFreeFromDay:(NSString *)day andTime:(NSString *)Time;

@end
