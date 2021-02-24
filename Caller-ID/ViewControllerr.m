//
//  ViewController.m
//  Caller-ID
//
//  Created by Hussein Jouhar on 8/1/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import "ViewControllerr.h"
#import "CRToastManager.h"
#import "CRToast.h"
#import "AFNetworking.h"
@import GoogleMobileAds;
#import "AESTool.h"
#import "UICKeyChainStore.h"
@import Firebase;
#import "APAddressBook.h"
#import "APContact.h"
#import "APPhone.h"
#import "APJob.h"
#import "APName.h"
#import "APEmail.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "AdViewController.h"
#import "AESTool.h"
#import <RMStore/RMStore.h>
#import <KSToastView/KSToastView.h>
#import <CallKit/CallKit.h>
#import  <FirebaseMessaging/FirebaseMessaging.h>
#import "Utils.h"

@interface ViewControllerr ()<GADInterstitialDelegate>
@property(strong,nonatomic) FIRDatabaseReference* ref;
@property(strong,nonatomic) FIRDatabaseReference* ref2;
@property(strong,nonatomic) FIRUser* refUser;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation ViewControllerr
{
    __weak IBOutlet UILabel *headerLabel;
    GADBannerView  *bannerView;
    NSString* key;
    __weak IBOutlet UIView *rectBannerView;
    GADBannerView  *rectbanner;
    NSDictionary* ad;
    NSString* live;
    NSString* nameLimit;
    NSDictionary* jsonLoc;
    __weak IBOutlet UILabel *infoLabel;
    SKProduct* pointsProducts;
    NSString* blockMethod;
    NSString* blockURL;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"adSeg"])
    {
        AdViewController* dst = (AdViewController*)[segue destinationViewController];
        [dst setAd:ad];
    }
}

-(BOOL)isiPhoneX
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
                printf("iPhone 5 or 5S or 5C");
                return NO;
                break;
            case 1334:
                printf("iPhone 6/6S/7/8");
                return NO;
                break;
            case 2208:
                printf("iPhone 6+/6S+/7+/8+");
                return NO;
                break;
            case 2436:
                printf("iPhone X");
                return YES;
                break;
            default:
                printf("unknown");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isiPhoneX])
    {
        [_topNavBar setFrame:CGRectMake(_topNavBar.frame.origin.x, _topNavBar.frame.origin.y+15, _topNavBar.frame.size.width, _topNavBar.frame.size.height)];
        
        [_adHolderView setFrame:CGRectMake(_adHolderView.frame.origin.x, _adHolderView.frame.origin.y+15, _adHolderView.frame.size.width, _adHolderView.frame.size.height)];
        
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y+15, _tableView.frame.size.width, _tableView.frame.size.height-15)];
        
        for (UIView *view in _mainView.subviews)
        {
            if (view.tag == 11 || view.tag == 12)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+15, view.frame.size.width, view.frame.size.height)];
            }
        }
    }
    
    
    blockMethod = @"1";
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lang" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    jsonLoc = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    [[FIRAuth auth]signOut:nil];
    self.ref = [[FIRDatabase database] reference];
    self.ref2 = [[FIRDatabase databaseWithURL:@"https://menomotaselq8-e2d58.firebaseio.com/"] reference];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent": @"iPhone CFNetwork Darwin IchIJe" }];
    
    NSString *userID = @"base";
    [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    ;
    live = @"0";
    nameLimit = @"2";
    [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:baseURL forKey:@"base"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
    [[[_ref child:@"config"] child:@"live"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            self->live = baseURL;
        }
    }];
    [[[_ref child:@"config"] child:@"nameLimit4"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            self->nameLimit = baseURL;
        }
    }];
    [[[_ref child:@"config"] child:@"blockMethod"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            self->blockMethod = baseURL;
        }
    }];
    [[[_ref child:@"config"] child:@"blockURL"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            self->blockURL = baseURL;
        }
    }];
    [[[_ref child:@"config"] child:@"coins"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            NSArray* coins = [baseURL componentsSeparatedByString:@","];
            UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
            [store setString:coins[0] forKey:@"nameCoins"];
            [store setString:coins[1] forKey:@"phoneCoins"];
            [store setString:coins[2] forKey:@"spamCoins"];
            [store setString:coins[3] forKey:@"blockCoins"];
            [store setString:coins[4] forKey:@"supportCoins"];
            [store synchronize];
        }
    }];
    
    
    if (!isResizeDone)
    {
        UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
        
        if ([[store stringForKey:@"ads"] isEqualToString:@"NO"])
        {
            isResizeDone = YES;
            [bannerView removeFromSuperview];
            
            [self.tableView setFrame:CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height+_adHolderView.frame.size.height)];
        }
    }
    
    
    
    tableViewHight = self.tableView.frame.size.height;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:14]
       }
     forState:UIControlStateNormal];
    
    [_topNavBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:16]}];
    
    [_rateNavBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:15]}];
    
    [_searchButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"DroidArabicKufi" size:15], NSFontAttributeName,
                                        [self colorWithHexString:@"141414"], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    
    [_searchButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont fontWithName:@"DroidArabicKufi" size:15], NSFontAttributeName,
                                               [self colorWithHexString:@"141414"], NSForegroundColorAttributeName,
                                               nil]
                                     forState:UIControlStateHighlighted];
    
    [_followNavBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:15]}];
    
    [[self.view viewWithTag:11] setFrame:CGRectMake([self.view viewWithTag:11].frame.origin.x-100, [self.view viewWithTag:11].frame.origin.y, [self.view viewWithTag:11].frame.size.width, [self.view viewWithTag:11].frame.size.height)];
    
    [[self.view viewWithTag:12] setFrame:CGRectMake([self.view viewWithTag:12].frame.origin.x+100, [self.view viewWithTag:12].frame.origin.y, [self.view viewWithTag:12].frame.size.width, [self.view viewWithTag:12].frame.size.height)];
    
    [_rateView.layer setCornerRadius:5];
    [_followView.layer setCornerRadius:5];
    
    [_searchTextField.layer setBorderWidth:1];
    [_searchTextField.layer setBorderColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor];
    
    [_loadingView.layer setBorderWidth:1];
    [_loadingView.layer setBorderColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor];
    
    [_loadingView.layer setCornerRadius:_loadingView.frame.size.width/2];
    
    
    //
    
    namesArray = [[NSMutableArray alloc]init];;
    
    numbersArray = [[NSMutableArray alloc]init];
    
    //
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTime"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShake"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        selectButtonYfrm = _selectButton.frame.origin.y;
        searchTextYfrm = _searchTextField.frame.origin.y;
        searchButtonYfrm = _searchButton.frame.origin.y;
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            if (!isLandScape)
            {
                isLandScape = YES;
                
                [self changeButtonsLocation:NO];
            }
        }
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(deviceOrientationDidChangeNotification:)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    favArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedFavArray"]];
    
    [_selectButton setHidden:NO];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isRateDone2"])
    {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"rateCount2"] >= 2)
        {
            if (@available(iOS 10.3, *)) {
                [self performSelector:@selector(showTheRate) withObject:nil afterDelay:2.0];
            }
            else
            {
                [self performSelector:@selector(showRateView) withObject:nil afterDelay:2.0];
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRateDone2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"rateCount2"]+1 forKey:@"rateCount2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2433238124854818/6697593261"];
    self.interstitial.delegate = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,@"56bc4cbbfb23c38a2d6f7c702b44c184" ];
    [self.interstitial loadRequest:request];
    
    
    rectbanner = [[GADBannerView alloc]initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_300x250)];
    rectbanner.adUnitID = @"ca-app-pub-2433238124854818/1590885014";
    rectbanner.rootViewController = self;
    [rectbanner setAdSize:GADAdSizeFromCGSize(GAD_SIZE_300x250)];
    [rectBannerView addSubview:rectbanner];
    
    rectbanner.center = CGPointMake(rectBannerView.frame.size.width/2,rectBannerView.frame.size.height/2);
    
    [rectbanner setFrame:CGRectMake(rectbanner.frame.origin.x, 0, rectbanner.frame.size.width, rectbanner.frame.size.height)];
    
    GADRequest* request2 = [GADRequest request];
    request2.testDevices = @[ kGADSimulatorID,@"56bc4cbbfb23c38a2d6f7c702b44c184"];
    [rectbanner loadRequest:request2];
    
    [self startupAnimation];
    
    
    [[RMStore defaultStore]requestProducts:[NSSet setWithObjects:@"meno.motasel.app.100", nil] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        self->pointsProducts = [products objectAtIndex:0];
        NSLog(@"%@",self->pointsProducts.localizedTitle);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
}

