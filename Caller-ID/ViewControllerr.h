//
//  ViewController.h
//  Caller-ID
//
//  Created by Hussein Jouhar on 8/1/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sys/utsname.h>
#import "SADAHBlurView.h"

@interface ViewControllerr : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    NSMutableArray *namesArray,*numbersArray,*favArray,*spamArray;
    BOOL isStopAnm,isDidLoad,isReady,isOnSearch,isOnCheck,checkNeeded,isOutView,isLandScape,isResizeDone,firstTry,isShortTxt;
    NSInteger theRow;
    CGFloat tableViewHight,selectButtonYfrm,searchTextYfrm,searchButtonYfrm;
}

@property (strong, nonatomic) NSString *currentPhone;

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;

@property (strong, nonatomic) IBOutlet UIView *adHolderView;
@property (strong, nonatomic) IBOutlet UIImageView *noResultsImg;
@property (strong, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *topNavBar;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UINavigationItem *topTitle;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImg;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *rateNavBar;
@property (strong, nonatomic) IBOutlet UIView *rateView;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UIImageView *rateImg;
@property (strong, nonatomic) IBOutlet UIView *followView;
@property (strong, nonatomic) IBOutlet UINavigationBar *followNavBar;
@property (strong, nonatomic) IBOutlet UIImageView *tipImg;
@property (strong, nonatomic) IBOutlet UILabel *topBackLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyImgBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *searchToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *searchRecBack;
@property (strong, nonatomic) IBOutlet UILabel *topMsgLabel;


@end

