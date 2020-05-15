//
//  CompaniesInnerViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 11/11/2018.
//  Copyright © 2018 SADAH Software Solutions, LLC. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation CompanyViewController
{
    __weak IBOutlet UITableView *myTable;
}

@synthesize company;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myTable setDelegate:self];
    [myTable setDataSource:self];
    
    [self setTitle: [company objectForKey:@"title"]];
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[company objectForKey:@"tabs"] count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[company objectForKey:@"tabs"] objectAtIndex:section] objectForKey:@"groups"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"companyCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    
    NSDictionary* companyDetails = [[[[company objectForKey:@"tabs"] objectAtIndex:indexPath.section] objectForKey:@"groups"] objectAtIndex:indexPath.row];
    
    [[(UILabel*)cell viewWithTag:1] setText:[companyDetails objectForKey:@"title"]];
    [[(UILabel*)cell viewWithTag:2] setText:[companyDetails objectForKey:@"content"]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[company objectForKey:@"tabs"] objectAtIndex:section] objectForKey:@"name"];
}

// 450 clinic 40 - 60 - 80 - mteshatab bkol 7aga - 51000 le/m - 40 m 2M - 25% -- 4 years , 35% -- 5 years , 40% -- 6 years , phases 13 clinics per phase -- same views -- 3.5 years all done
// 5 hospitals
// 500

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


