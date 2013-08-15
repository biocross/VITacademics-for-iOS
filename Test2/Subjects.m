//
//  Subjects.m
//  Test2
//
//  Created by Siddharth Gupta on 5/7/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "Subjects.h"
#import "Subject.h"



@implementation Subjects

- (NSMutableArray *)privateListOfSubjects {
    if(!_privateListOfSubjects){
       _privateListOfSubjects = @[
                                
                                [[Subject alloc] initWithSubject:@"" title:@"Please click the refresh button to begin!" slot:@"-" attended:0 conducted:0 number:1 type:@"-"],
 

                                   
                                   ]; 
        
    }
            return _privateListOfSubjects;
}

-(NSUInteger)count{
    return [self.privateListOfSubjects count];
}

-(NSString *)percentage{
    
    float calculatedPercentage =(float) self.attendedClasses /self.conductedClasses;
    float displayPercentageInteger = calculatedPercentage * 100;
    NSString *displayPercentage = [NSString stringWithFormat:@"%1.0f",displayPercentageInteger];
    
    return displayPercentage;
}

-(Subjects *)objectAtIndexedSubscript:(NSInteger)subjectNumber{
    return self.privateListOfSubjects[subjectNumber] ;
}

- (void)setArray:(NSArray *)newArray {
    
    if ( _privateListOfSubjects != newArray ) {
       // [_privateListOfSubjects release];
        NSLog(@"Before: %d", _privateListOfSubjects.count);
        _privateListOfSubjects = nil;
        _privateListOfSubjects = [newArray mutableCopy];
        NSLog(@"After: %d", _privateListOfSubjects.count);

        //      [array retain]; // unnecessary as noted by Georg Fritzsche
    }
    
    return;
}


@end
