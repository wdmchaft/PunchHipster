//
//  PunchHipsterAppDelegate.h
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSArray-Shuffle.h"

@class SplashViewController;
@class UpgradeViewController;

@interface PunchHipsterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AVAudioPlayer *midiPlayer;
    SplashViewController *viewController;
    UpgradeViewController *upgradeViewController;
	NSUInteger numPunches;
}

@property (nonatomic, retain) AVAudioPlayer *midiPlayer;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SplashViewController *viewController;
@property (nonatomic, retain) UpgradeViewController *upgradeViewController;

@property (nonatomic) NSUInteger numPunches;
@end

