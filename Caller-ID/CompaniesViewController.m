//
//  CompaniesViewController.m
//  Caller-ID
//
//  Created by Osama Rabie on 11/11/2018.
//  Copyright © 2018 SADAH Software Solutions, LLC. All rights reserved.
//

#import "CompaniesViewController.h"
#import "CompaniesInnerViewController.h"

@interface CompaniesViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CompaniesViewController
{
    __weak IBOutlet UITableView *myTable;
    NSArray* dataSource;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"catSeg"])
    {
        CompaniesInnerViewController* dst = (CompaniesInnerViewController*)[segue destinationViewController];
        [dst setCategory:[dataSource objectAtIndex:myTable.indexPathForSelectedRow.row]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    dataSource = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [myTable setDelegate:self];
    [myTable setDataSource:self];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [myTable deselectRowAtIndexPath:myTable.indexPathForSelectedRow animated:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"companyCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    
    NSDictionary* company = [dataSource objectAtIndex:indexPath.row];
    
    [[(UILabel*)cell viewWithTag:1] setText:[company objectForKey:@"name"]];
    [[(UILabel*)cell viewWithTag:2] setText:[NSString stringWithFormat:@"%lu companies",[[company objectForKey:@"companies"] count]]];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"catSeg" sender:self];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
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
