//
//  CompaniesInnerViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 11/11/2018.
//  Copyright © 2018 SADAH Software Solutions, LLC. All rights reserved.
//

#import "CompaniesInnerViewController.h"
#import "CompanyViewController.h"

@interface CompaniesInnerViewController() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation CompaniesInnerViewController
{
    __weak IBOutlet UITableView *myTable;
}

@synthesize category;


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"companySeg"])
    {
        CompanyViewController* dst = (CompanyViewController*)[segue destinationViewController];
        [dst setCompany:[[[category objectForKey:@"companies"] objectAtIndex:myTable.indexPathForSelectedRow.row]objectForKey:@"details"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [myTable setDelegate:self];
    [myTable setDataSource:self];
    
    [self setTitle: [category objectForKey:@"name"]];
    // Do any additional setup after loading the view.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[category objectForKey:@"companies"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"companyCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    
    NSDictionary* company = [[category objectForKey:@"companies"] objectAtIndex:indexPath.row];
    
    [[(UILabel*)cell viewWithTag:1] setText:[company objectForKey:@"name"]];
    [[(UILabel*)cell viewWithTag:2] setText:[[company objectForKey:@"details"]objectForKey:@"desc"]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"companySeg" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

