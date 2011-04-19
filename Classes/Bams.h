//
//  Bams.h
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bams : NSObject {
	NSArray *images;
}

@property (nonatomic, retain) NSArray *images;

+ (Bams *)initWithDir:(NSString *)dir;
- (UIImage *)nextImage;


@end
