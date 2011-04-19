//
//  PunchHipsterAppDelegate.m
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import "PunchHipsterAppDelegate.h"
#import "SplashViewController.h"
#import "UpgradeViewController.h"

@implementation PunchHipsterAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize numPunches;
@synthesize midiPlayer, upgradeViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Set the audio session category.
	NSError *error;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
	
    NSError *err;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"wav"];
    self.midiPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path isDirectory:NO] error:&err];
    if (err) {
        self.midiPlayer = nil;
        NSLog(@"%@", err);
    }
    else {
        midiPlayer.volume = 0.7;
        midiPlayer.numberOfLoops = -1;
        [midiPlayer play];
    }
        
	// Load the high score.
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSNumber *num = [prefs objectForKey:@"numPunches"];
	self.numPunches = num ? [num unsignedIntValue] : 0;

    // Initialize in-app purchases.
    self.upgradeViewController = [[UpgradeViewController alloc] initWithNibName:@"UpgradeView" bundle:nil];
    upgradeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    upgradeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:upgradeViewController];
	
    // Add the view controller's view to the window and display.
    [window addSubview:[viewController view]];
    [window makeKeyAndVisible];

    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
	if ([[url absoluteString] isEqual:@"punchahipster://upgrade"]) {
		[viewController showCustom:nil];
		return YES;
	}
	
	return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[midiPlayer stop];
	[viewController dismissModalViewControllerAnimated:NO];

	// Save our stuff.
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[NSNumber numberWithUnsignedInt:numPunches] forKey:@"numPunches"];	
	[prefs synchronize];
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (!midiPlayer.playing) {
        midiPlayer.currentTime = 0;
        [midiPlayer play];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
