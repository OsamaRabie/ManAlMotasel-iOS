//
//  Created by Housein Jouhar.
//  Copyright (c) 2016 MacBook. All rights reserved.
//

#import "MenuViewController.h"
#import "CRToastManager.h"
#import "CRToast.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:14]
       }
     forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"DroidArabicKufi" size:16]}];
    
    [[UITextField appearanceWhenContainedIn:[_searchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"DroidArabicKufi" size:14],
                                                                                                 }];
    
    isLog = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogNow"];
    
    if (isLog)
    {
        [self openLog];
    }
    else
    {
        [self openFav];
    }
    
    if ([self isiPhoneX])
    {
        for (UIView *view in _mainView.subviews)
        {
            if (view.tag == 81)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+25, view.frame.size.width, view.frame.size.height)];
            }
        }
        
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+25, self.tableView.frame.size.width, self.tableView.frame.size.height-25)];
        
        [_noResultsLabel setFrame:CGRectMake(_noResultsLabel.frame.origin.x, _noResultsLabel.frame.origin.y+25, _noResultsLabel.frame.size.width, _noResultsLabel.frame.size.height)];
    }
    
    [self.tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    tableViewHight = self.tableView.frame.size.height;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    NSInteger sizeOfKeyboard;
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    sizeOfKeyboard = keyboardSize.height;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0
                     animations:^{
                         [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableViewHight-sizeOfKeyboard)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.4 delay:0.0 options:0
                     animations:^{
                         [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableViewHight)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarStopEditing];
}

-(void)searchBarStopEditing
{
    isSearching = NO;
    
    if (isLog)
    {
        if (namesArray.count > 0)
        {
            [self.navigationItem setTitle:[@"السجل " stringByAppendingFormat:@"(%lu)",(unsigned long)namesArray.count]];
        }
        else
        {
            [self.navigationItem setTitle:@"السجل"];
        }
    }
    else
    {
        if (namesArray.count > 0)
        {
            [self.navigationItem setTitle:[@"المفضلة " stringByAppendingFormat:@"(%lu)",(unsigned long)namesArray.count]];
        }
        else
        {
            [self.navigationItem setTitle:@"المفضلة"];
        }
    }
    
    [self.searchBar setText:@""];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [filterSearchArray removeAllObjects];
    [searchArray removeAllObjects];
    
    [_noResultsLabel setHidden:YES];
    
    if (namesArray.count > 0)
    {
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
    
    [self startSearch];
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    for(UIView *subView in _searchBar.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            [(UIButton*)subView setTitle:@"إلغاء" forState:UIControlStateNormal];
        }
        else
        {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView isKindOfClass:[UIButton class]])
                {
                    [(UIButton*)subSubView setTitle:@"إلغاء" forState:UIControlStateNormal];
                }
            }
        }
    }
}

-(void)startSearch
{
    filterSearchArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < namesArray.count; i++)
    {
        [filterSearchArray addObject:[[namesArray objectAtIndex:i] stringByAppendingFormat:@"-*3&^*4-%@",[numbersArray objectAtIndex:i]]];
    }
    
    searchArray = [[NSMutableArray alloc] initWithArray:filterSearchArray];
    
    isSearching = YES;
    
    if (isLog)
    {
        [self.navigationItem setTitle:@"السجل"];
    }
    else
    {
        [self.navigationItem setTitle:@"المفضلة"];
    }
    
    [self.tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        [_actView stopAnimating];
        [_noResultsLabel setHidden:YES];
        [self.tableView setHidden:NO];
        
        if (searchArray.count != filterSearchArray.count)
        {
            searchArray = [[NSMutableArray alloc] initWithArray:filterSearchArray];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
        }
        return;
    }
    
    [_actView startAnimating];
    [self.tableView setHidden:YES];
    
    [self performSelector:@selector(searchNow) withObject:nil afterDelay:0.1];
}

-(void)searchNow
{
    searchArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < filterSearchArray.count; i++)
    {
        if ([[filterSearchArray objectAtIndex:i] rangeOfString:self.searchBar.text].location != NSNotFound)
        {
            [searchArray addObject:[filterSearchArray objectAtIndex:i]];
        }
    }
    
    [_actView stopAnimating];
    
    if (searchArray.count == 0)
    {
        [_noResultsLabel setHidden:NO];
        [self.tableView setHidden:YES];
        [self.tableView reloadData];
    }
    else
    {
        [_noResultsLabel setHidden:YES];
        [self.tableView setHidden:NO];
        
        if (searchArray.count != prevCount)
        {
            if (searchArray.count == filterSearchArray.count)
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
            }
            else
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else
        {
            [self.tableView reloadData];
        }
    }
    
    prevCount = searchArray.count;
}


