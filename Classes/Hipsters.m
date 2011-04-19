//
//  Hipsters.m
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import "Hipsters.h"
#import "NSArray-Shuffle.h"

@implementation Hipsters

@synthesize dirs, customImage, index;

+ (Hipsters *)initWithDir:(NSString *)dir {

	Hipsters *h = [[Hipsters alloc] init];
	
	h.index = 0;
	h.dirs = [[[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:dir] shuffledArray];
	
	return [h autorelease];
	  
}

+ (Hipsters *)initWithCustomImage:(UIImage *)image {
    
	Hipsters *h = [[Hipsters alloc] init];
    h.customImage = image;
	return [h autorelease];
    
}


- (Hipster *)nextHipster {
    
    if (customImage)
        return [Hipster initWithCustomImage:customImage];
	
	if (index >= [dirs count])
		index = 0;
	
	return [Hipster initWithDir:[dirs objectAtIndex:index++]];
	
}

-(void)dealloc {
	[dirs release];
    [super dealloc];
}

@end
