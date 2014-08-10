//
//  AALProfileViewController.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/8/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import "AALSpaceProfileViewController.h"
#import "AALConstants.h"
#import "AALSpaceWebsiteViewController.h"
#import <AFNetworking.h>
#import <Parse/Parse.h>

@interface AALSpaceProfileViewController ()

@property (nonatomic) UIImageView *backgroundImageView;

@end

@implementation AALSpaceProfileViewController

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
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.image = [UIImage imageNamed:@"wework_placeholder"];
    self.backgroundImageView.clipsToBounds = YES;
    
    
    if (self.spaceToDisplay.photoReference) {
        
        NSString *imageURL = [NSString stringWithFormat:@"%@?maxheight=1600&photoreference=%@&key=%@", kGPLACES_PHOTOS_API_URL, self.spaceToDisplay.photoReference, kGOOGLE_API_KEY];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *spaceImage = [UIImage imageWithData:imageData];
        self.backgroundImageView.image = spaceImage;
        
//        CIImage *imageToBlur = [[CIImage alloc]initWithImage: spaceImage];
//        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"
//                                          keysAndValues:kCIInputImageKey, imageToBlur, @"inputRadius", @(5.0), nil];
//        
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIImage *outputImage = [blurFilter outputImage];
//        CGImageRef outImage = [context createCGImage:outputImage fromRect: [outputImage extent]];
//        self.backgroundImageView.image = [UIImage imageWithCGImage:outImage];
        
    }
    
    [self.view addSubview:self.backgroundImageView];
    
    NSString *unformattedSpaceString = self.spaceToDisplay.name;
    NSString *formattedSpaceString = [unformattedSpaceString stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    
    UILabel *spaceName = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    spaceName.font = [UIFont boldSystemFontOfSize:48];
    spaceName.textColor = [UIColor whiteColor];
    spaceName.text = formattedSpaceString;
    spaceName.numberOfLines = 0;
    
    [self.view addSubview:spaceName];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Space"];
    [query whereKey:@"PlaceID" equalTo:self.spaceToDisplay.placeID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {

            for (PFObject *object in results) {
                
                UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 100, self.view.bounds.size.width - 10, 20)];
                addressLabel.text = object[@"Address"];
                addressLabel.textColor = [UIColor whiteColor];
                [self.view addSubview:addressLabel];
                
                self.spaceToDisplay.websiteURL = object[@"Website"];
                
                UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [websiteButton addTarget:self action:@selector(spaceWebsite:) forControlEvents:UIControlEventTouchUpInside];
                [websiteButton setTitle:@"Website" forState:UIControlStateNormal];
                [websiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                websiteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                websiteButton.frame = CGRectMake(10, self.view.bounds.size.height - 150, 60, 30);
                [self.view addSubview:websiteButton];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)spaceWebsite:(id)sender
{
    
    AALSpaceWebsiteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"spaceWebsite"];
    vc.spaceURL = self.spaceToDisplay.websiteURL;
    [self.navigationController pushViewController:vc animated:YES];

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