-(void)showTheRate
{
    [_searchTextField resignFirstResponder];
    [SKStoreReviewController requestReview];
}

- (IBAction)rateNow:(id)sender {
    [_rateButton setEnabled:NO];
    [_rateButton setTitle:@"شكراً لك!" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         self->_rateButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(closeRateView:) withObject:nil afterDelay:1.0];
                         [self performSelector:@selector(openRateUrl) withObject:nil afterDelay:1.3];
                     }];
    [UIView commitAnimations];
}

- (IBAction)dismissClicked:(id)sender {
    [_searchTextField resignFirstResponder];
}

- (IBAction)openTheServices:(id)sender {
    [self performSegueWithIdentifier:@"servicesSeg" sender:self];
}

-(void)openRateUrl
{
    [_rateButton setEnabled:YES];
    _rateButton.transform = CGAffineTransformMakeScale(1, 1);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/منو-المتصل/id1404915263?ls=1&mt=8"]];
}

-(void)showRateView
{
    [_searchTextField resignFirstResponder];
    
    SADAHBlurView *blurView = [[SADAHBlurView alloc] initWithFrame:self.view.frame];
    
    [blurView setTag:397];
    [blurView setAlpha:0.0];
    
    [blurView setBlurRadius:10];
    [blurView setBlurEnabled:YES];
    
    [self.view addSubview:blurView];
    
    UIView *theBackgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    
    [theBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]];
    
    [theBackgroundView setTag:398];
    
    [theBackgroundView setAlpha:0.0];
    
    [self.view addSubview:theBackgroundView];
    
    [_rateView setHidden:YES];
    
    [self.view addSubview:_rateView];
    
    [_rateView setCenter:self.view.center];
    
    [_rateView setFrame:CGRectMake(_rateView.frame.origin.x, _rateView.frame.origin.y+self.view.frame.size.height, _rateView.frame.size.width, _rateView.frame.size.height)];
    
    [_rateView setHidden:NO];
    
    _rateView.transform=CGAffineTransformMakeRotation(M_PI / -4);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0
                     animations:^{
                         [blurView setAlpha:1.0];
                         [theBackgroundView setAlpha:1.0];
                         
                         self->_rateView.transform=CGAffineTransformMakeRotation(0);
                         
                         [self->_rateView setFrame:CGRectMake(self->_rateView.frame.origin.x, self->_rateView.frame.origin.y-self.view.frame.size.height, self->_rateView.frame.size.width, self->_rateView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
}

- (IBAction)closeRateView:(id)sender {
    float theDelay = 0.0;
    
    if (sender != nil)
    {
        theDelay = 1;
        [_rateImg setImage:[UIImage imageNamed:@"sad-rate.png"]];
    }
    
    [UIView animateWithDuration:0.3 delay:theDelay options:0
                     animations:^{
                         [[self.view viewWithTag:397] setAlpha:0.0];
                         [[self.view viewWithTag:398] setAlpha:0.0];
                         
                         self->_rateView.transform=CGAffineTransformMakeRotation(0);
                         
                         [self->_rateView setFrame:CGRectMake(self->_rateView.frame.origin.x, self->_rateView.frame.origin.y+self.view.frame.size.height, self->_rateView.frame.size.width, self->_rateView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [[self.view viewWithTag:397] removeFromSuperview];
                         [[self.view viewWithTag:398] removeFromSuperview];
                         
                         [self->_rateView setFrame:CGRectMake(self->_rateView.frame.origin.x, self->_rateView.frame.origin.y-self.view.frame.size.height, self->_rateView.frame.size.width, self->_rateView.frame.size.height)];
                         
                         [self->_rateView removeFromSuperview];
                         
                         [self->_rateImg setImage:[UIImage imageNamed:@"happy-rate.png"]];
                         
                         [self->_searchTextField becomeFirstResponder];
                     }];
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSString*countryCode = ([Utils isVpnActive]) ? @"us" : @"kw";
    [[NSUserDefaults standardUserDefaults] setObject:countryCode forKey:@"country"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isNumberSearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self changeSearchMethod];
    
    if (!isResizeDone)
    {
        UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
        
        if ([[store stringForKey:@"ads"] isEqualToString:@"NO"])
        {
            isResizeDone = YES;
            [bannerView removeFromSuperview];
            bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50)];
            bannerView.adUnitID = @"ca-app-pub-2433238124854818/6729791975";
            bannerView.rootViewController = self;
            [bannerView setAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50)];
            [_searchView addSubview:bannerView];
            
//            [_adHolderView setFrame:CGRectMake(_adHolderView.frame.origin.x, 64, _adHolderView.frame.size.width, 50)];
            
            bannerView.center = _adHolderView.center;
            
            GADRequest* request = [GADRequest request];
            request.testDevices = @[ kGADSimulatorID,@"56bc4cbbfb23c38a2d6f7c702b44c184"];
            [bannerView loadRequest:request];
            [self.tableView setFrame:CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height+_adHolderView.frame.size.height)];
            tableViewHight = self.tableView.frame.size.height;
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBuyDone"])
    {
        [_buyImgBtn setImage:[UIImage imageNamed:@"buy-icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_buyImgBtn setImage:[UIImage imageNamed:@"buy-icon-bdg.png"] forState:UIControlStateNormal];
    }
    
    [self->_searchButton setUserInteractionEnabled:NO];
    [self->_searchButton setAlpha:0.3f];
    NSString *userID = @"base";
    [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    ;
    [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self->_searchButton setUserInteractionEnabled:YES];
            [self->_searchButton setAlpha:1.0f];
            NSString* baseURL = snapshot.value;
            if(baseURL && baseURL.length > 0)
            {
                [[NSUserDefaults standardUserDefaults]setObject:baseURL forKey:@"base"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        });
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self->_searchButton setUserInteractionEnabled:YES];
            [self->_searchButton setAlpha:1.0f];
        });
    }];
    
    
    [[_ref child:@"freeName"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSString* freeName = snapshot.value;
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[NSUserDefaults standardUserDefaults]setObject:freeName forKey:@"fn"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            });
        });
    } withCancelBlock:^(NSError * _Nonnull error) {
    }];
}

-(void)localise
{
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"lang"])
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Language - اللغة"
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"العربية"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [[NSUserDefaults standardUserDefaults]setObject:@"ar" forKey:@"lang"];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        [self localise];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"English"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"lang"];
                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                       [self localise];
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        self.tabBarController.tabBar.items[0].title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"search"];
        self.tabBarController.tabBar.items[1].title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"daleel"];
        self.tabBarController.tabBar.items[2].title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"spamDetect"];
        self.tabBarController.tabBar.items[3].title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blackList"];
        [infoLabel setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"feedbackLabel"]];
        [self.searchButton setTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"search"] forState:UIControlStateNormal];
        if (isShortTxt)
        {
            [self.buyButton setTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockLabelShort"] forState:UIControlStateNormal];
        }
        else
        {
            [self.buyButton setTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockLabel"] forState:UIControlStateNormal];
        }
    }
    
    [self changeSearchMethod];
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        if (!isLandScape)
        {
            isLandScape = YES;
            
            [self changeButtonsLocation:NO];
        }
    }
    else
    {
        if (isLandScape)
        {
            isLandScape = NO;
            
            [self changeButtonsLocation:YES];
        }
    }
}

-(void)changeButtonsLocation:(BOOL)isPortrait
{
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         NSInteger plusVal = 20;
                         
                         if ([self isiPhoneSe])
                         {
                             plusVal = 5;
                         }
                         
                         rectbanner.center = CGPointMake(rectBannerView.frame.size.width/2,rectBannerView.frame.size.height/2);
                         
                         [rectbanner setFrame:CGRectMake(rectbanner.frame.origin.x, 0, rectbanner.frame.size.width, rectbanner.frame.size.height)];
                         
                         [_selectButton setFrame:CGRectMake(_selectButton.frame.origin.x, _topBackLabel.frame.origin.y+_topBackLabel.frame.size.height+plusVal, _selectButton.frame.size.width, _selectButton.frame.size.height)];
                         
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _selectButton.frame.origin.y+_selectButton.frame.size.height+plusVal, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                         
                         [_searchRecBack setFrame:CGRectMake(_searchRecBack.frame.origin.x, _searchTextField.frame.origin.y, _searchRecBack.frame.size.width, _searchRecBack.frame.size.height)];
                         
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchRecBack.frame.size.width-80, _searchTextField.frame.size.height)];
                         
                         [_searchButton setFrame:CGRectMake(_searchTextField.frame.origin.x+_searchTextField.frame.size.width, _searchTextField.frame.origin.y, 80, _searchTextField.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self checkClipBoard];
}

