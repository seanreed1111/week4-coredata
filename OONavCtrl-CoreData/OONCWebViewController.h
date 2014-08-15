//
//  OONCWebViewController.h
//  OONavCtrl
//
//  Created by Sean Reed on 8/4/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OONCWebViewController : UIViewController
@property(copy, nonatomic) NSURL *url;
@property(strong, nonatomic) UIWebView *webView;
@end
