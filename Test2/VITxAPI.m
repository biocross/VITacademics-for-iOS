//
//  VITxAPI.m
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "VITxAPI.h"


@implementation VITxAPI

-(NSString *)loadAttendanceWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth{
    
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/attj/%@/%@", registrationNumber, dateOfBirth];
    NSURL *url = [NSURL URLWithString:buildingUrl];
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    if(text)
    {
        return text;
    }
    else
    {
        NSLog(@"Error = %@", error);
        return @"networkerror";
    }
}


-(UIImage *)loadCaptchaIntoImageView{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences stringForKey:@"registrationNumber"];
    //get the image
    id path =@"http://vitacademicsrel.appspot.com/captcha/";
    NSString *finalURL = [path stringByAppendingString:registrationNumber];
    NSURL * url= [NSURL URLWithString:finalURL];
    
    NSError *error = nil;
    NSData * data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    if (error){
        NSLog(@"Failed to load the captcha.");
        UIImage *img = [UIImage imageNamed:@"captchaError"];
        return img;
    }
    else{
        UIImage * img = [[UIImage alloc] initWithData:data];
        return img;
    }

}

-(NSString *)verifyCaptchaWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth andCaptcha:(NSString *)captcha{
    
    NSString *url = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/captchasub/%@/%@/%@", registrationNumber, dateOfBirth, captcha];
    
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    
    if(error){
        return @"networkerror";
    }
    
    return result;
    
    
}

@end