- (IBAction)openSettings:(id)sender {
    if (!isReady)return;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    isOutView = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [FIRAnalytics logEventWithName:kFIREventAppOpen
                        parameters:@{}];
    
    
    if (!isDidLoad)
    {
        isDidLoad = YES;
        
        UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
        
        if (![[store stringForKey:@"ads"] isEqualToString:@"NO"])
        {
            bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50)];
            bannerView.adUnitID = @"ca-app-pub-2433238124854818/6729791975";
            bannerView.rootViewController = self;
            [bannerView setAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50)];
            [_searchView addSubview:bannerView];
            
//            [_adHolderView setFrame:CGRectMake(_adHolderView.frame.origin.x, 64, _adHolderView.frame.size.width, 50)];
            
            bannerView.center = _adHolderView.center;
            
            GADRequest* request = [GADRequest request];
            request.testDevices = @[ kGADSimulatorID,@"56bc4cbbfb23c38a2d6f7c702b44c184"];
            [bannerView loadRequest:request];
        }
    }
    else
    {
        if (!isOnSearch)
        {
            [_searchTextField becomeFirstResponder];
        }
    }
    
    isOutView = NO;
    
    if (!isOnSearch)
    {
        if (checkNeeded)
        {
            checkNeeded = NO;
            [self checkClipBoard];
        }
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isHelpDone"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isHelpDone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showHelp];
    }
    else
    {
        [self checkClipBoard];
    }
    
    
    
    [[_ref child:@"ad"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            self->ad = snapshot.value;
            dispatch_async(dispatch_get_main_queue(), ^(){
                if(![[self->ad objectForKey:@"adVersion2"]isEqualToString:@"-1"])
                {
                    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"adVersion2"] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"adVersion2"] isEqualToString:[self->ad objectForKey:@"adVersion2"]])
                    {
                        [self performSegueWithIdentifier:@"adSeg" sender:self];
                        [[NSUserDefaults standardUserDefaults]setObject:[self->ad objectForKey:@"adVersion2"] forKey:@"adVersion2"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }
            });
        });
    } withCancelBlock:^(NSError * _Nonnull error) {
    }];
    if (!isOnSearch)
    {
        [self localise];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"delNumClicked"])
    {
        NSMutableArray *imageArray = [NSMutableArray new];

        [imageArray addObject:[UIImage imageNamed:@"home-icon.png"]];
        [imageArray addObject:[UIImage imageNamed:@"home-icon-2.png"]];

        [_buyButton setImage:[UIImage imageNamed:@"home-icon.png"] forState:UIControlStateNormal];

        [_buyButton.imageView setAnimationImages:[imageArray copy]];
        [_buyButton.imageView setAnimationDuration:1.5];

        [_buyButton.imageView startAnimating];
    }
    
}

-(BOOL)shouldAutorotate
{
    [super shouldAutorotate];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )return YES;
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return (UIInterfaceOrientationMaskAll);
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)openMenu:(id)sender {
    if (!isReady)return;
}

-(void)addResultsToLog
{
    if (namesArray.count != numbersArray.count)return;
    
    NSString *theName,*theNumber;
    
    NSMutableArray *logArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedLogArray"]];
    
    for (int i = 0; i < namesArray.count; i++)
    {
        theName = [namesArray objectAtIndex:i];
        theNumber = [numbersArray objectAtIndex:i];
        
        if (![logArray containsObject:[theName stringByAppendingFormat:@"-*3&^*4-%@",theNumber]])
        {
            [logArray addObject:[theName stringByAppendingFormat:@"-*3&^*4-%@",theNumber]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:logArray forKey:@"savedLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)startupAnimation
{
    [_searchButton setFrame:CGRectMake(_searchButton.frame.origin.x, _searchButton.frame.origin.y+500, _searchButton.frame.size.width, _searchButton.frame.size.height)];
    
    [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y+500, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0
                     animations:^{
                         
                         [[self.view viewWithTag:11] setFrame:CGRectMake([self.view viewWithTag:11].frame.origin.x+100, [self.view viewWithTag:11].frame.origin.y, [self.view viewWithTag:11].frame.size.width, [self.view viewWithTag:11].frame.size.height)];
                         
                         [[self.view viewWithTag:12] setFrame:CGRectMake([self.view viewWithTag:12].frame.origin.x-100, [self.view viewWithTag:12].frame.origin.y, [self.view viewWithTag:12].frame.size.width, [self.view viewWithTag:12].frame.size.height)];
                         
                         [_searchButton setFrame:CGRectMake(_searchButton.frame.origin.x, _searchButton.frame.origin.y-500, _searchButton.frame.size.width, _searchButton.frame.size.height)];
                         
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y-500, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                         
                         NSInteger plusVal = 20;
                         
                         if ([self isiPhoneSe])
                         {
                             plusVal = 5;
                         }
                         
                         [_selectButton setFrame:CGRectMake(_selectButton.frame.origin.x, _topBackLabel.frame.origin.y+_topBackLabel.frame.size.height+plusVal, _selectButton.frame.size.width, _selectButton.frame.size.height)];
                         
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _selectButton.frame.origin.y+_selectButton.frame.size.height+plusVal, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                         
                         [_searchRecBack setFrame:CGRectMake(_searchRecBack.frame.origin.x, _searchTextField.frame.origin.y, _searchRecBack.frame.size.width, _searchRecBack.frame.size.height)];
                         
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x, _searchTextField.frame.origin.y, _searchRecBack.frame.size.width-80, _searchTextField.frame.size.height)];
                         
                         [_searchButton setFrame:CGRectMake(_searchTextField.frame.origin.x+_searchTextField.frame.size.width, _searchTextField.frame.origin.y, 80, _searchTextField.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self checkSearchMethod];
                     }];
    [UIView commitAnimations];
}

-(BOOL)isiPhoneSe
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
                printf("iPhone 5 or 5S or 5C");
                return YES;
                break;
            case 1334:
                printf("iPhone 6/6S/7/8");
                return YES;
                break;
            case 2208:
                printf("iPhone 6+/6S+/7+/8+");
                break;
            case 2436:
                printf("iPhone X");
                break;
            default:
                printf("unknown");
        }
    }
    
    return NO;
}

-(void)showLoading
{
    isStopAnm = NO;
    [_loadingView setHidden:NO];
    _loadingView.center = _selectButton.center;
    [self startloadingAnimation];
}

-(void)hideLoading
{
    [_loadingView setHidden:YES];
    isStopAnm = YES;
}

