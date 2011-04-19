//
//  PunchHipsterViewController.h
//  PunchHipster
//
//  Created by David Patierno on 10/5/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PunchHipsterAppDelegate.h"
#import "SoundEffect.h"
#import "Hipsters.h"
#import "Bams.h"
#import "AdWhirlDelegateProtocol.h"

@interface PunchHipsterViewController : UIViewController <AVAudioPlayerDelegate, AdWhirlDelegate> {
	PunchHipsterAppDelegate *appDelegate;
    UIImage *customImage;
    UILabel *highScore;
    NSNumberFormatter *numberFormatter;

	SoundEffect *player;
	UIImageView *image;
	UIImageView *imageNext;
	UIImageView *bam;
    UIButton *house;
	Hipsters *allHipsters;
	Hipster *currentHipster;
	Bams *allBams;
	NSMutableArray *history;
	NSDate *throttle;
	BOOL endOfHipster;
	int unsigned bamCount;
}

@property (nonatomic, retain) PunchHipsterAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UILabel *highScore;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property (nonatomic, retain) UIImage *customImage;

@property (nonatomic, retain) IBOutlet UIButton* house;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UIImageView* imageNext;
@property (nonatomic, retain) IBOutlet UIImageView* bam;
@property (nonatomic, retain) Hipsters *allHipsters;
@property (nonatomic, retain) Hipster *currentHipster;
@property (nonatomic, retain) Bams *allBams;
@property (nonatomic, retain) NSMutableArray *history;
@property (nonatomic, retain) SoundEffect *player;
@property (nonatomic, retain) NSDate *throttle;
@property (nonatomic) BOOL endOfHipster;

- (void)updateImage;
- (IBAction)home:(id)object;

@end

