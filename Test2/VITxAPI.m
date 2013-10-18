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

-(NSString *)loadMarksWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *) dateOfBirth{
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/marks/%@/%@", registrationNumber, dateOfBirth];
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
    
    NSLog(@"%@", text);
    return text;
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

/* Sample Marks String
 
 [[["1", "1630", "ECE101", "Electron Devices and Circuits", "Embedded Theory", "Present", "39.00", "", "", "Present", "4.50", "", "", "", "", "", "", "N/A"], ["2", "4630", "ECE101", "Electron Devices and Circuits", "Embedded Lab", "N/A", "", ""], ["3", "1631", "ECE201", "Probability Theory and Random Process", "Theory Only", "Present", "44.00", "", "", "Present", "3.50", "", "", "", "", "", "", "N/A"], ["4", "1638", "ECE202", "Transmission Lines and Fields", "Theory Only", "Present", "16.50", "", "", "Present", "3.50", "", "", "", "", "", "", "N/A"], ["5", "1419", "ECE303", "Digital Signal Processing", "Embedded Theory", "Present", "19.50", "", "", "", "", "", "", "", "", "", "", "N/A"], ["6", "4473", "ECE303", "Digital Signal Processing", "Embedded Lab", "N/A", "", ""], ["7", "4691", "ECE305", "Digital Communication", "Embedded Lab", "N/A", "", ""], ["8", "2393", "MAT201", "Complex Variables and Partial Differential Equations", "Theory Only", "Present", "19.00", "", "", "Present", "2.00", "", "", "", "", "", "", "N/A"]], []]
 
 */

@end
