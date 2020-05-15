//
//  PhoneEntryViewController.m
//  Caller-ID
//
//  Copyright © 2018   Solutions, LLC. All rights reserved.
//

#import "PhoneEntryViewController.h"
#import "ViewControllerr.h"
@import Firebase;

@interface PhoneEntryViewController ()
@property(strong,nonatomic) FIRDatabaseReference* ref;
@property(strong,nonatomic) FIRUser* refUser;
@end

@implementation PhoneEntryViewController
{
    
    __weak IBOutlet UITextField *phoneTextField;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"appSeg"])
    {
        ViewControllerr* dst = (ViewControllerr*)[segue destinationViewController];
        [dst setCurrentPhone:phoneTextField.text];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"verified"])
    {
        [self performSegueWithIdentifier:@"appSeg" sender:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userID = @"base";
    [[NSUserDefaults standardUserDefaults]setObject:@"http://menomotasel-zon.us-west-2.elasticbeanstalk.com/callerID" forKey:@"base"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[[_ref child:@"config"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString* baseURL = snapshot.value;
        if(baseURL && baseURL.length > 0)
        {
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendCodeClicked:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@/verify.php?to=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],self->phoneTextField.text]);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/verify.php?to=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],self->phoneTextField.text]]];
        
        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"كود التفعيل" message:@"يرجى إدخال كود التفعيل فور وصوله لك" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"كود التفعيل";
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if([[[alertController textFields][0] text] isEqualToString:result])
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/verified.php?phone=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"base"],self->phoneTextField.text]]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"verified"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            [self performSegueWithIdentifier:@"appSeg" sender:self];
                        });
                    });
                }
            }];
            [alertController addAction:confirmAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Canelled");
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    });
}

- (IBAction)openPrivacyClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://husseinjouhar.wixsite.com/menomatselq8"]];
}

@end
