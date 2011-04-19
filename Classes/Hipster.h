//
//  Hipster.h
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Hipster : NSObject {
	NSArray *images;
	int unsigned index;
}

@property (nonatomic, retain) NSArray* images;
@property (nonatomic) int unsigned index;

+ (Hipster *)initWithDir:(NSString *)dir;
+ (Hipster *)initWithCustomImage:(UIImage *)image;
- (UIImage *)nextImage;

@end
