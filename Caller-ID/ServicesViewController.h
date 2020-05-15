//
//  ServicesViewController.h
//  Caller-ID
//
//  Created by Housein Jouhar on 9/1/16.
//  Copyright © 2016 , LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesViewController : UIViewController
{
    NSInteger currentMethod;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *blockButton;
@property (strong, nonatomic) IBOutlet UIButton *adButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UIButton *purchasedButton;

@end
