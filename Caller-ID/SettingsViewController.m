//
//  SettingsViewController.m
//  Caller-ID
//
//  Created by Hussein Jouhar on 3/16/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "UICKeyChainStore.h"
#import <KSToastView/KSToastView.h>
#import <StoreKit/StoreKit.h>
#import <RMStore/RMStore.h>
@import Firebase;


@interface SettingsViewController ()
@property(strong,nonatomic) FIRDatabaseReference* ref;
@end

@implementation SettingsViewController
{
    SKProduct* pointsProducts;
    __weak IBOutlet UIActivityIndicatorView *loading;
    __weak IBOutlet UIActivityIndicatorView *syncLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase databaseWithURL:@"https://menomotaselq8-e2d58.firebaseio.com/"] reference];
    
    [[RMStore defaultStore]requestProducts:[NSSet setWithObjects:@"meno.motasel.app.100", nil] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        self->pointsProducts = [products objectAtIndex:0];
        NSLog(@"%@",self->pointsProducts.localizedTitle);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    UIView *backView1 = [[UIView alloc] init];
    
    backView1.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView2 = [[UIView alloc] init];
    
    backView2.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView3 = [[UIView alloc] init];
    
    backView3.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView4 = [[UIView alloc] init];
    
    backView4.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView5 = [[UIView alloc] init];
    
    backView5.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView6 = [[UIView alloc] init];
    
    backView6.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    _cell1.selectedBackgroundView = backView1;
    _cell2.selectedBackgroundView = backView2;
    _cell3.selectedBackgroundView = backView3;
    _cell4.selectedBackgroundView = backView4;
    _cell5.selectedBackgroundView = backView5;
    _cell6.selectedBackgroundView = backView6;
    
    [_shakeSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isShake"]];
    
    [_autoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isAuto"]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:16]}];
    
    [_supportIcon setHighlightedImage:[self tintImage:_supportIcon.image withColor:[UIColor whiteColor]]];
    
    [_rateIcon setHighlightedImage:[self tintImage:_rateIcon.image withColor:[UIColor whiteColor]]];
    
    [_aboutIcon setHighlightedImage:[self tintImage:_aboutIcon.image withColor:[UIColor whiteColor]]];
    
    [_helpIcon setHighlightedImage:[self tintImage:_helpIcon.image withColor:[UIColor whiteColor]]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)shakeOnOff:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_shakeSwitch.isOn forKey:@"isShake"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)autoOnOff:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_autoSwitch.isOn forKey:@"isAuto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (UIImage *)tintImage:(UIImage *)baseImage withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(baseImage.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(context, 0, baseImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, baseImage.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)return 2;
    if (section == 1)return 5;
    
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    lbl.textAlignment = NSTextAlignmentRight;
    
    if (section == 0)
    {
        lbl.text = @"  عام";
    }
    else if (section == 1)
    {
        lbl.text = @"  المزيد";
    }
    
    [lbl setBackgroundColor:self.tableView.backgroundColor];
    [lbl setFont:[UIFont fontWithName:@"DroidArabicKufi" size:12.0]];
    [lbl setTextColor:[UIColor colorWithRed:157.0/255 green:157.0/255 blue:160.0/255 alpha:1.0]];
    
    return lbl;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-30, 50)];
    
    footerLabel.backgroundColor = [UIColor clearColor];
    
    footerLabel.textColor = [UIColor colorWithRed:157.0/255 green:157.0/255 blue:160.0/255 alpha:1.0];
    
    footerLabel.numberOfLines = 4;
    
    [footerLabel setTextAlignment:1];
    
    footerLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:12];
    
    if (section == 0)
    {
        footerLabel.text = @"عند تفعيل اللصق التلقائي سيقوم التطبيق بسؤالك إذا كنت تريد البحث عن النص الذي قمت بنسخه.";
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    [footerView addSubview:footerLabel];
    
    footerLabel.center = footerView.center;
    
    return footerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        [self contactUs];
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        [SKStoreReviewController requestReview];
    }else if (indexPath.section == 1 && indexPath.row == 3)
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        
        UIApplication *application = [UIApplication sharedApplication];
        
        [application openURL:[NSURL URLWithString:@"https://termsfeed.com/privacy-policy/41d2289878eba1d5547ca26810ea424d"] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    else if (indexPath.section == 1 && indexPath.row == 45)
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        [self syncCoins];
    }
}

