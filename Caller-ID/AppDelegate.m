//
//  AppDelegate.m
//  Caller-ID
//
//  Created by Hussein Jouhar on 8/1/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import "AppDelegate.h"
@import Firebase;
@import UserNotifications;
@import GoogleMobileAds;
#import "UICKeyChainStore.h"
#import "AESTool.h"
#import "UIViewController+iOS13Fixes.h"
#import  <FirebaseMessaging.h>
#import <KSToastView/KSToastView.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>
@property(strong,nonatomic) FIRDatabaseReference* ref;
@end

static NSString *kAppKey = @"57ad9eb8a3fc27242a8b46ea";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationSupportsShakeToEdit = YES;
    [UIViewController load];
    
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.group2.meno.motasel.app"];
    [myDefaults setObject:@"" forKey:@"block"];
    
    //[[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"lang"];
    
    [FIRApp configure];
    
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    self.ref = [[FIRDatabase databaseWithURL:@"https://menomotaselq8-e2d58.firebaseio.com/"] reference];
    /*
     #warning OSAMA BLOCK
     NSString* phone = @"90064548";
     NSInteger saltNumber = arc4random() % 100;
     NSInteger saltNumber2 = arc4random() % 100;
     NSInteger saltNumber3 = arc4random() % 100;
     NSInteger saltNumber4 = arc4random() % 100;
     NSInteger saltNumber5 = arc4random() % 100;
     NSString* limit = @"60";
     NSString *encStr = [AESTool encryptData:[NSString stringWithFormat:@"%literm=%@&%liopt=%@&%lilimit=%@&%lislt=%li",(long)saltNumber,phone,(long)saltNumber2,@"1",(long)saltNumber3,limit,(long)saltNumber4,(long)saltNumber5] withKey:@"9ONO45Rq1S68nLCm"];
     
     encStr = [encStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
     */
    
    if(![store stringForKey:@"userID"])
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"blockedBefore"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [store setString:@"500" forKey:@"coins"];
        [store synchronize];
        
        NSArray* coins = [@"3,1,10,20,100" componentsSeparatedByString:@","];
        [store setString:coins[0] forKey:@"nameCoins"];
        [store setString:coins[1] forKey:@"phoneCoins"];
        [store setString:coins[2] forKey:@"spamCoins"];
        [store setString:coins[3] forKey:@"blockCoins"];
        [store setString:coins[4] forKey:@"supportCoins"];
        [store synchronize];
        
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"af24cb21a0ae2fabf678926038c589ed" ];
        
        NSString* genID = [self randomStringWithLength:10];
        
        [[[self.ref child:@"users"] child:genID] setValue:@{@"coins":@"500"} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if(!error)
            {
                [store setString:genID forKey:@"userID"];
                [store synchronize];
            }
        }];
        
    }else
    {
        [[[self.ref child:@"users"] child:[store stringForKey:@"userID"]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [store setString:[snapshot.value objectForKey:@"coins"] forKey:@"coins"];
            [store synchronize];
        }];
    }
    
    
    [FIRMessaging messaging].delegate = self;
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //[GADMobileAds configureWithApplicationID:@"ca-app-pub-2433238124854818~9739098699"];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions =
    UNAuthorizationOptionAlert
    | UNAuthorizationOptionSound
    | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    [application registerForRemoteNotifications];
    
    
    
    
    return YES;
}



-(NSString *) randomStringWithLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    UNAuthorizationOptions authOptions =
    UNAuthorizationOptionAlert
    | UNAuthorizationOptionSound
    | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
    
    /*let center = UNUserNotificationCenter.current()
     center.requestAuthorization(options: [.badge, .alert, .sound]) {
     (granted, error) in
     if granted {
     DispatchQueue.main.async {
     UIApplication.shared.registerForRemoteNotifications()
     }
     } else {
     //print("APNS Registration failed")
     //print("Error: \(String(describing: error?.localizedDescription))")
     }
     }*/
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"فشل في الحصول على رمز، الخطأ: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    if([userInfo objectForKey:@"aps"]) {
        NSDictionary* aps = [userInfo objectForKey:@"aps"];
        if([aps objectForKey:@"alert"]) {
            NSDictionary* alert = [aps objectForKey:@"alert"];
            if([alert objectForKey:@"title"] && [alert objectForKey:@"body"]) {
                
                [KSToastView ks_showToast:[NSString stringWithFormat:@"%@\n%@",[alert objectForKey:@"title"],[alert objectForKey:@"body"]] duration:6];
            }
        }
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
}




@end
