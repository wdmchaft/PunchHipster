//
//  SplashViewController.m
//  PunchHipster
//
//  Created by David Patierno on 10/10/10.
//  Copyright 2010. All rights reserved.
//

#import "SplashViewController.h"
#import "PunchHipsterViewController.h"
#import "UpgradeViewController.h"

static NSString *kLeaderboardName = @"com.dmpatierno.punchahipster.punches";

@implementation SplashViewController

@synthesize appDelegate, gcm, topScores, achievements, titleChanger, titleRed, titleBlue, titlePurple, popover;

- (void)showAlertWithTitle:(NSString*) title message:(NSString*)message {
	
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
												   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 
	[super viewDidLoad];
	
	// Grab a handle to our app delegate.
	self.appDelegate = [[UIApplication sharedApplication] delegate];
    achievementChecked = 0;
    
	// Game Center stuff.
	if ([GameCenterManager isGameCenterAvailable]) {
		self.gcm = [[[GameCenterManager alloc] init] autorelease];
		[gcm setDelegate:self];
		[gcm authenticateLocalUser];
	} else {
		self.gcm = nil;
        
        topScores.enabled = NO;
        achievements.enabled = NO;
	}
	
    self.titleChanger = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                         target:self
                                                       selector:@selector(changeTitle:)
                                                       userInfo:nil
                                                        repeats:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:NO];
    if (popover)
        [popover dismissPopoverAnimated:NO];
    
    PunchHipsterViewController *punchController = [[PunchHipsterViewController alloc] initWithNibName:@"PunchView" bundle:nil];
    if (punchController != nil) {
        punchController.customImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        punchController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:punchController animated:NO];
    }
	[punchController autorelease];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // Dismiss the image selection and close the program
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)changeTitle:(id)object {
    
    if (!titleRed.hidden) {
        titleRed.hidden = YES;
        titleBlue.hidden = NO;
    }
    else if (!titleBlue.hidden) {
        titleBlue.hidden = YES;
        titlePurple.hidden = NO;
    }
    else {
        titlePurple.hidden = YES;
        titleRed.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {

	[self submitScore];	
    [self checkAchievements];

}

- (void)processGameCenterAuth:(NSError*)error {

	if (error == NULL) {
		[gcm reloadHighScoresForCategory:kLeaderboardName];
		
        achievementChecked = 0;
		[self checkAchievements];
		[self submitScore];	
	}
	
}

- (void)reloadScoresComplete:(GKLeaderboard*)leaderBoard error:(NSError*)error {
	
	if (error == NULL) {
		NSUInteger personalBest = leaderBoard.localPlayerScore.value;
		
		// Syncronize locally.
		if (personalBest < appDelegate.numPunches)
			personalBest = appDelegate.numPunches;
		else {
			appDelegate.numPunches = personalBest;
		}

		[self viewWillAppear:NO];
	}
	
}

- (void)checkAchievements {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if ([prefs objectForKey:@"fastAchievement"])
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.fast" percentComplete:100];

	if (achievementChecked < 100 && appDelegate.numPunches >= 100) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.100punches" percentComplete:100];
	}
	
	if (achievementChecked < 1000 && appDelegate.numPunches >= 1000) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.1000punches" percentComplete:100];
	}
	
	if (achievementChecked < 5000 && appDelegate.numPunches >= 5000) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.5000punches" percentComplete:100];
	}
	
	if (achievementChecked < 25000 && appDelegate.numPunches >= 25000) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.25000punches" percentComplete:100];
	}
	
	if (achievementChecked < 100000 && appDelegate.numPunches >= 100000) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.100000punches" percentComplete:100];
	}

	if (achievementChecked < 500000 && appDelegate.numPunches >= 500000) {
		[gcm submitAchievement:@"com.dmpatierno.punchahipster.500000punches" percentComplete:100];
	}
	
	achievementChecked = appDelegate.numPunches;
	
}


- (void)submitScore {
	
	if (appDelegate.numPunches > 0)
		[gcm reportScore:appDelegate.numPunches forCategory:kLeaderboardName];
	
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error {
	if (error || !ach) {
		NSLog(@"%@", [error localizedDescription]);
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)showCustom:(UIButton *)button {
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL upgrade = [prefs boolForKey:@"upgrade"];
    
    // Image picker
    if (upgrade) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // The device is an iPad running iOS 3.2 or later.
            UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.popover = pc;
            [pc release];
            
            CGRect rect = button ? button.frame : CGRectMake(0, 0, 768, 1024);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            // The device is an iPhone or iPod touch.
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        
    }
    else {
        [self presentModalViewController:appDelegate.upgradeViewController animated:YES];
    }
    
}

- (IBAction)showHipsters:(id)object {    
    PunchHipsterViewController *punchController = [[PunchHipsterViewController alloc] initWithNibName:@"PunchView" bundle:nil];
    if (punchController != nil) {
        punchController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:punchController animated:YES];
    }
	[punchController autorelease];
}

// https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/GameKit_Guide/LeaderBoards/LeaderBoards.html%23//apple_ref/doc/uid/TP40008304-CH6-SW13
- (IBAction)showLeaderboard:(id)object {

    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController:leaderboardController animated:YES];
    }

	[leaderboardController autorelease];
}

- (IBAction)showAchievements:(id)object {
    GKAchievementViewController *avc = [[GKAchievementViewController alloc] init];
    if (avc != nil) {
        avc.achievementDelegate = self;
        [self presentModalViewController:avc animated:YES];
    }
    [avc autorelease];
}

/* You may want to save off the leaderboard view controller’s timeScope and category properties. 
 * These properties hold the player’s last selections they chose while viewing the leaderboards. 
 * You can then use those same values to initialize the leaderboard view controller the next time 
 * the user wants to see the leaderboard.
 */
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
