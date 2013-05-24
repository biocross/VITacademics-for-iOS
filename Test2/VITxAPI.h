//
//  VITxAPI.h
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VITxAPI : NSObject{
}

-(NSString *)loadAttendanceWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *) dateOfBirth;
-(void)loadCaptchaIntoImageView: (UIImageView *)imageView;
-(NSString *)verifyCaptchaWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth andCaptcha:(NSString *)captcha;

@end