-(void)startloadingAnimation
{
    if (isStopAnm)return;
    
    [_loadingImg setImage:[UIImage imageNamed:@"loading-to-right.png"]];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:0
                     animations:^{
                         [_loadingImg setFrame:CGRectMake(_loadingView.frame.size.width-_loadingImg.frame.size.width, _loadingImg.frame.origin.y, _loadingImg.frame.size.width, _loadingImg.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_loadingImg setImage:[UIImage imageNamed:@"loading-to-left.png"]];
                         [UIView animateWithDuration:0.5 delay:0.0 options:0
                                          animations:^{
                                              [_loadingImg setFrame:CGRectMake(0, _loadingImg.frame.origin.y, _loadingImg.frame.size.width, _loadingImg.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              [self startloadingAnimation];
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

- (IBAction)favOnOff:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if ([self isFavName:[namesArray objectAtIndex:indexPath.row] andNumber:[numbersArray objectAtIndex:indexPath.row]])
    {
        [self removeFromFav:[namesArray objectAtIndex:indexPath.row] andNumber:[numbersArray objectAtIndex:indexPath.row]];
    }
    else
    {
        [self addToFav:[namesArray objectAtIndex:indexPath.row] andNumber:[numbersArray objectAtIndex:indexPath.row]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (IBAction)startSearch:(id)sender {
    
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.group2.meno.motasel.app"];
    [myDefaults setObject:@"" forKey:@"block"];
    
    if ([_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
        {
            [self showGhostMsg:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"enterNumber"] isError:YES];
        }
        else
        {
            [self showGhostMsg:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"enterName"] isError:YES];
        }
        
        [self shakeSearch];
        [_searchTextField becomeFirstResponder];
        return;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"] && [_searchTextField.text componentsSeparatedByString:@" "].count < [nameLimit intValue])
    {
        [self showGhostMsg:[NSString stringWithFormat:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"fullName"],nameLimit] isError:YES];
        
        [self shakeSearch];
        [_searchTextField becomeFirstResponder];
        return;
    }
    
    if ([_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 8)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
        {
            [self showGhostMsg:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"fullNumber"] isError:YES];
            [self shakeSearch];
            [_searchTextField becomeFirstResponder];
            return;
        }
    }
    
   if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
    {
        if (![[UICKeyChainStore keyChainStore] stringForKey:@"name"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"fn"]isEqualToString:@"0"])
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"خاصية البحث بإسم"
                                         message:@"يرجى شراء خاصية البحث بإسم أو استعادتها مجاناً من قسم المشتريات في حال قمت بالشراء مسبقاً"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"فتح قسم المشتريات"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self performSegueWithIdentifier:@"servicesSeg" sender:self];
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"إلغاء"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [self shakeSearch];
            [_searchTextField becomeFirstResponder];
            return;
        }
    }
    
    [self hideNoResults];
    
    [_searchTextField resignFirstResponder];
    [self showLoading];
    [self loadResults];
}

-(void)showNormalMsgWithTitle:(NSString*)theTitle andMsg:(NSString*)theMsg
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:theTitle
                                 message:theMsg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"تم"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)loadResults
{
    NSString* type = @"";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
    {
        type = @"1";
    }else
    {
        type = @"2";
    }
    
    
    [FIRAnalytics logEventWithName:kFIREventViewSearchResults
                        parameters:@{
                                     kFIRParameterItemID:self->_searchTextField.text,
                                     kFIRParameterItemName:self->_searchTextField.text,
                                     kFIRParameterContentType:([type isEqualToString:@"1"]?@"Number" :@"Name")
                                     }];
    
    // [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent": @"iPhone CFNetwork Darwin IchIJe" }];
    
    NSString *userID = @"base";
    [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    ;
    [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:baseURL forKey:@"base"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSString* search = self->_searchTextField.text;
            if([type isEqualToString:@"1"])
            {
                search = [search stringByReplacingOccurrencesOfString:@"٠" withString:@"0"];
                search = [search stringByReplacingOccurrencesOfString:@"١" withString:@"1"];
                search = [search stringByReplacingOccurrencesOfString:@"٢" withString:@"2"];
                search = [search stringByReplacingOccurrencesOfString:@"٣" withString:@"3"];
                search = [search stringByReplacingOccurrencesOfString:@"٤" withString:@"4"];
                search = [search stringByReplacingOccurrencesOfString:@"٥" withString:@"5"];
                search = [search stringByReplacingOccurrencesOfString:@"٦" withString:@"6"];
                search = [search stringByReplacingOccurrencesOfString:@"٧" withString:@"7"];
                search = [search stringByReplacingOccurrencesOfString:@"٨" withString:@"8"];
                search = [search stringByReplacingOccurrencesOfString:@"٩" withString:@"9"];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSInteger saltNumber = arc4random() % 100;
                NSInteger saltNumber2 = arc4random() % 100;
                NSInteger saltNumber3 = arc4random() % 100;
                NSInteger saltNumber4 = arc4random() % 100;
                NSInteger saltNumber5 = arc4random() % 100;
                NSString* limit = @"70";
                NSString*countryCode = ([Utils isVpnActive]) ? @"us" : @"kw";
                NSString *encStr = [AESTool encryptData:[NSString stringWithFormat:@"%literm=%@&%liopt=%@&%lilimit=%@&%lislt=%li&country=%@",(long)saltNumber,search,(long)saltNumber2,type,(long)saltNumber3,limit,(long)saltNumber4,(long)saltNumber5,countryCode] withKey:@"9ONO45Rq1S68nLCm"];
                NSString* ss = [NSString stringWithFormat:@"%@/getNamesEnc04Motasel.php",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"]];
                //https://17k7vl8b6h.execute-api.us-east-1.amazonaws.com/newapi/getNamesEnc04Motasel.php?code=tvHywikB0I7prFnKaKUDPd/p8Zs54E/zfuMblQdYYwVZH/DjFmAUkihqEmhTUKJM
                
                encStr = [encStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?code=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],@"getNamesEnc04Motasel.php",encStr]]];
                NSString* dec = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                dec = [dec stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
                
                dec = [AESTool decryptData:dec withKey:@"9ONO45Rq1S68nLCm"];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    NSError* error2;
                    NSArray* result = [NSJSONSerialization
                                       JSONObjectWithData:[dec dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]
                                       options:kNilOptions
                                       error:&error2];
                    //NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"spam"  ascending:NO];
                    //NSArray* result  = [result2 sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                    
                    if(!error2)
                    {
                        self->namesArray = [[NSMutableArray alloc]init];
                        self->numbersArray = [[NSMutableArray alloc]init];
                        self->spamArray = [[NSMutableArray alloc]init];
                        for(int i =0 ; i < result.count ; i++)
                        {
                            [self->namesArray addObject:[[result objectAtIndex:i] objectForKey:@"name"]];
                            [self->numbersArray addObject:[[result objectAtIndex:i] objectForKey:@"phone"]];
                            //[self->spamArray addObject:[[result objectAtIndex:i] objectForKey:@"spam"]];
                        }
                        
                        [self showSearchView];
                    }else
                    {
                        NSLog(@"error: %@", error2);
                        [self hideLoading];
                        [self showGhostMsg:@"حدث خطأ، ونعمل على الإصلاح، جرب بعد قليل." isError:YES];
                        
                    }
                });
            });
        });
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
    
}

- (IBAction)closeSearch:(id)sender {
    [self hideSearchView];
}

-(void)shakeSearch
{
    [self doVibrate];
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x-5, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 delay:0.0 options:0
                                          animations:^{
                                              [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x+10, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1 delay:0.0 options:0
                                                               animations:^{
                                                                   [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x-7, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.01 delay:0.0 options:0
                                                                                    animations:^{
                                                                                        [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x+7, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.01 delay:0.0 options:0
                                                                                                         animations:^{
                                                                                                             [_searchTextField setFrame:CGRectMake(_searchTextField.frame.origin.x-5, _searchTextField.frame.origin.y, _searchTextField.frame.size.width, _searchTextField.frame.size.height)];
                                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             //
                                                                                                         }];
                                                                                        [UIView commitAnimations];
                                                                                    }];
                                                                   [UIView commitAnimations];
                                                               }];
                                              [UIView commitAnimations];
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

-(void)doVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)showSearchView
{
    if (isOnSearch)return;
    isOnSearch = YES;
    
    [_searchTextField resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self->_searchView setFrame:CGRectMake(self->_searchView.frame.origin.x, self->_searchView.frame.origin.y+self->_searchView.frame.size.height, self->_searchView.frame.size.width, self->_searchView.frame.size.height)];
        
        if (self->namesArray.count > 0)
        {
            [self->_topTitle setTitle:[@"النتائج: " stringByAppendingFormat:@"(%lu)",(unsigned long)self->namesArray.count]];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
            {
                if([[[NSUserDefaults standardUserDefaults] stringForKey:@"lang"]isEqualToString:@"en"])
                {
                    [self->headerLabel setText:[NSString stringWithFormat:@"The number has 10+ spam reports from the app's users.\nTop %lu: reported names",(unsigned long)self->namesArray.count]];
                }else
                {
                    [self->headerLabel setText:[NSString stringWithFormat:@"الرقم عليه ١٠+ بلاغات كمتطفل،\n أعلى %lu أسماء في البلاغات:",(unsigned long)self->namesArray.count]];
                }
            }else
            {
                if([[[NSUserDefaults standardUserDefaults] stringForKey:@"lang"]isEqualToString:@"en"])
                {
                    [self->headerLabel setText:[NSString stringWithFormat:@"Names with more than 10 spam records are shown.Top %lu",self->namesArray.count]];
                }else
                {
                    [self->headerLabel setText:[NSString stringWithFormat:@"نعرض الأسماء التي سجلت من أكثر من ١٠ أشخاص.\nأعلى %lu",self->namesArray.count]];
                }
            }
        }
        else
        {
            [self->_topTitle setTitle:@"Search"];
            [self->headerLabel setText:@""];
        }
        
        [self->_searchView setHidden:NO];
        
        [self.tableView reloadData];
        
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+self->tableViewHight, self.tableView.frame.size.width, self->tableViewHight)];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:0
                         animations:^{
                             [self->_searchView setFrame:CGRectMake(self->_searchView.frame.origin.x, self->_searchView.frame.origin.y-self->_searchView.frame.size.height,self->_searchView.frame.size.width, self->_searchView.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             if (self->namesArray.count == 0)
                             {
                                 [self showNoResults];
                                 [self hideLoading];
                             }
                             
                             [UIView animateWithDuration:0.2 delay:0.0 options:0
                                              animations:^{
                                                  [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-self->tableViewHight, self.tableView.frame.size.width, self->tableViewHight)];
                                                  
                                              }
                                              completion:^(BOOL finished) {
                                                  [self addResultsToLog];
                                                  [self hideLoading];
                                                  [self.interstitial presentFromRootViewController:self];
                                              }];
                             [UIView commitAnimations];
                         }];
        [UIView commitAnimations];
    });
}

