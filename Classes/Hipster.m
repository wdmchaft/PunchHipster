//
//  Hipster.m
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import "Hipster.h"


@implementation Hipster

@synthesize images, index;

+ (Hipster *)initWithDir:(NSString *)dir {

	Hipster *h = [[Hipster alloc] init];
	
	h.index = 0;

	NSArray *pathCompenents = [dir pathComponents];
	NSArray *paths = [[NSBundle mainBundle]
			pathsForResourcesOfType:nil
			inDirectory:[NSString stringWithFormat:@"Hipsters/%@", [pathCompenents lastObject]]];
	
	NSMutableArray *images = [NSMutableArray array];
	for (NSString *path in paths) {
		NSData *imageData = [NSData dataWithContentsOfFile:path];
		[images addObject:[UIImage imageWithData:imageData]];
	}
	
	h.images = [NSArray arrayWithArray:images];
	
	return [h autorelease];

}

+ (Hipster *)initWithCustomImage:(UIImage *)image {
    
	Hipster *h = [[Hipster alloc] init];
	
	h.index = 0;
    h.images = [NSArray arrayWithObject:image];
	
	return [h autorelease];
    
}


- (UIImage *)nextImage {
	
	if (index >= [images count])
		return nil;
	
	return [images objectAtIndex:index++];
	
}

-(void)dealloc {
	[images release];
    [super dealloc];
}

		 


@end
