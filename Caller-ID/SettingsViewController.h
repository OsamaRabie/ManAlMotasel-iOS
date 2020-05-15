//
//  SettingsViewController.h
//  Caller-ID
//
//  Created by Hussein Jouhar on 3/25/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sys/utsname.h>

@import StoreKit;

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *shakeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *autoSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell4;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell5;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell6;

@property (strong, nonatomic) IBOutlet UIImageView *supportIcon;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon;
@property (strong, nonatomic) IBOutlet UIImageView *aboutIcon;
@property (strong, nonatomic) IBOutlet UIImageView *helpIcon;

@end

