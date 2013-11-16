//
//  TTSubject.m
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TTSubject.h"

@implementation TTSubject

-(id)initWithSubject:(NSString *)slot code:(NSString *)code ltpc:(NSString *)ltpc type:(NSString *)type title:(NSString *)title venue:(NSString *)venue classNumber:(NSString *)classNumber status:(NSString *)status faculty:(NSString *)faculty{
    
    self = [super init];
    if (self){
        _slot = slot;
        _code = code;
        _ltpc = ltpc;
        _type = type;
        _title = title;
        _venue = venue;
        _classNumber = classNumber;
        _status = status;
        _faculty = faculty;
    }
    
    return self;
}

@end
