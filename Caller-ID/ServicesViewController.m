//
//  ServicesViewController.m
//  Caller-ID
//
//  Created by Housein Jouhar on 9/1/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import "ServicesViewController.h"
#import <RMStore/RMStore.h>
#import "UICKeyChainStore.h"
@import Firebase;
#import <RMStore/RMStore.h>
#import "AESTool.h"
#import <Messages/Messages.h>
#import <MessageUI/MessageUI.h>

@interface ServicesViewController ()<UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property(strong,nonatomic) FIRDatabaseReference* ref;
@property(strong,nonatomic) FIRUser* refUser;
@end
// bundleeee
const NSString * global_bundleVersion = @"6";
const NSString * global_bundleIdentifier = @"meno.motasel.app";



@implementation ServicesViewController
{
    NSArray* products;
    NSString* numberToBlock;
    NSString *key;
    BOOL blockbgad;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *userID = @"base";
    [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            [[NSUserDefaults standardUserDefaults]setObject:baseURL forKey:@"base"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    
    if ([[store stringForKey:@"ads"] isEqualToString:@"NO"])
    {
        [_purchasedButton setHidden:NO];
        [_adButton setHidden:YES];
        //[_restoreButton setHidden:YES];
    }
    
    if ([[UICKeyChainStore keyChainStore] stringForKey:@"name"])
    {
        [_blockButton setBackgroundImage:[UIImage imageNamed:@"Purchased-button.png"] forState:UIControlStateNormal];
        [_blockButton setTitle:@"تم الشراء" forState:UIControlStateNormal];
    }
    
    [[FIRAuth auth]signOut:nil];
    self.ref = [[FIRDatabase database] reference];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:16]}];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBuyDone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 730)];
    
    
    //[self addActivityView];
    products = nil;
    NSSet *productsIDs = [NSSet setWithArray:@[@"meno.motasel.app.5"]];
    [[RMStore defaultStore] requestProducts:productsIDs success:^(NSArray *productss, NSArray *invalidProductIdentifiers) {
        self->products = productss;
        for(SKProduct* product in self->products)
        {
            NSLog(@"%@",[product productIdentifier]);
            NSString* ss = (NSString*)[NSString stringWithFormat:@"%@",[product productIdentifier]];
            
            if([ss rangeOfString:@"com.1"].location != NSNotFound)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_blockButton setTitle:[NSString stringWithFormat:@"شراء (%0.2f)",product.price.floatValue] forState:UIControlStateNormal];
                    [self removeActivityView];
                });
            }else if([ss rangeOfString:@"com.2"].location != NSNotFound)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_adButton setTitle:[NSString stringWithFormat:@"شراء (%0.2f)",product.price.floatValue] forState:UIControlStateNormal];
                    [self removeActivityView];
                });
            }
        }
    } failure:^(NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:[NSString stringWithFormat:@"حدث الخطأ التالي : %@ رجاء مراسلة الدعم الفني",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeActivityView];
            [alert show];
        });
    }];
}


- (IBAction)buyNow:(id)sender {
    if ([sender tag] == 3642 || [sender tag] == 3247)
    {
        currentMethod = [self getNumber];
        [[NSUserDefaults standardUserDefaults] setInteger:currentMethod forKey:@"savedMethod"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self rm];
    }
    else
    {
        //Hacker :)
    }
    
    /*if ([sender tag] == 3642)
    {
        blockbgad = NO;
        
        UIAlertController * alertt = [UIAlertController
                                     alertControllerWithTitle:@"خدمة ال VIP عديد من المزايا"
                                     message:@"هذه الخدمه سوف تقوم بإضافة ١٠٠ الف عملية بحث في رصيدك، لكنك أيضا تستطيع التمتع مجانا بإخفاء رقم من الظهور في البحث بشكل فوري أو الاعلان عنه"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"أريد أن أخفي أو أعلن عن رقم"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        self->blockbgad = YES;
                                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"أدخل الرقم" message:nil delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:@"تمام", nil];
                                        alert.tag = 777;
                                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
                                        [alert show];
                                    }];
        
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"فقط أريد عمليات البحث"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       self->numberToBlock = @"11111111";
                                       [self rm];
                                   }];
        
        //Add your buttons to alert controller
        
        [alertt addAction:yesButton];
        [alertt addAction:noButton];
        
        [self presentViewController:alertt animated:YES completion:nil];
    }
    else if ([sender tag] == 3247)
    {
        [self am];
    }*/
}