-(void)syncCoins
{
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Sync your coins!?"
                                 message:@"We believe that a single user should have his purchases in whatever devices he has with no limits!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* getButton = [UIAlertAction
                                actionWithTitle:@"Get my coins from other device"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter the ID" message:@"Get the ID for syncing from the original device and paste it here" preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                        textField.placeholder = @"User ID";
                                    }];
                                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Sync" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                            NSString* userID = [alertController textFields][0].text;
                                        [[[self.ref child:@"users"] child:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                            @try {
                                                if(snapshot.value && [snapshot.value objectForKey:@"coins"])
                                                {
                                                    [store setString:[snapshot.value objectForKey:@"coins"] forKey:@"coins"];
                                                    [store setString:userID forKey:@"userID"];
                                                    [store synchronize];
                                                    dispatch_async(dispatch_get_main_queue(), ^(){
                                                        [KSToastView ks_showToast:[NSString stringWithFormat:@"Your new coins :%@",[snapshot.value objectForKey:@"coins"]]];
                                                    });
                                                }
                                            } @catch (NSException *exception) {
                                                dispatch_async(dispatch_get_main_queue(), ^(){
                                                    [KSToastView ks_showToast:@"The user id entered is wrong. Please try again"];
                                                });
                                            }
                                        }];
                                    }];
                                    
                                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"إغلاق" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        NSLog(@"Canelled");
                                    }];
                                    
                                    [alertController addAction:confirmAction];
                                    [alertController addAction:cancelAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                }];
    
    
    UIAlertAction* writeButton = [UIAlertAction
                                actionWithTitle:@"Share my coins to other device"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    UIAlertController * alert = [UIAlertController
                                                                 alertControllerWithTitle:@"Share your coins"
                                                                 message:[NSString stringWithFormat:@"Please give this ID to the other user : %@. Please note that when he uses the coins your coins will be reduced as well.",[store stringForKey:@"userID"]]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction* copyButton = [UIAlertAction
                                                                actionWithTitle:@"Copy my ID"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                                                                    [[UIPasteboard generalPasteboard] setString:[store stringForKey:@"userID"]];
                                                                }];
                                    UIAlertAction* cancelButton = [UIAlertAction
                                                                   actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction * action) {}];
                                    [alert addAction:copyButton];
                                    [alert addAction:cancelButton];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action) {}];
    
    
    [alert addAction:getButton];
    [alert addAction:writeButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)contactUs
{
    
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    
    __block NSString* vipMessage = @"";
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Go Premium?"
                                 message:@"Whether a wrong number,  inaccurate data, crashes, any ticket. We receive a huge pile daily. We do our best to answer asap within 15 working days. Premium ticket, skips to be served in max of 48 hours.\nPS: You are NEVER obliged to pay to be served for any support. We do serve you 100% free. For people who would like premium and very fast responses are the only ones who need to pay for the 'dedicated' support personnel(s)."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[NSString stringWithFormat:@"Go premium for %@ coins?",[store stringForKey:@"supportCoins"]]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    __block int supportCoins = [[store stringForKey:@"supportCoins"] intValue];
                                    __block  int currentCoins = [[store stringForKey:@"coins"] intValue];
                                    if(supportCoins<=currentCoins)
                                    {
                                        currentCoins -= supportCoins;
                                        [store setString:[NSString stringWithFormat:@"%i",currentCoins] forKey:@"coins"];
                                        [store synchronize];
                                        vipMessage = [NSString stringWithFormat:@"Premium support purchase ID:%@\nAll text should be below this line\n#####################",[self randomStringWithLength:5]];
                                        [KSToastView ks_showToast:[NSString stringWithFormat:@"%i Coins left",currentCoins]];
                                        [self sendEmail:vipMessage];
                                    }else
                                    {
                                        [KSToastView ks_showToast:@"You need more coins"];
                                        dispatch_async(dispatch_get_main_queue(), ^(){
                                            [self->loading setHidden:NO];
                                            [[RMStore defaultStore] addPayment:[self->pointsProducts productIdentifier] success:^(SKPaymentTransaction *transaction) {
                                                if(transaction.error)
                                                {
                                                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"تم" message:@"خطأ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self->loading setHidden:YES];
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
                                                                    currentCoins += 1000;
                                                                    [store setString:[NSString stringWithFormat:@"%i",currentCoins] forKey:@"coins"];
                                                                    [store synchronize];
                                                                    vipMessage = [NSString stringWithFormat:@"Premium support purchase ID:%@\nAll text should be below this line\n#####################",[self randomStringWithLength:5]];
                                                                    [KSToastView ks_showToast:[NSString stringWithFormat:@"You now have %i coins",currentCoins]];
                                                                    [self->loading setHidden:YES];
                                                                    
                                                                });
                                                            }else
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^(){
                                                                    [self->loading setHidden:YES];
                                                                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا لك" message:@"ِError-1" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                    [alert show];
                                                                });
                                                            }
                                                        }else
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^(){
                                                                [self->loading setHidden:YES];
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
                                                    [self->loading setHidden:YES];
                                                    [alert show];
                                                });
                                            }];
                                        });
                                    }
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No, i'm fine with the free support"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self sendEmail:vipMessage];
                               }];
    
    UIAlertAction* cancelButton = [UIAlertAction
                               actionWithTitle:@"Canel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


-(void)sendEmail:(NSString*)vipMessage
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        [picker setToRecipients:[NSArray arrayWithObject:@"menomotasel@gmail.com"]];
        
        [picker setMessageBody:[vipMessage stringByAppendingFormat:@"\n\n\n\n\n\n\n\n%@\nالمعلومات التالية تساعدنا في تحديد المشاكل بشكل أدق:\n----------\nIOS: %@\nDevice: %@\nApp Version: %.1f",@"إذا كنت تريد التبليغ عن إسم خطأ يرجاء كتابه الاسم و الرقم و أذا كنت تريد حجب رقم برجاء كتابه الرقم و سيتم التحقق من ملكيتك للرقم و حذفه بكشل مجاني ١٠٠٪ فور وصول طلبك للدور",[[UIDevice currentDevice] systemVersion],[self theDeviceType],[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue]] isHTML:NO];
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:menomotasel@gmail.com?body=%@",[vipMessage stringByAppendingFormat:@"\n\n\n\n\n\n\n\n%@\nالمعلومات التالية تساعدنا في تحديد المشاكل بشكل أدق:\n----------\nIOS: %@\nDevice: %@\nApp Version: %.1f",@"إذا كنت تريد التبليغ عن إسم خطأ يرجاء كتابه الاسم و الرقم و أذا كنت تريد حجب رقم برجاء كتابه الرقم و سيتم التحقق من ملكيتك للرقم و حذفه بكشل مجاني ١٠٠٪ فور وصول طلبك للدور",[[UIDevice currentDevice] systemVersion],[self theDeviceType],[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue]]]] options:@{}
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}
@end
