//
//  AdViewController.m
//  Caller-ID
//
//  Copyright © 2018   Solutions, LLC. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@end

@implementation AdViewController
{
    __weak IBOutlet UIButton *adButton;
    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UIActivityIndicatorView *loading;
    __weak IBOutlet UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [adButton setHidden:YES];
    [closeButton setHidden:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self->_ad objectForKey:@"adLink"]]];
        UIImage* adImage = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->imageView setImage:adImage];
            [self->adButton setTitle:[self->_ad objectForKey:@"textButton"] forState:UIControlStateNormal];
            [self->adButton setHidden:NO];
            [self->closeButton setHidden:NO];
            [self->loading setHidden:YES];
        });
    });
}
- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)openLinkClicked:(id)sender {
    if(![[self->_ad objectForKey:@"adUrl"] isEqualToString:@""] && [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[self->_ad objectForKey:@"adUrl"]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self->_ad objectForKey:@"adUrl"]]];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
