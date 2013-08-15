//
//  TimeTable.m
//  Test2
//
//  Created by Vibhor Varshney on 09/08/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "TimeTable.h"

@implementation TimeTable

-(id)init{
    if (self = [super init])
    {
        int p=1;
		for(int i=0;i<5;i++)
		{
			for(int j=0;j<6;j++)
			{
				self.tt[i][j]=[NSString stringWithFormat:@"%d", p++];
			}
		}
		for(int i=0;i<5;i++)
		{
			for(int j=6;j<12;j++)
			{
				self.tt[i][j]=[NSString stringWithFormat:@"%d", p++];
			}
		}
    }
    return self;
}

-(void)addSlotWithIdentifier:(NSString *)slot andClassNumber:(NSString *)classNumber {
    if([slot characterAtIndex:0]!='L')
    {
        char ch1=[slot characterAtIndex:0];
        int ch2=(int)[slot characterAtIndex:1]-48;
        if(ch2==1)
			ch2=0;
        else
			ch2=6;
        switch(ch1)
        {
            case 'A':
				if([slot length]<=2)
				{
					self.tt[0][0+ch2]=classNumber;
					self.tt[3][1+ch2]=classNumber;
				}
				else
				{
					self.tt[0][0+ch2]=classNumber;
					self.tt[3][1+ch2]=classNumber;
					self.tt[1][3+ch2]=classNumber;
				}
				break;
				
            case 'B':
				if([slot length]<=2)
				{
					self.tt[1][0+ch2]=classNumber;
					self.tt[4][1+ch2]=classNumber;
				}
				else
				{
					self.tt[1][0+ch2]=classNumber;
					self.tt[4][1+ch2]=classNumber;
					self.tt[2][3+ch2]=classNumber;
				}
				break;
				
            case 'C':
				if([slot length]<=2)
				{
					self.tt[0][2+ch2]=classNumber;
					self.tt[2][0+ch2]=classNumber;
					self.tt[3][3+ch2]=classNumber;
				}
				else
				{
					self.tt[0][2+ch2]=classNumber;
					self.tt[2][0+ch2]=classNumber;
					self.tt[3][3+ch2]=classNumber;
					self.tt[4][4+ch2]=classNumber;
				}
				break;
				
            case 'D':
				if([slot length]<=2)
				{
					self.tt[1][2+ch2]=classNumber;
					self.tt[3][0+ch2]=classNumber;
					self.tt[4][3+ch2]=classNumber;
				}
				else
				{
					self.tt[1][2+ch2]=classNumber;
					self.tt[3][0+ch2]=classNumber;
					self.tt[4][3+ch2]=classNumber;
					self.tt[0][4+ch2]=classNumber;
				}
				break;
				
            case 'E':
				if([slot length]<=2)
				{
					self.tt[0][3+ch2]=classNumber;
					self.tt[2][2+ch2]=classNumber;
					self.tt[4][0+ch2]=classNumber;
				}
				else
				{
					self.tt[0][3+ch2]=classNumber;
					self.tt[2][2+ch2]=classNumber;
					self.tt[4][0+ch2]=classNumber;
					self.tt[3][4+ch2]=classNumber;
				}
				break;
				
            case 'F':
				if([slot length]<=2)
				{
					self.tt[0][1+ch2]=classNumber;
					self.tt[2][1+ch2]=classNumber;
					self.tt[3][2+ch2]=classNumber;
				}
				else
				{
					self.tt[0][1+ch2]=classNumber;
					self.tt[2][1+ch2]=classNumber;
					self.tt[3][2+ch2]=classNumber;
					self.tt[1][4+ch2]=classNumber;
				}
				break;
				
            case 'G':
				if([slot length]<=2)
				{
					self.tt[1][1+ch2]=classNumber;
					self.tt[4][2+ch2]=classNumber;
				}
				else
				{
					self.tt[1][1+ch2]=classNumber;
					self.tt[4][2+ch2]=classNumber;
					self.tt[2][4+ch2]=classNumber;
				}
				break;
				
            default:
				break;
        }
    }
    else
    {
        int nol=0;
        for(int i=0;i<[slot length];i++)
        {
            if([slot characterAtIndex:i]=='L')
                nol++;
        }
        NSInteger *a[nol];
        int x=0,y=0;
        NSString *temp;
        for(int i=1;i<nol;i++)
        {
            NSRange x = [slot rangeOfString:@"L" options:nil range:NSMakeRange(y, [slot length]-y)];
            //x=slot.indexOf('L',y);
            //temp=slot.substring(x.location+1,slot.indexOf('+',x));
            temp = [slot substringWithRange:NSMakeRange(x.location+1, [slot rangeOfString:@"+" options:nil range:NSMakeRange(x.location, [slot length]-x.location)].location +x.location-1)]; //doubt here
            y=x.location+1;
            //a[i-1]=Integer.parseInt(temp);
            a[i-1] = [temp integerValue];
        }
        //a[nol-1]=Integer.parseInt(slot.substring(slot.indexOf('L',y)+1));
        a[nol-1] = [slot substringWithRange:NSMakeRange([slot rangeOfString:@"L" options:nil range:NSMakeRange(y, [slot length]-y)].location, nil)].integerValue;
        for(int i=0;i<nol;i++)
        {
            for(int j=0;j<5;j++)
            {
                Boolean skip=false;
                
                for(int k=0;k<12;k++)
                {
                    if([self.tt[j][k] integerValue] == a[i])
                    {
                        self.tt[j][k]=classNumber;
                        skip=true;
                        break;
                    }
                }
                if(skip)
                    break;
            }
        }
    }
}

-(void)printTimeTable{
    //oh Yeah
}

-(NSString *)getTTi:(NSInteger)day andi:(NSInteger)i{
    return self.tt[day][i];
}

@end