-(void)showNoResults
{
    [_noResultsImg setFrame:CGRectMake(_noResultsImg.frame.origin.x, _noResultsImg.frame.origin.y+500, _noResultsImg.frame.size.width, _noResultsImg.frame.size.height)];
    
    [_noResultsLabel setFrame:CGRectMake(_noResultsLabel.frame.origin.x, _noResultsLabel.frame.origin.y+500, _noResultsLabel.frame.size.width, _noResultsLabel.frame.size.height)];
    
    [_noResultsImg setHidden:NO];
    [_noResultsLabel setHidden:NO];
    [self.tableView setHidden:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [_noResultsImg setFrame:CGRectMake(_noResultsImg.frame.origin.x, _noResultsImg.frame.origin.y-500, _noResultsImg.frame.size.width, _noResultsImg.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 delay:0.0 options:0
                                          animations:^{
                                              [_noResultsLabel setFrame:CGRectMake(_noResultsLabel.frame.origin.x, _noResultsLabel.frame.origin.y-500, _noResultsLabel.frame.size.width, _noResultsLabel.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              //
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

-(void)hideNoResults
{
    [_noResultsImg setHidden:YES];
    [_noResultsLabel setHidden:YES];
    [self.tableView setHidden:NO];
    
    NSLog(@"tableView: %f",self.tableView.frame.origin.x);
    NSLog(@"tableView: %f",self.tableView.frame.origin.y);
    NSLog(@"tableView: %f",self.tableView.frame.size.width);
    NSLog(@"tableView: %f",self.tableView.frame.size.height);
}

-(void)hideSearchView
{
    isOnSearch = NO;
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [_searchView setFrame:CGRectMake(_searchView.frame.origin.x, _searchView.frame.origin.y+_searchView.frame.size.height, _searchView.frame.size.width, _searchView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_searchView setHidden:YES];
                         [_searchView setFrame:CGRectMake(_searchView.frame.origin.x, _searchView.frame.origin.y-_searchView.frame.size.height, _searchView.frame.size.width, _searchView.frame.size.height)];
                         [_searchTextField becomeFirstResponder];
                         
                         if (checkNeeded)
                         {
                             checkNeeded = NO;
                             [self checkClipBoard];
                         }
                     }];
    [UIView commitAnimations];
}

- (IBAction)selectSearchMethod:(id)sender {
    NSString*countryCode = ([Utils isVpnActive]) ? @"us" : @"kw";
    if([countryCode isEqualToString:@"us"]) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isNumberSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self changeSearchMethod];
}

-(void)changeSearchMethod
{
    [_tipImg setHidden:YES];
    [_searchTextField setText:@""];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNumberSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)
                               forView:_selectButton cache:YES];
        [UIView commitAnimations];
        
        [_selectButton setImage:[UIImage imageNamed:@"name-search-icon.png"] forState:UIControlStateNormal];
        
        _searchTextField.placeholder = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"searchName"];
        
        [_searchTextField setKeyboardType:UIKeyboardTypeDefault];
        
        _searchTextField.inputAccessoryView = nil;
        
        [_searchTextField setReturnKeyType:UIReturnKeySearch];
        
        [_searchTextField resignFirstResponder];
        [_searchTextField becomeFirstResponder];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNumberSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromLeft)
                               forView:_selectButton cache:YES];
        [UIView commitAnimations];
        
        [_selectButton setImage:[UIImage imageNamed:@"number-search-icon.png"] forState:UIControlStateNormal];
        
        _searchTextField.placeholder = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"searchPhone"];
        
        [_searchTextField setKeyboardType:UIKeyboardTypePhonePad];
        
        _searchTextField.inputAccessoryView = _searchToolbar;
        
        [_searchTextField resignFirstResponder];
        [_searchTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _searchTextField)
    {
        [self startSearch:nil];
    }
    
    return YES;
}

-(void)checkSearchMethod
{
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [_selectButton setFrame:CGRectMake(_selectButton.frame.origin.x, _selectButton.frame.origin.y-20, _selectButton.frame.size.width, _selectButton.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 delay:0.0 options:0
                                          animations:^{
                                              if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
                                              {
                                                  [_tipImg setImage:[UIImage imageNamed:@"number-tip-icon.png"]];
                                                  [_selectButton setImage:[UIImage imageNamed:@"number-search-icon.png"] forState:UIControlStateNormal];
                                                  _searchTextField.placeholder = @"بحث بالرقم";
                                                  [_searchTextField setKeyboardType:UIKeyboardTypePhonePad];
                                                  
                                                  _searchTextField.inputAccessoryView = _searchToolbar;
                                              }
                                              else
                                              {
                                                  [_tipImg setImage:[UIImage imageNamed:@"name-tip-icon.png"]];
                                                  [_selectButton setImage:[UIImage imageNamed:@"name-search-icon.png"] forState:UIControlStateNormal];
                                                  _searchTextField.placeholder = @"بحث بالإسم";
                                                  [_searchTextField setKeyboardType:UIKeyboardTypeDefault];
                                                  [_searchTextField setReturnKeyType:UIReturnKeySearch];
                                                  
                                                  _searchTextField.inputAccessoryView = nil;
                                              }
                                              
                                              
                                              
                                              [_selectButton setFrame:CGRectMake(_selectButton.frame.origin.x, _selectButton.frame.origin.y+20, _selectButton.frame.size.width, _selectButton.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tipDone"])
                                              {
                                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tipDone"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  
                                                  [_tipImg setCenter:_selectButton.center];
                                                  [_tipImg setHidden:NO];
                                              }
                                              isReady = YES;
                                              
                                              [_searchTextField becomeFirstResponder];
                                              
                                              if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
                                              {
                                                  selectButtonYfrm = _selectButton.frame.origin.y;
                                                  searchTextYfrm = _searchTextField.frame.origin.y;
                                                  searchButtonYfrm = _searchButton.frame.origin.y;
                                              }
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

- (IBAction)followInsta:(id)sender {
    [self closeFollowView:nil];
    
    [self performSelector:@selector(openFollow:) withObject:@"instagram" afterDelay:0.3];
}

- (IBAction)followTwitter:(id)sender {
    [self closeFollowView:nil];
    
    [self performSelector:@selector(openFollow:) withObject:@"twitter" afterDelay:0.3];
}

- (IBAction)followUs:(id)sender {
    [self showFollowView];
}

-(void)openFollow:(NSString*)theCase
{
    if ([theCase isEqualToString:@"twitter"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.tapbots.tweetbot3:///user_profile/MenoMotasel"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.tapbots.tweetbot3:///user_profile/MenoMotasel"]];
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/MenoMotasel"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/MenoMotasel"]];
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=MenoMotasel"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=MenoMotasel"]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/MenoMotasel"]];
        }
    }
    else
    {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=MenoMotasel"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://instagram.com/MenoMotasel"]];
        }
    }
}

