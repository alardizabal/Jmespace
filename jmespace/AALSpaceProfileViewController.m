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
#import "AALAddDetailViewController.h"
#import <AFNetworking.h>
#import <Parse/Parse.h>

@interface AALSpaceProfileViewController ()

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) NSString *parseObjectID;

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
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"applogo"]];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plus_square"] style:UIBarButtonItemStylePlain target:self action:@selector(addDetail:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
    
    UILabel *spaceName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, self.view.bounds.size.height/2)];
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
                
                UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 170, self.view.bounds.size.width - 20, 20)];
                addressLabel.text = object[@"Address"];
                addressLabel.textColor = [UIColor whiteColor];
                [self.view addSubview:addressLabel];
                
                self.spaceToDisplay.websiteURL = object[@"Website"];
                self.parseObjectID = object.objectId;
                
                UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [websiteButton addTarget:self action:@selector(spaceWebsite:) forControlEvents:UIControlEventTouchUpInside];
                [websiteButton setTitle:@"Website" forState:UIControlStateNormal];
                [websiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                websiteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                websiteButton.frame = CGRectMake(10, self.view.bounds.size.height - 200, 60, 25);
                [self.view addSubview:websiteButton];
                
                
                
                [self showImageScroll];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) showImageScroll
{
    
    NSUInteger imageViewStartX = 0;
    
    UIImage *image = [UIImage imageNamed:@"wework_placeholder"];
    
    NSArray *tempImageArray = [[NSArray alloc]initWithObjects:image, image, image, image, image, nil];
    
    UIView *imageContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tempImageArray count] * 100, 100)];
    
    for (NSUInteger i = 0; i < [tempImageArray count]; i++) {
        UIImageView *spaceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewStartX, 0, 100, 100)];
        spaceImageView.contentMode = UIViewContentModeScaleAspectFit;
        spaceImageView.image = tempImageArray[i];
        
        [imageContentView addSubview:spaceImageView];
        
        imageViewStartX += 100;
    }
    
    UIScrollView *imageScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 140, self.view.bounds.size.width - 20, 100)];
    
    imageScrollView.scrollEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.contentSize = CGSizeMake([tempImageArray count] * 100, 100);
    
    [self.view addSubview:imageScrollView];
    [imageScrollView addSubview:imageContentView];
    
}

- (IBAction)spaceWebsite:(id)sender
{
    
    AALSpaceWebsiteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"spaceWebsite"];
    vc.spaceURL = self.spaceToDisplay.websiteURL;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)addDetail:(id)sender
{
    
    AALAddDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addDetailVC"];
    vc.parseObjectID = self.parseObjectID;
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
