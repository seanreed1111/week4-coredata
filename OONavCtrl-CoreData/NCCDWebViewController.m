//
//  NCCDWebViewController.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDWebViewController.h"


@implementation NCCDWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    NSLog(@"Web viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!self.webView)
    {
        
        //Added by Aditya
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        
        //Added by Aditya
        [self.view addSubview:self.webView];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Web viewWillAppear");
    
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
