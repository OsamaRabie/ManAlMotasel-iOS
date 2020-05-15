//
//  BlockedTableViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 14/01/2019.
//  Copyright © 2019 SADAH Software Solutions, LLC. All rights reserved.
//

#import "BlockedTableViewController.h"
#import <CallKit/CallKit.h>
#import "UICKeyChainStore.h"
#import <KSToastView/KSToastView.h>
@import Firebase;

@interface BlockedTableViewController ()
@property(strong,nonatomic) FIRDatabaseReference* ref;
@end

@implementation BlockedTableViewController
{
    NSMutableArray* dataSource;
    NSDictionary* jsonLoc;
    __weak IBOutlet UILabel *feedbackLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"blockedBefore"]];
    self.ref = [[FIRDatabase databaseWithURL:@"https://menomotaselq8-e2d58.firebaseio.com/"] reference];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lang" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    jsonLoc = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockTitle"];
    [feedbackLabel setText: [[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockedFeedback"]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blockedCell" forIndexPath:indexPath];
    
    UIView *backView1 = [[UIView alloc] init];
    
    backView1.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    cell.selectedBackgroundView = backView1;
    
    [(UILabel*)[cell viewWithTag:1] setText:[dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"removeBlock"]
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* getButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                                                  initWithSuiteName:@"group.group2.meno.motasel.app"];
                                    [myDefaults setObject:[NSString stringWithFormat:@"%@%@",@"965",self->dataSource[indexPath.row]] forKey:@"removeBlock"];
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
                                                [self->dataSource removeObjectAtIndex:indexPath.row];
                                                [[NSUserDefaults standardUserDefaults]setObject:self->dataSource forKey:@"blockedBefore"];
                                                [[NSUserDefaults standardUserDefaults]synchronize];
                                                [self.tableView reloadData];
                                                
                                                UIAlertController * alert = [UIAlertController
                                                                             alertControllerWithTitle:@"Done"
                                                                             message:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"unBlockDone"]
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction* noButton = [UIAlertAction
                                                                           actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleCancel
                                                                           handler:^(UIAlertAction * action) {}];
                                                
                                                [alert addAction:noButton];
                                                
                                                [self presentViewController:alert animated:YES completion:nil];
                                            });
                                        }
                                    }];
                                }];
   
    
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"cancel"]
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action) {}];
    
    
    
    [alert addAction:getButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)addBlockClicked:(id)sender {
    if (@available(iOS 11, *)) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockNumber"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = [[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"numberBlock"];
            textField.keyboardType = UIKeyboardTypePhonePad;
        }];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[[jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"blockNumber"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        dispatch_async(dispatch_get_main_queue(), ^(){
                                            
                                            
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
                                            
                                            
                                            NSMutableArray* blockedBefore = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"blockedBefore"]];
                                            
                                            if([blockedBefore containsObject:phone])
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
                                            [myDefaults setObject:[NSString stringWithFormat:@"%@%@",@"965",phone] forKey:@"block"];
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
                                                        [blockedBefore addObject: phone];
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
                                                        
                                                        self->dataSource = [[NSUserDefaults standardUserDefaults] objectForKey:@"blockedBefore"];
                                                        [self.tableView reloadData];
                                                        
                                                        int currentCoins = [[store stringForKey:@"coins"] intValue];
                                                        currentCoins -= 20;
                                                        [store setString:[NSString stringWithFormat:@"%i",currentCoins] forKey:@"coins"];
                                                        [store synchronize];
                                                        [KSToastView ks_showToast:[NSString stringWithFormat:[[self->jsonLoc objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"lang"]] objectForKey:@"newCoins"],[store stringForKey:@"coins"]]];
                                                        [[[self.ref child:@"users"] child:[store stringForKey:@"userID"]] setValue:@{@"coins":[NSString stringWithFormat:@"%i",currentCoins]} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                                                        }];
                                                    });
                                                }
                                            }];
                                        });
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"إلغاء"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alertController addAction:yesButton];
        [alertController addAction:noButton];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Opps"
                                     message:@"You need to have iOS 11.0 or newer"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* getButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
        
        [alert addAction:getButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
