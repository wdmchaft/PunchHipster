//
//  PunchHipsterViewController.m
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import "PunchHipsterViewController.h"
#import "SplashViewController.h"
#import "GKAchievementHandler.h"
#import "Appirater.h"

#import "AdWhirlView.h"


@implementation PunchHipsterViewController

@synthesize appDelegate, customImage, highScore, numberFormatter, history, house, image, imageNext, bam, allBams, player, allHipsters, currentHipster, throttle, endOfHipster;

static CGRect smallFrame;
static CGRect bamFrame;
static int minBamCount = 1;

- (IBAction)home:(id)object {
	
	[[appDelegate viewController] dismissModalViewControllerAnimated:YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];

	// Set the Bam frames.
	CGSize screen = [[UIScreen mainScreen] bounds].size;
	smallFrame = CGRectMake( 0.0f, 0.0f, 250.0f, 150.0f);
 	if (screen.width >= 768 && screen.height >= 768) {
        // iPad
		bamFrame   = CGRectMake( 0.0f, 0.0f, 750.0f, 450.0f);
        CGRect houseFrame = house.frame;
        houseFrame.origin.x += 22;
        houseFrame.origin.y += 22;
        house.frame = houseFrame;
	}
    else {
        // iPhone + iPod touch
		bamFrame   = CGRectMake( 0.0f, 0.0f, 400.0f, 240.0f);
    }
	
	// Initialize the hipsters.
    if (customImage) {
        self.allHipsters = [Hipsters initWithCustomImage:customImage];
    }
    else {
        self.allHipsters = [Hipsters initWithDir:@"Hipsters"];
    }
    
    // Initialize the bams.
    self.allBams = [Bams initWithDir:@"Bams"];
	bamCount = 0;
		
	// Set the first image.
	self.currentHipster = [allHipsters nextHipster];
	[image setImage:[currentHipster nextImage]];
	
	// Preload the next.
	[imageNext performSelector:@selector(setImage:) withObject:[currentHipster nextImage] afterDelay:0.1];
	
	// Initiate the throttle.
	self.throttle = [NSDate date];
	 
	// Prepare the sound effects.
	NSString *path = [[NSBundle mainBundle] pathForResource:@"crash" ofType:@"aif"];
	self.player = [SoundEffect soundEffectWithContentsOfFile:path];
	
	// Grab a handle to our app delegate.
	self.appDelegate = [[UIApplication sharedApplication] delegate];
	
	// Init the history array for speed achievement (if necessary).
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *fast = [prefs objectForKey:@"fastAchievement"];
	self.history = fast ? nil : [NSMutableArray array];
    
    // Upgrade?
	BOOL upgrade = [prefs boolForKey:@"upgrade"];
    
    // Initialize the ads.
    if (!upgrade) {
        AdWhirlView *adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        [self.view addSubview:adView];
    }
    
    // Initialize the formatter to add commas to the high score.
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    highScore.text = [numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:appDelegate.numPunches]];
}

- (NSString *)adWhirlApplicationKey {
    return @"d05aaf0defbb4dfd85c0757f2b5c820c";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}
- (void)adWhirlDidReceiveAd:(AdWhirlView *)adView {
    CGSize screen = [[UIScreen mainScreen] bounds].size;

    // fit the ad
    CGRect newFrame = adView.frame;
    newFrame.origin.y = screen.height - [adView actualAdSize].height;
    adView.frame = newFrame;
}


