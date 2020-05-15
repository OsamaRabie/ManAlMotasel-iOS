//
//  SpamViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 31/12/2018.
//  Copyright © 2018 SADAH Software Solutions, LLC. All rights reserved.
//

#import "SpamViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "UICKeyChainStore.h"
#import <KSToastView/KSToastView.h>
@import Firebase;
@interface SpamViewController ()<UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate>
@property(strong,nonatomic) FIRDatabaseReference* ref;
@end

@implementation SpamViewController
{
    NSArray* dataSource;
    __weak IBOutlet UIActivityIndicatorView *loader;
    __weak IBOutlet UITableView *spamTable;
    __weak IBOutlet UIButton *syncSpammersButton;
    __weak IBOutlet UILabel *feedBackLabel;
    NSDictionary* jsonLoc;
    __weak IBOutlet UILabel *spamHeaderLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase databaseWithURL:@"https://menomotaselq8-e2d58.firebaseio.com/"] reference];
    
    dataSource = @[];
    [loader setHidden:YES];
    [spamTable setDelegate:self];
    [spamTable setDataSource:self];
    [spamTable setHidden:YES];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lang" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    jsonLoc = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    
    self.title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"spamDetect"];
    spamHeaderLabel = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"detectLabel"];
    
}
- (IBAction)addSpamClicked:(id)sender {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"To make sure every spam report is accountable. We will deduct 10 coins for every report. To eleminate 'spamming' reporting a spammer." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* permissionAction = [UIAlertAction actionWithTitle:@"Yes, i'm sure about my report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
        int currentCoins = [[store stringForKey:@"coins"] intValue];
        currentCoins -= 10;
        [store setString:[NSString stringWithFormat:@"%i",currentCoins] forKey:@"coins"];
        [store synchronize];
        [[[self.ref child:@"users"] child:[store stringForKey:@"userID"]] setValue:@{@"coins":[store stringForKey:@"coins"]} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if(!error)
            {}
        }];
        [KSToastView ks_showToast:[NSString stringWithFormat:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"newCoins"],[store stringForKey:@"coins"]]];
        CNContactPickerViewController* picker = [[CNContactPickerViewController alloc]init];
        [picker setDelegate:self];
        
        [picker setDisplayedPropertyKeys:@[CNContactGivenNameKey
                                           , CNContactPhoneNumbersKey]];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:permissionAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(IBAction)syncSpamClicked:(id)sender
{
    if([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        // Load the spammers
    }else if([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
    {
        CNContactStore * contactStore = [CNContactStore new];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                // Load the spammers
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    
                    [self->feedBackLabel setText:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"noSpamLabel"]];
                    [self->feedBackLabel setHidden:NO];
                    [self->syncSpammersButton setHidden:YES];
                    
                }];
               
            }
        }];
    }else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You need to give the permission for us to be able to sync your contacts and identify which of them are considered as spammers" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* permissionAction = [UIAlertAction actionWithTitle:@"Give permission" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:permissionAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lang" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    jsonLoc = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        [syncSpammersButton setHidden:YES];
        [feedBackLabel setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"noSpamLabel"]];
        [feedBackLabel setHidden:NO];
    }else
    {
        [syncSpammersButton setHidden:NO];
        [feedBackLabel setText:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"spamAccessLabel"]];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"spamCell" forIndexPath:indexPath];
    
    NSDictionary* spamEntry = [dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [spamEntry objectForKey:@"number"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@ %@",@"مسجل سبام بـ",[spamEntry objectForKey:@"times"],@"إسم"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    [self performSelector:@selector(showConfirmation:) withObject:contact afterDelay:1.0];
}

-(void)showConfirmation:(CNContact*)contact
{
    UICKeyChainStore* store = [UICKeyChainStore keyChainStore];
    NSString* spammedBefore = [store stringForKey:@"spammed2"];
    if(!spammedBefore)
    {
        spammedBefore = @"";
    }
    NSArray* spammedArray = [spammedBefore componentsSeparatedByString:@","];
    if([spammedArray containsObject:[[[contact.phoneNumbers objectAtIndex:0]value]stringValue]])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You have already reported this number as a spammer before. To make sure our spammers library are of the higehst possible quality, we only consider a number as a spammer when we get more than 10 requests from different devices" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        spammedBefore = [spammedBefore stringByAppendingFormat:@"%@,",[[[contact.phoneNumbers objectAtIndex:0]value]stringValue]];
        [store setString:spammedBefore forKey:@"spammed2"];
        [store synchronize];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:contact.givenName message:@"Your request had been registered. To make sure our spammers library are of the higehst possible quality, we only consider a number as a spammer when we get more than 10 requests from different devices. Once this is achieved, you will be notified that your contact is no an official spammer." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

@end
