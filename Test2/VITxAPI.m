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
    
    NSString *buildingUrl = @"http://vitacademicsrel.appspot.com/attj/";
    buildingUrl = [buildingUrl stringByAppendingString:registrationNumber];
    buildingUrl = [buildingUrl stringByAppendingString:@"/"];
    buildingUrl = [buildingUrl stringByAppendingString:dateOfBirth];
    
    NSURL * url= [NSURL URLWithString:buildingUrl];
    NSError* error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    //NSData* text = [NSData dataWithContentsOfURL:url];
    if( text )
    {
        return text;
    }
    else
    {
        NSLog(@"Error = %@", error);
        return @"Error";
    }
}


-(void)loadCaptchaIntoImageView: (UIImageView *)imageView{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *registrationNumber = [preferences stringForKey:@"registrationNumber"];
    //get the image
    id path =@"http://vitacademicsrel.appspot.com/captcha/";
    NSString *finalURL = [path stringByAppendingString:registrationNumber];
    NSURL * url= [NSURL URLWithString:finalURL];
    dispatch_queue_t downloadQueue = dispatch_queue_create("attendanceLoader", nil);
    dispatch_async(downloadQueue, ^{
            NSData * data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * img = [[UIImage alloc] initWithData:data];
            [imageView setImage:img];
        });
        
    });//end of GCD
    
    

}

-(NSString *)verifyCaptchaWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth andCaptcha:(NSString *)captcha{
    NSString *url = @"http://vitacademicsrel.appspot.com/captchasub/";
    url = [url stringByAppendingString:registrationNumber];
    url = [url stringByAppendingString:@"/"];
    url = [url stringByAppendingString:dateOfBirth];
    url = [url stringByAppendingString:@"/"];
    url = [url stringByAppendingString:captcha];
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    return result;
    
    
}

@end