-(void)showFollowView
{
    [_searchTextField resignFirstResponder];
    
    SADAHBlurView *blurView = [[SADAHBlurView alloc] initWithFrame:self.view.frame];
    
    [blurView setTag:397];
    [blurView setAlpha:0.0];
    
    [blurView setBlurRadius:10];
    [blurView setBlurEnabled:YES];
    
    [self.view addSubview:blurView];
    
    UIView *theBackgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    
    [theBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]];
    
    [theBackgroundView setTag:398];
    
    [theBackgroundView setAlpha:0.0];
    
    [self.view addSubview:theBackgroundView];
    
    [_followView setHidden:YES];
    
    [self.view addSubview:_followView];
    
    [_followView setCenter:self.view.center];
    
    [_followView setFrame:CGRectMake(_followView.frame.origin.x, _followView.frame.origin.y+self.view.frame.size.height, _followView.frame.size.width, _followView.frame.size.height)];
    
    [_followView setHidden:NO];
    
    _followView.transform=CGAffineTransformMakeRotation(M_PI / -4);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0
                     animations:^{
                         [blurView setAlpha:1.0];
                         [theBackgroundView setAlpha:1.0];
                         
                         _followView.transform=CGAffineTransformMakeRotation(0);
                         
                         [_followView setFrame:CGRectMake(_followView.frame.origin.x, _followView.frame.origin.y-self.view.frame.size.height, _followView.frame.size.width, _followView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
}

- (IBAction)closeFollowView:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:0
                     animations:^{
                         [[self.view viewWithTag:397] setAlpha:0.0];
                         [[self.view viewWithTag:398] setAlpha:0.0];
                         
                         _followView.transform=CGAffineTransformMakeRotation(0);
                         
                         [_followView setFrame:CGRectMake(_followView.frame.origin.x, _followView.frame.origin.y+self.view.frame.size.height, _followView.frame.size.width, _followView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [[self.view viewWithTag:397] removeFromSuperview];
                         [[self.view viewWithTag:398] removeFromSuperview];
                         
                         [_followView setFrame:CGRectMake(_followView.frame.origin.x, _followView.frame.origin.y-self.view.frame.size.height, _followView.frame.size.width, _followView.frame.size.height)];
                         
                         [_followView removeFromSuperview];
                         
                         [_searchTextField becomeFirstResponder];
                     }];
    [UIView commitAnimations];
}

-(void)checkClipBoard
{
    if (isOnSearch || isOutView)
    {
        checkNeeded = YES;
        return;
    }
    
    if(self.currentPhone && self.currentPhone.length > 0)
    {
        [self.searchTextField setText:self.currentPhone];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
        {
            [self changeSearchMethod];
            [self.searchTextField setText:self.currentPhone];
            [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.3];
        }
        else
        {
            [self startSearch:nil];
        }
        return;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isAuto"])return;
    
    if ([[[UIPasteboard generalPasteboard] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        return;
    }
   
    
    if ([[UIPasteboard generalPasteboard].string length] > 35)return;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSearchObject"] isEqualToString:[UIPasteboard generalPasteboard].string])return;
    
    [[NSUserDefaults standardUserDefaults] setObject:[UIPasteboard generalPasteboard].string forKey:@"lastSearchObject"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    isOnCheck = YES;
    
    [_searchTextField resignFirstResponder];
    
    if ([self isOnlyNumbers:[UIPasteboard generalPasteboard].string])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[@"Search for number" stringByAppendingFormat:@"%@",[UIPasteboard generalPasteboard].string],nil];
        [actionSheet setTag:14];
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[@"Search for name:" stringByAppendingFormat:@"%@",[UIPasteboard generalPasteboard].string],nil];
        [actionSheet setTag:15];
        [actionSheet showInView:self.view];
    }
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
    [self performSelector:@selector(reseizeBanner) withObject:nil afterDelay:1.5];
}

-(void)reseizeBanner
{
    bannerView.center = _adHolderView.center;
}

-(void)searchForName:(BOOL)isName
{
    if (isName)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
        {
            [self changeSearchMethod];
            _searchTextField.text = [UIPasteboard generalPasteboard].string;
            [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.3];
        }
        else
        {
            _searchTextField.text = [UIPasteboard generalPasteboard].string;
            [self startSearch:nil];
        }
    }
    else
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
        {
            [self changeSearchMethod];
            _searchTextField.text = [UIPasteboard generalPasteboard].string;
            [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.3];
        }
        else
        {
            _searchTextField.text = [UIPasteboard generalPasteboard].string;
            [self startSearch:nil];
        }
    }
}

-(void)showHelp
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [_searchTextField resignFirstResponder];
    });
    [self performSegueWithIdentifier:@"helpSeg" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [namesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"searchCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    cell.selectedBackgroundView = backView;
    
    [(UILabel*)[cell viewWithTag:1]setText:[namesArray objectAtIndex:indexPath.row]];
    [(UILabel*)[cell viewWithTag:2]setText:[numbersArray objectAtIndex:indexPath.row]];
    
    
    if ([self isFavName:[namesArray objectAtIndex:indexPath.row] andNumber:[numbersArray objectAtIndex:indexPath.row]])
    {
        [(UIImageView*)[cell viewWithTag:3]setImage:[UIImage imageNamed:@"fav-on-icon.png"]];
        [(UIImageView*)[cell viewWithTag:3]setHighlightedImage:[UIImage imageNamed:@"fav-on-icon-highlighted.png"]];
    }
    else
    {
        [(UIImageView*)[cell viewWithTag:3]setImage:[UIImage imageNamed:@"fav-off-icon.png"]];
        [(UIImageView*)[cell viewWithTag:3]setHighlightedImage:[UIImage imageNamed:@"fav-off-icon-highlighted.png"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    theRow = indexPath.row;
    
    if ([self isFavName:[namesArray objectAtIndex:indexPath.row] andNumber:[numbersArray objectAtIndex:indexPath.row]])
    {
        //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:@"حذف من المفضلة" otherButtonTitles:@"إتصال",@"نسخ الإسم",@"نسخ الرقم",nil];
        //[actionSheet setTag:11];
        //[actionSheet showInView:self.view];
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"optionsHeader"]
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* copyNumberButton = [UIAlertAction
                                   actionWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"optionsCopyNumber"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [[UIPasteboard generalPasteboard]setString:[self->numbersArray objectAtIndex:self->theRow]];
                                       [KSToastView ks_showToast:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"optionsCopyNumberMessage"]];
                                   }];
        
        if (@available(iOS 11, *)) {
          
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockNumber"]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            dispatch_async(dispatch_get_main_queue(), ^(){
                                                
                                                NSMutableArray* blockedBefore = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"blockedBefore"]];
                                                
                                                if([blockedBefore containsObject:[self->numbersArray objectAtIndex:self->theRow]])
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^(){
                                                        UIAlertController * alert = [UIAlertController
                                                                                     alertControllerWithTitle:@"Opps"
                                                                                     message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockedBefore"]
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction* noButton = [UIAlertAction
                                                                                   actionWithTitle:@"OK"
                                                                                   style:UIAlertActionStyleCancel
                                                                                   handler:^(UIAlertAction * action) {}];
                                                        
                                                        [alert addAction:noButton];
                                                        
                                                        [self presentViewController:alert animated:YES completion:nil];
                                                    });
                                                    return;
                                                }
                                                
                                                NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                                                              initWithSuiteName:@"group.group2.meno.motasel.app"];
                                                [myDefaults setObject:[NSString stringWithFormat:@"%@%@",@"965",[self->numbersArray objectAtIndex:self->theRow]] forKey:@"block"];
                                                [myDefaults synchronize];
                                                [[CXCallDirectoryManager sharedInstance]reloadExtensionWithIdentifier:@"meno.motasel.app.spammers" completionHandler:^(NSError * _Nullable error) {
                                                    if(error)
                                                    {
                                                        if(error.code == 6)
                                                        {
                                                            NSLog(@"%@",error.description);
                                                            UIAlertController * alert = [UIAlertController
                                                                                         alertControllerWithTitle:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"callEnableHeader"]
                                                                                         message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"callEnableMessage"]
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction* yesButton = [UIAlertAction
                                                                                       actionWithTitle:@"OK"
                                                                                       style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * action) {
                                                                                           dispatch_async(dispatch_get_main_queue(), ^(){
                                                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                                           });
                                                                                       }];
                                                            UIAlertAction* noButton = [UIAlertAction
                                                                                       actionWithTitle:@"إلغاء"
                                                                                       style:UIAlertActionStyleCancel
                                                                                       handler:^(UIAlertAction * action) {}];
                                                            
                                                            [alert addAction:yesButton];
                                                            [alert addAction:noButton];
                                                            
                                                            [self presentViewController:alert animated:YES completion:nil];
                                                        }else if(error.code == 19)
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^(){
                                                                UIAlertController * alert = [UIAlertController
                                                                                             alertControllerWithTitle:@"Opps"
                                                                                             message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockedBefore"]
                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                                UIAlertAction* noButton = [UIAlertAction
                                                                                           actionWithTitle:@"OK"
                                                                                           style:UIAlertActionStyleCancel
                                                                                           handler:^(UIAlertAction * action) {}];
                                                                
                                                                [alert addAction:noButton];
                                                                
                                                                [self presentViewController:alert animated:YES completion:nil];
                                                            });
                                                        }
                                                    }else
                                                    {
                                                        dispatch_async(dispatch_get_main_queue(), ^(){
                                                            UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
                                                            [blockedBefore addObject: [self->numbersArray objectAtIndex:self->theRow]];
                                                            [[NSUserDefaults standardUserDefaults]setObject:blockedBefore forKey:@"blockedBefore"];
                                                            [[NSUserDefaults standardUserDefaults]synchronize];
                                                            
                                                            UIAlertController * alert = [UIAlertController
                                                                                         alertControllerWithTitle:@"Done"
                                                                                         message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockedDone"]
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction* noButton = [UIAlertAction
                                                                                       actionWithTitle:@"OK"
                                                                                       style:UIAlertActionStyleCancel
                                                                                       handler:^(UIAlertAction * action) {}];
                                                            
                                                            [alert addAction:noButton];
                                                            
                                                            [self presentViewController:alert animated:YES completion:nil];
                                                            int currentCoins = [[store stringForKey:@"coins"] intValue];
                                                            currentCoins -= 20;
                                                            [store setString:[NSString stringWithFormat:@"%i",currentCoins] forKey:@"coins"];
                                                            [store synchronize];
                                                            [[[self.ref2 child:@"users"] child:[store stringForKey:@"userID"]] setValue:@{@"coins":[NSString stringWithFormat:@"%i",currentCoins]} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                                                            }];
                                                        });
                                                    }
                                                }];
                                            });
                                        }];
            
            [alert addAction:yesButton];
        }
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"إلغاء"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:copyNumberButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (actionSheet.tag == 13 || actionSheet.tag == 14  || actionSheet.tag == 15)
    {
        if (actionSheet.cancelButtonIndex == buttonIndex)
        {
            [_searchTextField becomeFirstResponder];
        }
    }
    else
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
    if (actionSheet.tag == 14 || actionSheet.tag == 15)
    {
        isOnCheck = NO;
    }
    
    switch (buttonIndex) {
        case 0:
        {
            if (actionSheet.tag == 11)
            {
                [self performSelector:@selector(actionRemoveFromFav) withObject:nil afterDelay:0.3];
            }
            else if (actionSheet.tag == 12)
            {
                [self performSelector:@selector(actionAddToFav) withObject:nil afterDelay:0.3];
            }
            else if (actionSheet.tag == 13)
            {
                [self showHelp];
            }
            else if (actionSheet.tag == 14)
            {
                [self searchForName:NO];
            }
            else if (actionSheet.tag == 15)
            {
                [self searchForName:YES];
            }
        }
            break;
        case 1:
        {
            if (actionSheet.tag == 11 || actionSheet.tag == 12)
            {
                [self performSelector:@selector(callContact) withObject:nil afterDelay:0.3];
            }
            else if (actionSheet.tag == 13)
            {
                [self performSelector:@selector(contactUs) withObject:nil afterDelay:0.3];
            }
        }
            break;
        case 2:
        {
            if (actionSheet.tag == 11 || actionSheet.tag == 12)
            {
                [self performSelector:@selector(copName) withObject:nil afterDelay:0.3];
            }
            else if (actionSheet.tag == 13)
            {
                [self performSegueWithIdentifier:@"aboutSeg" sender:self];
            }
        }
            break;
        case 3:
        {
            if (actionSheet.tag == 11 || actionSheet.tag == 12)
            {
                [self performSelector:@selector(copNumber) withObject:nil afterDelay:0.3];
            }
        }
    }
}

