//
//  NSArray-Shuffle.m
//  PunchHipster
//
//  Created by David Patierno on 7/18/10.
//  Copyright 2010 David Patierno. All rights reserved.
//

#import "NSArray-Shuffle.h"

@implementation NSArray(Shuffle)
-(NSArray *)shuffledArray {
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	
	NSMutableArray *copy = [self mutableCopy];
	while ([copy count] > 0) {
		int index = arc4random() % [copy count];
		id objectToMove = [copy objectAtIndex:index];
		[array addObject:objectToMove];
		[copy removeObjectAtIndex:index];
	}
	
	[copy release];
	return array;
}
@end