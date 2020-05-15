//
//  CoinsTableViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 12/01/2019.
//  Copyright © 2019 SADAH Software Solutions, LLC. All rights reserved.
//

#import "CoinsTableViewController.h"
#import "UICKeyChainStore.h"

@interface CoinsTableViewController ()

@end

@implementation CoinsTableViewController
{
    NSDictionary* jsonLoc;
    __weak IBOutlet UIBarButtonItem *currentCoins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView1 = [[UIView alloc] init];
    
    backView1.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView2 = [[UIView alloc] init];
    
    backView2.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView3 = [[UIView alloc] init];
    
    backView3.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    UIView *backView4 = [[UIView alloc] init];
    
    backView4.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    _cell1.selectedBackgroundView = backView1;
    _cell2.selectedBackgroundView = backView2;
    _cell3.selectedBackgroundView = backView3;
    _cell4.selectedBackgroundView = backView4;
   
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:16]}];
    
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    [currentCoins setTitle:[NSString stringWithFormat:@"%@ Coins",[store stringForKey:@"coins"]]];
    // Do any additional setup after loading the view, typically from a nib.
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
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lang" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    jsonLoc = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    [(UILabel*)[_cell1 viewWithTag:1] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"searchName"]];
    [(UILabel*)[_cell2 viewWithTag:1] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"searchPhone"]];
    [(UILabel*)[_cell3 viewWithTag:1] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"spamRequest"]];
    [(UILabel*)[_cell4 viewWithTag:1] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockService"]];
    [(UILabel*)[_cell5 viewWithTag:1] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"skipTheLine"]];
    
    
    [(UILabel*)[_cell1 viewWithTag:4] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"nameCoins"]];
    [(UILabel*)[_cell2 viewWithTag:4] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"phoneCoins"]];
    [(UILabel*)[_cell3 viewWithTag:4] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"spamCoins"]];
    [(UILabel*)[_cell4 viewWithTag:4] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockCoins"]];
    [(UILabel*)[_cell5 viewWithTag:4] setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"supportCoins"]];
    
    
    [(UILabel*)[_cell5 viewWithTag:10] setText:[NSString stringWithFormat:@"%@ coins",[[UICKeyChainStore keyChainStore]stringForKey:@"supportCoins"]]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [currentCoins setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    self.title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"coinsTitle"];
    
    
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)return 5;
    

    return 2;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

@end
