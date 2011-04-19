//
//  Hipsters.h
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hipster.h"

@interface Hipsters : NSObject {
	NSArray *dirs;
    UIImage *customImage;
	int unsigned index;
}

@property (nonatomic, retain) NSArray *dirs;
@property (nonatomic, retain) UIImage *customImage;
@property (nonatomic) int unsigned index;

+ (Hipsters *)initWithDir:(NSString *)dir;
+ (Hipsters *)initWithCustomImage:(UIImage *)image;
- (Hipster *)nextHipster;

@end
