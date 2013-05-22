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

- (NSArray *)privateListOfSubjects {
    if(!_privateListOfSubjects){
        _privateListOfSubjects = @[
                                   
                                [[Subject alloc] initWithSubject:@"ECE101" title:@"Digital Logic Design" slot:@"S2+TS2" attended:18 conducted:20 number:1 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN201" title:@"Signals and Systems" slot:@"S2+TS2" attended:18 conducted:20 number:2 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN301" title:@"Electromagnetics" slot:@"S2+TS2" attended:18 conducted:20 number:3 type:@"Sample"],
                                [[Subject alloc] initWithSubject:@"GEN401" title:@"Transmission Lines" slot:@"S2+TS2" attended:18 conducted:20 number:4 type:@"Sample"]
                                   
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


@end