- (IBAction)switchToFav:(id)sender {
    if (isFavOpend)return;
    isLog = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogNow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self openFav];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self.tableView reloadData];
                         [UIView animateWithDuration:0.1 delay:0.0 options:0
                                          animations:^{
                                              [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              //
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

- (IBAction)deleteAll:(id)sender {
    if (isSearching)
    {
        [self.searchBar resignFirstResponder];
    }
    
    if (isLog)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"حذف كل الملفات في السجل؟" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:@"حذف الكل" otherButtonTitles:nil];
        [actionSheet setTag:11];
        [actionSheet showInView:self.navigationController.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"حذف كل الملفات في المفضلة؟" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:@"حذف الكل" otherButtonTitles:nil];
        [actionSheet setTag:11];
        [actionSheet showInView:self.navigationController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    if (actionSheet.tag == 11 && actionSheet.cancelButtonIndex == buttonIndex)
    {
        if (isSearching)
        {
            [self.searchBar becomeFirstResponder];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    switch (buttonIndex) {
        case 0:
        {
            if (actionSheet.tag == 11)
            {
                [self clearAllEntries];
            }
            else if (actionSheet.tag == 12)
            {
                [self performSelector:@selector(callContact) withObject:nil afterDelay:0.3];
            }
        }
            break;
        case 1:
        {
            if (actionSheet.tag == 12)
            {
                [self performSelector:@selector(copName) withObject:nil afterDelay:0.3];
            }
        }
            break;
        case 2:
        {
            if (actionSheet.tag == 12)
            {
                [self performSelector:@selector(copNumber) withObject:nil afterDelay:0.3];
            }
        }
    }
}

-(void)callContact
{
    if (isSearching)
    {
        NSLog(@"%@",[[searchArray objectAtIndex:theRow] substringFromIndex:[[searchArray objectAtIndex:theRow] rangeOfString:@"-*3&^*4-"].location+8]);
    }
    else
    {
        NSLog(@"%@",[numbersArray objectAtIndex:theRow]);
    }
    
    if (isSearching)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingFormat:@"%@",[[searchArray objectAtIndex:theRow] substringFromIndex:[[searchArray objectAtIndex:theRow] rangeOfString:@"-*3&^*4-"].location+8]]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingFormat:@"%@",[numbersArray objectAtIndex:theRow]]]];
    }
}

-(void)copName
{
    if (isSearching)
    {
        [[UIPasteboard generalPasteboard] setString:[[searchArray objectAtIndex:theRow] substringToIndex:[[searchArray objectAtIndex:theRow] rangeOfString:@"-*3&^*4-"].location]];
    }
    else
    {
        [[UIPasteboard generalPasteboard] setString:[namesArray objectAtIndex:theRow]];
    }
    
    [self showGhostMsg:@"تم نسخ الإسم" isError:NO];
}

-(void)copNumber
{
    if (isSearching)
    {
        [[UIPasteboard generalPasteboard] setString:[[searchArray objectAtIndex:theRow] substringFromIndex:[[searchArray objectAtIndex:theRow] rangeOfString:@"-*3&^*4-"].location+8]];
    }
    else
    {
        [[UIPasteboard generalPasteboard] setString:[numbersArray objectAtIndex:theRow]];
    }
    
    [self showGhostMsg:@"تم نسخ الرقم" isError:NO];
}

-(void)showGhostMsg:(NSString*)theMsg isError:(BOOL)isError
{
    UIColor *theColor;
    
    if (isError)
    {
        theColor = [self colorWithHexString:@"c22e41"];
    }
    else
    {
        theColor = [self colorWithHexString:@"6fd841"];
    }
    
    NSDictionary *options = @{
                              kCRToastTextKey : theMsg,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : theColor,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom)
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
}

-(void)clearAllEntries
{
    if (isSearching)
    {
        [self searchBarStopEditing];
    }
    
    [namesArray removeAllObjects];
    [numbersArray removeAllObjects];
    
    if (isLog)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] init] forKey:@"savedLogArray"];
        [self.navigationItem setTitle:@"السجل"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc] init] forKey:@"savedFavArray"];
        [self.navigationItem setTitle:@"المفضلة"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showNoFavOrLog];
}

- (IBAction)switchToLog:(id)sender {
    if (isLogOpend)return;
    
    isLog = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogNow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self openLog];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y+self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self.tableView reloadData];
                         [UIView animateWithDuration:0.1 delay:0.0 options:0
                                          animations:^{
                                              [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y-self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                                          }
                                          completion:^(BOOL finished) {
                                              //
                                          }];
                         [UIView commitAnimations];
                     }];
    [UIView commitAnimations];
}