-(void)callContact
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingFormat:@"%@",[numbersArray objectAtIndex:theRow]]]];
}

-(void)contactUs
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        [picker setToRecipients:[NSArray arrayWithObject:@"menomotasel@gmail.com"]];
        
        [picker setMessageBody:[@"\n\n\n\n\n\n\n\n" stringByAppendingFormat:@"%@\nالمعلومات التالية تساعدنا في تحديد المشاكل بشكل أدق:\n----------\nIOS: %@\nDevice: %@\nApp Version: %.1f",@"اذا كنت من عملاء ال VIP، برجاء كتابة رقمك. و إذا كنت تريد التبليغ عن إسم يرجاء كتابه الاسم و الرقم",[[UIDevice currentDevice] systemVersion],[self theDeviceType],[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue]] isHTML:NO];
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:menomotasel@gmail.com"] options:@{}
                                 completionHandler:^(BOOL success) {
                                     if (success)
                                     {
                                         NSLog(@"success");
                                     }
                                     else
                                     {
                                         NSLog(@"can't open");
                                         UIAlertController * alert = [UIAlertController
                                                                      alertControllerWithTitle:@"الدعم الفني"
                                                                      message:@"يرجى مراسلة الدعم الفني على الايميل:\n menomotasel@gmail.com"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         
                                         
                                         UIAlertAction* yesButton = [UIAlertAction
                                                                     actionWithTitle:@"نسخ الإيميل"
                                                                     style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         [[UIPasteboard generalPasteboard] setString:@"menomotasel@gmail.com"];
                                                                     }];
                                         
                                         UIAlertAction* noButton = [UIAlertAction
                                                                    actionWithTitle:@"إلغاء"
                                                                    style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                        //
                                                                    }];
                                         
                                         [alert addAction:yesButton];
                                         [alert addAction:noButton];
                                         
                                         [self presentViewController:alert animated:YES completion:nil];
                                     }
                                 }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) theDeviceType
{
    NSString *platform;
    struct utsname systemInfo;
    uname(&systemInfo);
    platform = [NSString stringWithCString:systemInfo.machine
                                  encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (isOutView || isOnCheck || isOnSearch || !isReady || ![[NSUserDefaults standardUserDefaults] boolForKey:@"isShake"])return;
    
    if(event.type == UIEventSubtypeMotionShake)
    {
        [self doVibrate];
        
        if ([[[UIPasteboard generalPasteboard] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self showGhostMsg:@"قم بنسخ رقم أو إسم أولاً." isError:YES];
            return;
        }
        
        if ([self isOnlyNumbers:[UIPasteboard generalPasteboard].string])
        {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
            {
                [self changeSearchMethod];
                _searchTextField.text = [UIPasteboard generalPasteboard].string;
                [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.3];
            }
            else
            {
                _searchTextField.text = [UIPasteboard generalPasteboard].string;
                [self startSearch:nil];
            }
        }
        else
        {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNumberSearch"])
            {
                [self changeSearchMethod];
                _searchTextField.text = [UIPasteboard generalPasteboard].string;
                [self performSelector:@selector(startSearch:) withObject:nil afterDelay:0.3];
            }
            else
            {
                _searchTextField.text = [UIPasteboard generalPasteboard].string;
                [self startSearch:nil];
            }
        }
    }
}

- (BOOL)isOnlyNumbers:(NSString *)text
{
    NSCharacterSet* notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789 +"] invertedSet];
    
    if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)actionAddToFav
{
    [self addToFav:[namesArray objectAtIndex:theRow] andNumber:[numbersArray objectAtIndex:theRow]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:theRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void)actionRemoveFromFav
{
    [self removeFromFav:[namesArray objectAtIndex:theRow] andNumber:[numbersArray objectAtIndex:theRow]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:theRow inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void)copName
{
    [[UIPasteboard generalPasteboard] setString:[namesArray objectAtIndex:theRow]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[UIPasteboard generalPasteboard].string forKey:@"lastSearchObject"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showGhostMsg:@"تم نسخ الإسم" isError:NO];
}

-(void)copNumber
{
    [[UIPasteboard generalPasteboard] setString:[numbersArray objectAtIndex:theRow]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[UIPasteboard generalPasteboard].string forKey:@"lastSearchObject"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showGhostMsg:@"تم نسخ الرقم" isError:NO];
}

-(void)showGhostMsg:(NSString*)theMsg isError:(BOOL)isError
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Attention"
                                 message:theMsg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"إلغاء"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   //
                               }];
    
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setTopMsgBack
{
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [_topMsgLabel setFrame:CGRectMake(_topMsgLabel.frame.origin.x, -_topMsgLabel.frame.size.height, _topMsgLabel.frame.size.width, _topMsgLabel.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_topMsgLabel setHidden:YES];
                     }];
    [UIView commitAnimations];
}

-(BOOL)isFavName:(NSString*)theName andNumber:(NSString*)theNumber
{
    if ([favArray containsObject:[theName stringByAppendingFormat:@"-*3&^*4-%@",theNumber]])
    {
        return YES;
    }
    
    return NO;
}

-(void)addToFav:(NSString*)theName andNumber:(NSString*)theNumber
{
    [favArray addObject:[theName stringByAppendingFormat:@"-*3&^*4-%@",theNumber]];
    
    [[NSUserDefaults standardUserDefaults] setObject:favArray forKey:@"savedFavArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeFromFav:(NSString*)theName andNumber:(NSString*)theNumber
{
    [favArray removeObject:[theName stringByAppendingFormat:@"-*3&^*4-%@",theNumber]];
    
    [[NSUserDefaults standardUserDefaults] setObject:favArray forKey:@"savedFavArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    //[ad presentFromRootViewController:self];
}
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self performSelector:@selector(reseizeBanner) withObject:nil afterDelay:1.5];
    NSLog(@"interstitialDidDismissScreen");
}
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@",error.description);
}

-(void)addActivityView
{
    for (UIView *view in [self view].subviews)
    {
        if (view.tag == 383)
        {
            [view removeFromSuperview];
            break;
        }
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    
    backView.backgroundColor = [UIColor blackColor];
    
    [backView setAlpha:0.0];
    
    [backView setTag:383];
    
    [[self view] addSubview:backView];
    
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [backView addSubview:actView];
    
    actView.center = backView.center;
    
    [actView startAnimating];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [backView setAlpha:0.8];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView commitAnimations];
}

-(void)removeActivityView
{
    [UIView animateWithDuration:0.2 delay:0.0 options:0
                     animations:^{
                         [[[self view] viewWithTag:383] setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [[[self view] viewWithTag:383] removeFromSuperview];
                     }];
    
    [UIView commitAnimations];
}

- (IBAction)deleteNameClicked:(id)sender {
    
    [_searchTextField resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"delNumClicked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_buyButton.imageView stopAnimating];
    
    
    if([blockMethod isEqualToString:@"1"])
    {
        [self addActivityView];
        
        // [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent": @"iPhone CFNetwork Darwin IchIJe" }];
        
        NSString *userID = @"base";
        [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        ;
        [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSString* baseURL = snapshot.value;
            if(baseURL && baseURL.length > 0)
            {
                [[NSUserDefaults standardUserDefaults]setObject:baseURL forKey:@"base"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self removeActivityView];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockLabel"] message:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockMessage"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"numberBlock"];
                    textField.keyboardType = UIKeyboardTypePhonePad;
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* phone = [[alertController textFields][0] text];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٠" withString:@"0"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"١" withString:@"1"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٢" withString:@"2"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٣" withString:@"3"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٤" withString:@"4"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٥" withString:@"5"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٦" withString:@"6"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٧" withString:@"7"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٨" withString:@"8"];
                    phone = [phone stringByReplacingOccurrencesOfString:@"٩" withString:@"9"];
                    //[self bll:phone];
                    
                    [self showLoading];
                    
                    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result, NSError * _Nullable error) {
                        NSString* token = @"";
                        if(result && result.token && !error) {
                            token = result.token;
                        }
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            NSLog(@"%@",[NSString stringWithFormat:@"%@/verify.php?to=%@&x=%li",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],phone,random()]);
                            
                            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/verify.php?to=%@&x=%li&token=%@&motasel=1",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],phone,random(),token]]];
                            
                            NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                [self removeActivityView];
                                [self hideLoading];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Verification Code" message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"verificationCode"] preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                    textField.placeholder = @"Activation code";
                                    textField.keyboardType = UIKeyboardTypeNumberPad;
                                }];
                                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    if([[[alertController textFields][0] text] isEqualToString:result])
                                    {
                                        [self bll:phone];
                                        
                                    }else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^(){
                                            [self removeActivityView];
                                            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"عفواً" message:@"كود التفعيل غير صحيح" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                        });
                                    }
                                }];
                                [alertController addAction:confirmAction];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    NSLog(@"Canelled");
                                }];
                                [alertController addAction:cancelAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            });
                        });
                    }];
                }];
                [alertController addAction:confirmAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"Canelled");
                    [self removeActivityView];
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }];
    }else if([blockMethod isEqualToString:@"2"])
    {
        if(blockURL)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:blockURL]];
        }
    }
}


