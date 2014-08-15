//
//  NCCDParentViewController.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDParentViewController.h"

@interface NCCDParentViewController ()

@end

@implementation NCCDParentViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    NSLog(@" (id)initWithStyle:(UITableViewStyle)style");
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    NSLog(@"ParentVC viewDidLoad\n");
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Mobile Device Makers";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self asynchGetPricesFromCompanies:[NCCDDAO sharedCompanies]];
    NSLog(@"\nParentController - viewWillAppear:(BOOL)animated");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSLog(@"\nParentController - viewWillDisappear:(BOOL)animated");
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"\nParentController - viewDidAppear:(BOOL)animated");
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"\nparentVC:didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];

    
//    REWRITE ALL OF THIS to use CoreData
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *originalCompanies = [NCCDDAO loadCompanies];
//    NSData *userDefaultData = [NSKeyedArchiver archivedDataWithRootObject:originalCompanies];     //reload all companies, overriding current NSUserDefaults
//    [defaults setObject:userDefaultData forKey:@"companiesKey"];
//    [defaults synchronize];
    
//    NSMutableArray *sharedCompanies = [NCCDDAO sharedCompanies];
//    [sharedCompanies removeAllObjects];
//    [sharedCompanies addObjectsFromArray:originalCompanies];
    
//    [self asynchGetPricesFromCompanies:sharedCompanies]; //also reloads tableview
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section");
    // Return the number of rows in the section.
    
    return [[NCCDDAO sharedCompanies]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //configure the cell
    OONCCompany *company = [[OONCCompany alloc]init];
    company = [[NCCDDAO sharedCompanies] objectAtIndex:[indexPath row]];
    
    if (!company.price)
    {
        company.price = [[NSMutableString alloc]initWithCapacity:10];
    }
    cell.textLabel.text = [company.companyname stringByAppendingFormat:@" %@",company.price];
    cell.imageView.image = [UIImage imageNamed:company.companyimagename];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.childVC = [[NCCDChildViewController alloc]init];
    
    
    OONCCompany *company = [[OONCCompany alloc]init];
    company = [[NCCDDAO sharedCompanies] objectAtIndex:[indexPath row]];
    self.childVC.company= company;
    
    self.childVC.title  = [company companyname];
    
    [self.navigationController pushViewController:self.childVC animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"\n- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath");
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[NCCDDAO sharedCompanies] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)asynchGetPriceFromStockTicker:(NSString *)ticker
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=l1",ticker]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    
    NSLog(@"asynchGetPriceFromTickers:(NSString*)ticker:%@",ticker);
}

-(void)asynchGetPricesFromCompanies:(NSArray *)companies
{
    NSMutableArray *tickers = [[NSMutableArray alloc]initWithCapacity:5];
    for(OONCCompany *company in companies)
    {
        [tickers addObject:company.ticker];
    }
    
    NSMutableString *tickersString = [[NSMutableString alloc]initWithCapacity:[tickers count]];
    for(int i=0;i < [tickers count];i++)
    {
        if(i < [tickers count]-1)
        {
            [tickersString appendFormat:@"%@,",tickers[i]];
        }
        else
        {
            [tickersString appendString:tickers[i]];
        }
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=l1",tickersString]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    
    NSLog(@"asynchGetPricesFromCompanies:(NSString*)tickers:%@",tickersString);
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"\n(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender");
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"\nconnection: %@ didReceiveResponse",connection);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData)
    {
        self.receivedData = [[NSMutableData alloc]init];
    }
    [self.receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"\nconnection: %@ didFailWithError: %@ %@",connection,[error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    connection = nil;
    self.receivedData = nil;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"\nconnection %@DidFinishLoading ",connection);
    //    NSLog(@"Final data is %d bytes: %@",[self.receivedData length],self.receivedData);
    NSString *string = [[[NSString alloc]initWithData:self.receivedData encoding:NSUTF8StringEncoding]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r"]];
    NSLog(@"\nFinal Data from connection %@ converted to string is \n%@", connection, string);
    
    NSArray *prices  = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    for (int i=0;i<[[NCCDDAO sharedCompanies] count];i++)
    {
        if(prices[i])
        {
            [[NCCDDAO sharedCompanies][i] setPrice:prices[i]];
        }
    }
    connection = nil;
    self.receivedData = nil;
    [self.tableView reloadData];
}
@end
