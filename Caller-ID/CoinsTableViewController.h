//
//  CoinsTableViewController.h
//  Caller-ID
//
//  Created by Osama Rabie on 12/01/2019.
//  Copyright © 2019 SADAH Software Solutions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sys/utsname.h>

@import StoreKit;

NS_ASSUME_NONNULL_BEGIN

@interface CoinsTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *cell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell2;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell3;
@property (strong, nonatomic) IBOutlet UITableViewCell *cell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell5;


@end

NS_ASSUME_NONNULL_END