-(void)enableBlock
{
    if (currentMethod != [[NSUserDefaults standardUserDefaults] integerForKey:@"savedMethod"])
    {
        NSLog(@"Hacker for sure..");
        return;
    }
}

-(void)enableRemoveAds
{
    if (currentMethod != [[NSUserDefaults standardUserDefaults] integerForKey:@"savedMethod"])
    {
        NSLog(@"Hacker for sure..");
        return;
    }
}

-(NSInteger)getNumber
{
    return arc4random() % 99999;
}

-(void)setPriceForBlock:(NSString*)thePrice
{
    [_blockButton setTitle:[@"شراء " stringByAppendingFormat:@"(%@)",thePrice] forState:UIControlStateNormal];
}

-(void)setPriceForAds:(NSString*)thePrice
{
    [_adButton setTitle:[@"شراء " stringByAppendingFormat:@"(%@)",thePrice] forState:UIControlStateNormal];
}

- (IBAction)closeMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addActivityView
{
    for (UIView *view in [self.navigationController view].subviews)
    {
        if (view.tag == 383)
        {
            [view removeFromSuperview];
            break;
        }
    }
    
    UIView *mainActionView;
    
    if (([UIApplication sharedApplication].statusBarOrientation == 3 || [UIApplication sharedApplication].statusBarOrientation == 4) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        mainActionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    }
    else
    {
        mainActionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }
    
    mainActionView.tag = 383;
    
    [mainActionView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8]];
    
    [[self.navigationController view]addSubview:mainActionView];
    
    UIImageView *actImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-icon.png"]];
    
    [actImg setFrame:CGRectMake(0, 0, 120, 120)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat: 999];
    animation.duration = 170.5f;
    [actImg.layer addAnimation:animation forKey:@"MyAnimation"];
    
    actImg.center = mainActionView.center;
    
    [mainActionView addSubview:actImg];
}


-(void)removeActivityView
{
    for (UIView *view in [self.navigationController view].subviews)
    {
        if (view.tag == 383)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [view removeFromSuperview];
            });
            break;
        }
    }
}


#pragma mark purchase method

-(void)rm
{
    if (products.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"فشل في الإتصال" message:@"رجاء تأكد من إتصال الإنترنت لديك وحاول مرة أخرى." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"تم", nil];
        [alert show];
        return;
    }
    
    if (currentMethod != [[NSUserDefaults standardUserDefaults] integerForKey:@"savedMethod"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"حدث خطأ أثناء عملية الشراء." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"تم", nil];
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self addActivityView];
    });
    SKProduct *product = products[0];
    [[RMStore defaultStore] addPayment:[product productIdentifier] success:^(SKPaymentTransaction *transaction) {
        if(transaction.error)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"تم" message:@"خطأ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا لك" message:@"تم تفعيل البحث باسم" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
                            [store setString:@"YES" forKey:@"name"];
                            [store synchronize];
                            [self removeActivityView];
                            [alert show];
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
}

#pragma mark alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 777)
    {
        if(alertView.cancelButtonIndex != buttonIndex)
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            numberToBlock = [textField text];
            [self rm];
        }
    }
}

- (void)report {
    // Email Subject
    NSString *emailTitle = @"خدمة عملاء منو المتصل";
    // Email Content
    NSString *messageBody = @"اذا كنت من عملاء ال VIP، برجاء كتابة رقمك. و إذا كنت تريد التبليغ عن إسم يرجاء كتابه الاسم و الرقم";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"menomotasel@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)restoreButtonClicked:(id)sender {
    
    
    
    [[RMStore defaultStore]restoreTransactionsOnSuccess:^(NSArray *transactions) {
        NSString* message = @"لم يتم العثور على مشتريات سابقة لهذا الحساب.";
        for(SKPaymentTransaction *transaction in transactions)
        {
            if([transaction.payment.productIdentifier isEqualToString:@"meno.motasel.app.5"])
            {
                message = @"تم إستعادة و تفعيل البحث بالإسم";
                UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
                [store setString:@"YES" forKey:@"name"];
                [store synchronize];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * alertt = [UIAlertController
                                          alertControllerWithTitle:@"تم"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
            
            [alertt addAction:yesButton];
            
            [self presentViewController:alertt animated:YES completion:nil];
        });
        
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * alertt = [UIAlertController
                                          alertControllerWithTitle:@"خطأ"
                                          message:@"برجاء المحاولة مرة أخرى"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
            
            [alertt addAction:yesButton];
            
            [self presentViewController:alertt animated:YES completion:nil];
        });
    }];
}


@end