-(void)bll:(NSString*)ph
{
    NSInteger saltNumber = arc4random() % 100;
    NSInteger saltNumber2 = arc4random() % 100;
    NSInteger saltNumber3 = arc4random() % 100;
    NSInteger saltNumber4 = arc4random() % 100;
    NSInteger saltNumber5 = arc4random() % 100;
    NSString* limit = @"60";
    NSString *encStr = [AESTool encryptData:[NSString stringWithFormat:@"%literm=%@&%liopt=%@&%lilimit=%@&%lislt=%li",(long)saltNumber,ph,(long)saltNumber2,@"1",(long)saltNumber3,limit,(long)saltNumber4,(long)saltNumber5] withKey:@"9ONO45Rq1S68nLCm"];
    
    encStr = [encStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    
    NSString* vipPurchaseTitle = [[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"vipMessage"];
    
    if(self->pointsProducts)
    {
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        formatter.locale = self->pointsProducts.priceLocale;
        
        vipPurchaseTitle = [vipPurchaseTitle stringByAppendingFormat:@" بـ %@",[formatter stringFromNumber:self->pointsProducts.price]];
    }
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"vipHeader"]
                                 message:vipPurchaseTitle
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"vipOK"]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self vip:encStr];
                                }];
    
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"cancel"]
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   [KSToastView ks_showToast:@"للطلب عادي، سيتم التنفيذ بسياسة الدور خلال ٣٠ يوم عمل تواصل معنا من خلال الدعم الفني في صفحه الاعدادات للتنفيذ بعد ٣٠ يوم عمل حسب الدور. للتنفيذ السريع و ال VIP يمكنك إعادة الطلب و إختيار باقة الدعم ال VIP" duration:10.0];
                               }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)vip:(NSString*)cd
{
    [KSToastView ks_showToast:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"needCoins"]];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self addActivityView];
        [[RMStore defaultStore] addPayment:@"meno.motasel.app.100" success:^(SKPaymentTransaction *transaction) {
            if(transaction.error)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"تم" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeActivityView];
                    [alert show];
                });
                
            }else
            {
                //UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    int frst = 13;//[self chk1];
                    
                    if(frst == 13)
                    {
                        int x = 12;//[self begin];
                        if(x == 12)
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                
                                UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
                                [self req:YES cd:cd];
                                [KSToastView ks_showToast:[NSString stringWithFormat:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"newCoins"],[store stringForKey:@"coins"]]];
                                [self removeActivityView];
                                
                            });
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                [self removeActivityView];
                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا لك" message:@"ِError-1" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                            });
                        }
                    }else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [self removeActivityView];
                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا لك" message:@"Error-2" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        });
                    }
                });
            }
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            NSString* er = @"error";
            if(error)
            {
                er = [error debugDescription];
            }
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:[NSString stringWithFormat:@"حدث الخطأ التالي : %@ رجاء مراسلة الدعم الفني",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeActivityView];
                [alert show];
            });
        }];
    });
}

-(void)req:(BOOL)active cd:(NSString*)cd
{
    [self addActivityView];
    NSString* cd2 = cd;
    cd2 = [cd2 stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    cd2 = [AESTool decryptData:cd2 withKey:@"9ONO45Rq1S68nLCm"];
    
    [FIRAnalytics logEventWithName:kFIREventAddPaymentInfo
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"Block : %@",cd2],
                                     kFIRParameterItemName:[NSString stringWithFormat:@"Block : %@",cd2],
                                     kFIRParameterContentType:@"Block"
                                     }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"]);
        NSData* data = [NSData data];
        if(!active)
        {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/askForBlock3.php?code=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],cd]]];
        }else
        {
            [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/askForBlockv.php?code=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],cd]]];
        }
        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        result = [AESTool decryptData:result withKey:@"9ONO45Rq1S68nLCm"];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSLog(@"%@",result);
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Done" message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockConfirm"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self removeActivityView];
            if(!active)
            {
                [KSToastView ks_showToast:@"تم عمل طلب عادي، سيتم التنفيذ بسياسة الدور خلال ٣٠ يوم عمل. للتنفيذ السريع و ال VIP يمكنك إعادة الطلب و إختيار باقة الدعم ال VIP" duration:10.0];
            }else
            {
                [KSToastView ks_showToast:@"شكرا لتفعيل خدمة الدعم ال VIP، احد موظفينا سيتفرغ لتلبيه طلبك خلال ساعات من الان بحد أقصى ٢٤ ساعة. و برجاء المراسله اذا هناك أي تأخير في الدعم ال VIP" duration:10.0];
            }
        });
    });
}

@end
