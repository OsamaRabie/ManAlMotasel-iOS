//
//  Created by Housein Jouhar.
//  Copyright (c) 2016 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UIActionSheetDelegate,UISearchBarDelegate>
{
    NSMutableArray *namesArray,*numbersArray,*searchArray,*filterSearchArray;
    BOOL isLog,isLogOpend,isFavOpend,isSearching;
    NSInteger prevCount,theRow;
    CGFloat tableViewHight;
}

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UILabel *emptyTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *emptyMsgLabel;
@property (strong, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actView;
@end
