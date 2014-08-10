//
//  AALSpaceWebsiteViewController.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/10/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import "AALSpaceWebsiteViewController.h"
#import "MBProgressHUD.h"

@interface AALSpaceWebsiteViewController ()

@end

@implementation AALSpaceWebsiteViewController

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
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"applogo"]];
    
    NSURL *url = [[NSURL alloc]initWithString:self.spaceURL];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:webView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
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
