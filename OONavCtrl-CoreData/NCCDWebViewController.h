//
//  NCCDWebViewController.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCCDWebViewController : UIViewController
@property(copy, nonatomic) NSURL *url;
@property(strong, nonatomic) UIWebView *webView;
@end

