//
//  SplashViewController.h
//  PunchHipster
//
//  Created by David Patierno on 10/10/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "PunchHipsterAppDelegate.h"
#import "GameCenterManager.h"

@interface SplashViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	PunchHipsterAppDelegate *appDelegate;
	GameCenterManager *gcm;
	NSUInteger achievementChecked;
    
    NSTimer *titleChanger;
    UIImageView *titleRed;
    UIImageView *titleBlue;
    UIImageView *titlePurple;
    
    UIButton *topScores;
    UIButton *achievements;
    UIPopoverController *popover;
}

@property (nonatomic, retain) PunchHipsterAppDelegate *appDelegate;
@property (nonatomic, retain) GameCenterManager *gcm;

@property (nonatomic, retain) NSTimer *titleChanger;
@property (nonatomic, retain) IBOutlet UIImageView *titleRed;
@property (nonatomic, retain) IBOutlet UIImageView *titleBlue;
@property (nonatomic, retain) IBOutlet UIImageView *titlePurple;

@property (nonatomic, retain) IBOutlet UIButton *topScores;
@property (nonatomic, retain) IBOutlet UIButton *achievements;
@property (nonatomic, retain) UIPopoverController *popover;

- (IBAction)showCustom:(UIButton *)object;
- (IBAction)showHipsters:(id)object;
- (IBAction)showLeaderboard:(id)object;
- (IBAction)showAchievements:(id)object;
- (void)checkAchievements;
- (void)submitScore;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
