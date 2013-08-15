//
//  TimeTableManipulations.m
//  Test2
//
//  Created by Vibhor Varshney on 09/08/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TimeTableManipulations.h"

@implementation TimeTableManipulations

-(id)init{
    if (self = [super init])
    {
        int a=8;
		for(int i=0;i<12;i++)
		{
            NSString *aInStringFormat = [NSString stringWithFormat:@"%d", a];
            
            _timeTheory[0][i] = [@"0" stringByAppendingString:aInStringFormat];
            _timeTheory[0][i] = [_timeTheory[0][i] stringByAppendingString:@":00:00"];
            
            _timeTheory[1][i] = [@"0" stringByAppendingString:aInStringFormat];
            _timeTheory[1][i] = [_timeTheory[1][i] stringByAppendingString:@":50:00"];
            
            _timeLab[0][i] = [@"0" stringByAppendingString:aInStringFormat];
            _timeLab[0][i] = [_timeLab[0][i] stringByAppendingString:@":00:00"];
            
            _timeLab[1][i] = [@"0" stringByAppendingString:aInStringFormat];
            _timeLab[1][i] = [_timeLab[1][i] stringByAppendingString:@":50:00"];
            
            a++;
            
            if(i==5||i==11)
            {
                _timeTheory[0][i]=@"00:00:00";
                _timeTheory[1][i]=@"00:00:00";
                
                
                _timeLab[0][i] = [NSString stringWithFormat:@"%d" , i+7];
                _timeLab[0][i] = [_timeLab[0][i] stringByAppendingString:@":40:00"];
                
                _timeLab[0][i] = [NSString stringWithFormat:@"%d" , i+8];
                _timeLab[0][i] = [_timeLab[0][i] stringByAppendingString:@":30:00"];
                
            }
		}
    }
    return self;
}

-(void)setDayFromString:(NSString *)DayS{
    
    NSString *Day = [DayS lowercaseString];
    if([Day isEqualToString:@"monday"]){
        self.day=0;
    }
    else if([Day isEqualToString:@"tuesday"]){
        self.day=1;
    }
    else if([Day isEqualToString:@"wednesday"]){
        self.day=2;
    }
    else if([Day isEqualToString:@"thursday"]){
        self.day=3;
    }
    else if([Day isEqualToString:@"friday"]){
        self.day=4;
    }
    else{
        self.day=-1;
    }
}


-(NSArray *)findClassTimefromDay:(NSString *)day andClassNumber:(NSString*)classNumber{
    [self setDayFromString:day];
    NSArray *result[2];
    int start=-1,end=-1;
    
    for(int i=0;i<12;i++)
    {
        if( [self.tt getTTi:day andi:i]==classNumber&&start==-1)
            start=i;
    }
    for(int i=start;i<12;i++)
    {
        if([self.tt getTTi:day andi:i]!=classNumber)
        {
            end=i-1;
            break;
        }
    }
    if(start!=end)
    {
        result[0]=_timeLab[0][start];
        result[1]=_timeLab[1][end];
    }
    else
    {
        result[0]=_timeTheory[0][start];
        result[1]=_timeTheory[1][start];
    }
    return *result;
}

-(NSInteger)checkIfUserIsFreeFromDay:(NSString *)day andTime:(NSString *)Time{
    
    //Too much java bullsh*t
        
}





@end