-(void)openLog
{
    if (isLogOpend)return;
    isLogOpend = YES;
    isFavOpend = NO;
    
    namesArray = [[NSMutableArray alloc] init];
    numbersArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedLogArray"]];
    
    for (int i = 0; i < filterArray.count; i++)
    {
        [namesArray addObject:[[filterArray objectAtIndex:i] substringToIndex:[[filterArray objectAtIndex:i] rangeOfString:@"-*3&^*4-"].location]];
        [numbersArray addObject:[[filterArray objectAtIndex:i] substringFromIndex:[[filterArray objectAtIndex:i] rangeOfString:@"-*3&^*4-"].location+8]];
    }
    
    if (namesArray.count == 0)
    {
        [self showNoFavOrLog];
    }
    else
    {
        [self hideNoFavOrLog];
    }
    
    if (namesArray.count > 0)
    {
        [self.navigationItem setTitle:[@"السجل " stringByAppendingFormat:@"(%lu)",(unsigned long)namesArray.count]];
    }
    else
    {
        [self.navigationItem setTitle:@"السجل"];
    }
    
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         [_selectLabel setBackgroundColor:[UIColor colorWithRed:114.0/255.0 green:202.0/255.0 blue:237.0/255.0 alpha:1.0]];
                         [_selectLabel setFrame:CGRectMake(_logButton.frame.origin.x, _selectLabel.frame.origin.y, _logButton.frame.size.width, _selectLabel.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
    
    [_logButton setBackgroundColor:[self colorWithHexString:@"FDFDFD"]];
    [_favButton setBackgroundColor:[self colorWithHexString:@"DFDFDF"]];
    
    [_logButton setAlpha:1.0];
    [_logButton setImage:[UIImage imageNamed:@"log-menu.png"] forState:UIControlStateNormal];
    
    [_favButton setAlpha:0.5];
    [_favButton setImage:[UIImage imageNamed:@"fav-menu-off.png"] forState:UIControlStateNormal];
    
    [filterArray removeAllObjects];
}

-(void)openFav
{
    if (isFavOpend)return;
    isFavOpend = YES;
    isLogOpend = NO;
    
    namesArray = [[NSMutableArray alloc] init];
    numbersArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedFavArray"]];
    
    for (int i = 0; i < filterArray.count; i++)
    {
        [namesArray addObject:[[filterArray objectAtIndex:i] substringToIndex:[[filterArray objectAtIndex:i] rangeOfString:@"-*3&^*4-"].location]];
        [numbersArray addObject:[[filterArray objectAtIndex:i] substringFromIndex:[[filterArray objectAtIndex:i] rangeOfString:@"-*3&^*4-"].location+8]];
    }
    
    if (namesArray.count == 0)
    {
        [self showNoFavOrLog];
    }
    else
    {
        [self hideNoFavOrLog];
    }
    
    if (namesArray.count > 0)
    {
        [self.navigationItem setTitle:[@"المفضلة " stringByAppendingFormat:@"(%lu)",(unsigned long)namesArray.count]];
    }
    else
    {
        [self.navigationItem setTitle:@"المفضلة"];
    }
    
    [UIView animateWithDuration:0.1 delay:0.0 options:0
                     animations:^{
                         [_selectLabel setBackgroundColor:[UIColor colorWithRed:189.0/255.0 green:76.0/255.0 blue:67.0/255.0 alpha:1.0]];
                         [_selectLabel setFrame:CGRectMake(_favButton.frame.origin.x, _selectLabel.frame.origin.y, _favButton.frame.size.width, _selectLabel.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
    [UIView commitAnimations];
    
    [_logButton setBackgroundColor:[self colorWithHexString:@"DFDFDF"]];
    [_favButton setBackgroundColor:[self colorWithHexString:@"FDFDFD"]];
    
    [_logButton setAlpha:0.5];
    [_logButton setImage:[UIImage imageNamed:@"log-menu-off.png"] forState:UIControlStateNormal];
    
    [_favButton setAlpha:1.0];
    [_favButton setImage:[UIImage imageNamed:@"fav-menu.png"] forState:UIControlStateNormal];
    
    [filterArray removeAllObjects];
}

-(void)showNoFavOrLog
{
    [_clearAllButton setEnabled:NO];
    [_clearAllButton setTintColor:[self colorWithHexString:@"0F2E40"]];
    
    [self.searchBar setHidden:YES];
    
    if (isLog)
    {
        [self.tableView setHidden:YES];
        [_emptyTitleLabel setHidden:NO];
        [_emptyMsgLabel setHidden:NO];
        
        [_emptyTitleLabel setText:@"السجل فارغ"];
        [_emptyMsgLabel setText:@"عند قيامك بأي عملية بحث سيتم حفظ نتائجها هنا في السجل."];
        [self.navigationItem setTitle:@"السجل"];
    }
    else
    {
        [self.tableView setHidden:YES];
        [_emptyTitleLabel setHidden:NO];
        [_emptyMsgLabel setHidden:NO];
        
        [_emptyTitleLabel setText:@"المفضلة فارغة"];
        [_emptyMsgLabel setText:@"لإضافة بحث للمفضلة اضغط على أيقونة النجمة على يمين نتيجة البحث."];
        [self.navigationItem setTitle:@"المفضلة"];
    }
}

-(void)hideNoFavOrLog
{
    [_clearAllButton setEnabled:YES];
    [_clearAllButton setTintColor:[UIColor whiteColor]];
    
    [self.searchBar setHidden:NO];
    [self.tableView setHidden:NO];
    [_emptyTitleLabel setHidden:YES];
    [_emptyMsgLabel setHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching)return searchArray.count;
    return [namesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"theCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:173.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    cell.selectedBackgroundView = backView;
    
    if (isSearching)
    {
        if (searchArray.count > indexPath.row)
        {
            [(UILabel*)[cell viewWithTag:1]setText:[[searchArray objectAtIndex:indexPath.row] substringToIndex:[[searchArray objectAtIndex:indexPath.row] rangeOfString:@"-*3&^*4-"].location]];
            [(UILabel*)[cell viewWithTag:2]setText:[[searchArray objectAtIndex:indexPath.row] substringFromIndex:[[searchArray objectAtIndex:indexPath.row] rangeOfString:@"-*3&^*4-"].location+8]];
        }
    }
    else
    {
        if (namesArray.count > indexPath.row)
        {
            [(UILabel*)[cell viewWithTag:1]setText:[namesArray objectAtIndex:indexPath.row]];
        }
        
        if (numbersArray.count > indexPath.row)
        {
            [(UILabel*)[cell viewWithTag:2]setText:[numbersArray objectAtIndex:indexPath.row]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    theRow = indexPath.row;
    
    if (isSearching)
    {
        [self.searchBar resignFirstResponder];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"إتصال",@"نسخ الإسم",@"نسخ الرقم",nil];
    [actionSheet setTag:12];
    [actionSheet showInView:self.navigationController.view];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *filterArray;
        
        if (isSearching)
        {
            NSInteger deleteRow = [namesArray indexOfObject:[[searchArray objectAtIndex:indexPath.row] substringToIndex:[[searchArray objectAtIndex:indexPath.row] rangeOfString:@"-*3&^*4-"].location]];
            
            if (isLog)
            {
                filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedLogArray"]];
            }
            else
            {
                filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedFavArray"]];
            }
            
            [filterArray removeObject:[@"" stringByAppendingFormat:@"%@-*3&^*4-%@",[namesArray objectAtIndex:deleteRow],[numbersArray objectAtIndex:deleteRow]]];
            
            if (isLog)
            {
                [[NSUserDefaults standardUserDefaults] setObject:filterArray forKey:@"savedLogArray"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:filterArray forKey:@"savedFavArray"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [namesArray removeObjectAtIndex:deleteRow];
            [numbersArray removeObjectAtIndex:deleteRow];
            [filterSearchArray removeObject:[searchArray objectAtIndex:indexPath.row]];
            [searchArray removeObjectAtIndex:indexPath.row];
        }
        else
        {
            if (isLog)
            {
                filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedLogArray"]];
            }
            else
            {
                filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedFavArray"]];
            }
            
            [filterArray removeObject:[@"" stringByAppendingFormat:@"%@-*3&^*4-%@",[namesArray objectAtIndex:indexPath.row],[numbersArray objectAtIndex:indexPath.row]]];
            
            if (isLog)
            {
                [[NSUserDefaults standardUserDefaults] setObject:filterArray forKey:@"savedLogArray"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:filterArray forKey:@"savedFavArray"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [namesArray removeObjectAtIndex:indexPath.row];
            [numbersArray removeObjectAtIndex:indexPath.row];
        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
        if (namesArray.count == 0)
        {
            if (isSearching)[self searchBarStopEditing];
            
            [self showNoFavOrLog];
        }
    }
}

- (IBAction)closeMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