- (void)updateImage {
    
    if (customImage)
        return;
	
	NSTimeInterval preloadDelay = 0.01;
	imageNext.frame = image.frame;
		
	if (endOfHipster) {
		
		// Always show a few Bams at the end.
		if (++bamCount < minBamCount) {
			// TODO: crack the glass
			return;
		}
		
		bamCount = 0;
		endOfHipster = NO;
		
		// Animate the new image.
		CGRect imageSliderFrame = image.frame;
		imageSliderFrame.origin.x = image.frame.origin.x + image.frame.size.width;

		imageNext.frame = imageSliderFrame;
		[UIView beginAnimations:@"slide" context:nil];
		[UIView setAnimationDuration:0.5];
		preloadDelay = 0.4;

		CGRect frame = image.frame;
		
		// Slide in the next image.
		imageNext.frame = frame;
		
		// Slide out the old image.
		frame.origin.x -= frame.size.width;
		image.frame = frame;
		[UIView commitAnimations];
		
	}

	//[image setImage:nextImage];
	[self.view sendSubviewToBack:image];
	
	UIImageView *tmp = image;
	image = imageNext;
	imageNext = tmp;
	
	// Preload the next.
	UIImage *preloadImage = [currentHipster nextImage];
	if (!preloadImage) {
		endOfHipster = YES;		
		self.currentHipster = [allHipsters nextHipster];
		preloadImage = [currentHipster nextImage];
	}
	[imageNext performSelector:@selector(setImage:) withObject:preloadImage afterDelay:preloadDelay];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([throttle timeIntervalSinceNow] < 0) {

		// Don't switch images more than twice per second.
		self.throttle = [NSDate dateWithTimeIntervalSinceNow:0.5];
	
		// Update the image.
		[self updateImage];
		
	}
	
	if (endOfHipster) {
		
		// Require a slight pause between hipsters.
		//self.throttle = [NSDate dateWithTimeIntervalSinceNow:0.3];
		
	}
	
	// play a sound
    [player play];
	
	// Choose a random bam image.
	[bam setImage:[allBams nextImage]];
	
	// Position the BAM!
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
	
	bam.alpha = 1;
	bam.frame = bamFrame;
	bam.center = pos;
	
	smallFrame.origin.x = pos.x - smallFrame.size.width / 2;
	smallFrame.origin.y = pos.y - smallFrame.size.height / 2;
	
	// Fade the BAM after a short delay.
	[self performSelector:@selector(hideBam:) withObject:nil afterDelay:0.3];
	
	// Increment the counter.
	appDelegate.numPunches++;
    
    // Display the new count.
    highScore.text = [numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInt:appDelegate.numPunches]];
    
    Appirater *appirator;
	
	// Check achievements.
	if ([[appDelegate viewController] gcm]) {
		switch (appDelegate.numPunches) {
            case 101:
                appirator = [[Appirater alloc] init];
                if ([appirator connectedToNetwork])
                    [appirator showPrompt];
                break;  
			case 100:
			case 1000:
			case 5000:
			case 25000:
			case 100000:
			case 500000:
                [[GKAchievementHandler defaultHandler] notifyAchievementTitle:
                 @"Achievement Unlocked!" andMessage:@"Great job! Huzzah!"];
              	[[appDelegate viewController] checkAchievements];
                break;              
		}
		
		// Track the speed achievement (if necessary).
		if (history) {
			[history addObject:[NSDate date]];
			if ([history count] > 250) {
				NSDate *old = [history objectAtIndex:0];
				if ([old timeIntervalSinceNow] > -30) {
                    [[GKAchievementHandler defaultHandler] notifyAchievementTitle:
                     @"Achievement Unlocked!" andMessage:@"Great job! You're so fast!"];
					
					// Don't check for this again.
					NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
					[prefs setObject:@"YES" forKey:@"fastAchievement"];	
					[prefs synchronize];
					
              	[[appDelegate viewController] checkAchievements];
					self.history = nil;
				} else {
					[history removeObjectAtIndex:0];
				}
			}
		}
	}
	
}

- (void)hideBam:(id)object {
	[UIView beginAnimations:@"BAM" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	bam.frame = smallFrame;
	bam.alpha = 0;
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[history release];
    [numberFormatter release];
	[appDelegate release];
	[image release];
	[imageNext release];
	[bam release];
	[allBams release];
	[currentHipster release];
	[throttle release];
	[allHipsters release];
	[player release];
    [super dealloc];
}

@end
