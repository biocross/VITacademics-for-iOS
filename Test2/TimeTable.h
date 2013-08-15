//
//  TimeTable.h
//  Test2
//
//  Created By Kishore Narendran in Java
//  Ported by Siddharth Gupta on 09/08/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTable : NSObject

-(void)addSlotWithIdentifier:(NSString*)slot andClassNumber:(NSString*)classNumber;
-(void)printTimeTable;
-(NSString *)getTTi:(NSInteger)day andi:(NSInteger)i;

@property NSArray *tt;

@end
