//
//  Bams.m
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import "Bams.h"


@implementation Bams

@synthesize images;

+ (Bams *)initWithDir:(NSString *)dir {
	
	Bams *b = [[Bams alloc] init];
	
	b.images = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:dir];
	
	return [b autorelease];
	
}

- (UIImage *)nextImage {
	
	NSUInteger index = arc4random() % [images count];
	
	return [UIImage imageWithContentsOfFile:[images objectAtIndex:index]];
	
}

-(void)dealloc {
	[images release];
    [super dealloc];
}

@end
