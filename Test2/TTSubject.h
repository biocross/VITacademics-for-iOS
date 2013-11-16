//
//  TTSubject.h
//  VITacademics
//
//  Created by Sids on 11/15/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSubject : NSObject

@property NSString *slot;
@property NSString *code;
@property NSString *ltpc;
@property NSString *type;
@property NSString *title;
@property NSString *venue;
@property NSString *classNumber;
@property NSString *status;
@property NSString *faculty;

-(id)initWithSubject:(NSString *)slot code:(NSString *)code ltpc:(NSString *)ltpc type:(NSString *)type title:(NSString *)title venue:(NSString *)venue classNumber:(NSString *)classNumber status:(NSString *)status faculty:(NSString *)faculty;

@end
