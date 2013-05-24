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
                                
                                [[Subject alloc] initWithSubject:@"ECE101" title:@"Please click" slot:@"S2+TS2" attended:18 conducted:20 number:1 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN201" title:@"the refresh button" slot:@"S2+TS2" attended:18 conducted:20 number:2 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN301" title:@"on the top right" slot:@"S2+TS2" attended:18 conducted:20 number:3 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN401" title:@"to begin" slot:@"S2+TS2" attended:18 conducted:20 number:4 type:@"Sample"]
                                   
                                   ]; 
        
    }
            return _privateListOfSubjects;
}

-(NSUInteger)count{
    return [self.privateListOfSubjects count];
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
