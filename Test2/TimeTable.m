//
//  TimeTable.m
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TimeTable.h"

@interface TimeTable () {
}

@end

@implementation TimeTable

-(id)initWithTTString: (NSString *)TimeTableString{
    
    [self initArrays];
    
    NSError *e = nil;
    NSString *newString = [TimeTableString stringByReplacingOccurrencesOfString:@"valid%" withString:@""];
    NSData *ttDataFromString = [newString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else{
        NSLog(@"TimeTable Parsed!");
        for(NSDictionary *item in jsonArray){
            [self parseSubjectAndAddToTT: item];
        }
    }
    
    return self;
}

- (void) initArrays{
    _monday = [[NSMutableArray alloc] init];
    _tuesday = [[NSMutableArray alloc] init];
    _wednesday = [[NSMutableArray alloc] init];
    _thursday = [[NSMutableArray alloc] init];
    _friday = [[NSMutableArray alloc] init];
    
    for (int i=0; i<12; i++){
        NSString *temp = [NSString stringWithFormat:@"%d", i];
        [_monday addObject:temp];
        [_tuesday addObject:temp];
        [_wednesday addObject:temp];
        [_thursday addObject:temp];
        [_friday addObject:temp];
    }
    
}

- (void) printArrays{
    [_monday replaceObjectAtIndex:0 withObject:@"yay"];
    NSLog(@"Here's monday \n %@", [_monday description]);
}




-(void)parseSubjectAndAddToTT:(NSDictionary *)subject{
    NSString *slot = [subject objectForKey:@"slot"];
    BOOL hasTutorial = NO;
    BOOL isLab = NO;
    
    if([slot rangeOfString:@"L"].location != NSNotFound){
        isLab = YES;
    }
    
    if(!isLab){
        //Subject is not a lab, proceeding with theory parsing:
        
        if([slot length] > 2){
            hasTutorial = YES;
        }
        
        NSLog(@"Thoery Slot: %@", slot);
        int skippyBoy = 0;
        
        if([slot rangeOfString:@"A"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            
            
            if(hasTutorial){
                [_tuesday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"B"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            
            
            if(hasTutorial){
                [_tuesday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"C"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            
            
            if(hasTutorial){
                [_friday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"D"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            
            
            if(hasTutorial){
                [_monday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"E"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+3 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+0 withObject:subject];
            
            
            if(hasTutorial){
                [_thursday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"F"].location != NSNotFound){
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_monday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_wednesday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_thursday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            
            
            if(hasTutorial){
                [_tuesday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
        if([slot rangeOfString:@"G"].location != NSNotFound){
            
            if([slot rangeOfString:@"1"].location != NSNotFound){
                skippyBoy = 0;
            }
            if([slot rangeOfString:@"2"].location != NSNotFound){
                skippyBoy = 5;
            }
            
            [_tuesday replaceObjectAtIndex:skippyBoy+1 withObject:subject];
            [_friday replaceObjectAtIndex:skippyBoy+2 withObject:subject];
            
            
            if(hasTutorial){
                [_wednesday replaceObjectAtIndex:skippyBoy+4 withObject:subject];
            }
        }
        
    }
    
    
    
}




-(id) initWithSample{
    
    
    TimeTable *temp = [[TimeTable alloc] initWithTTString:@"shitt"];
    return temp;
}


@end
