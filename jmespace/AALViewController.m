//
//  AALViewController.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/6/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AALViewController.h"
#import "AALSpaceCustomCellTableViewCell.h"
#import "AALSpaceObject.h"
#import "AALConstants.h"
#import "MBProgressHUD.h"


@interface AALViewController () {
    GMSMapView *_mapView;
}

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D location2D;

@property (nonatomic) CGFloat currentLatitude;
@property (nonatomic) CGFloat currentLongitude;

@property (nonatomic) UITableView *spaceTableView;

@property (nonatomic) NSMutableArray *places;

@property (nonatomic) GMSCameraPosition *camera;

@end

@implementation AALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"applogo"]];
    
    // Setup - Location Manager
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    self.locationManager.distanceFilter = kCLLocationAccuracyBest;     // Update location after position changes
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    
    self.location = [[CLLocation alloc] init];
    
    // Setup - Map
    
    self.camera = [GMSCameraPosition cameraWithLatitude:40.705091
                                              longitude:-74.013506
                                                   zoom:15];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height/2) camera:self.camera];
    
    _mapView.myLocationEnabled = YES; // Notification to allow location services should pop up
    
    [self.view addSubview:_mapView];
    
    // Setup - Table View
    
    self.spaceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2) style:UITableViewStylePlain];
    [self.view addSubview:self.spaceTableView];
    
    self.spaceTableView.delegate = self;
    self.spaceTableView.dataSource = self;
    [self.spaceTableView setSeparatorInset:UIEdgeInsetsZero];   // Removes leading space at beginning of row in a table view
    
}

- (IBAction)getLocationButtonPressed:(UIBarButtonItem *)sender {
    
    [self.locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    self.location2D = [self.location coordinate];
    NSLog(@"%f %f", self.location2D.latitude, self.location2D.longitude);
    
    [self.locationManager stopUpdatingLocation];
    
    // Call Google Places API
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSOperationQueue *queryGooglePlacesAPI = [[NSOperationQueue alloc]init];
        [queryGooglePlacesAPI addOperationWithBlock:^{
            [self queryGooglePlaces];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"spaceCell";
    
    AALSpaceCustomCellTableViewCell *cell = (AALSpaceCustomCellTableViewCell *)[self.spaceTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AALSpaceCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *placeName = self.places[indexPath.row][@"name"];
    NSString *placeAddress = self.places[indexPath.row][@"vicinity"];
    
    cell.name.text = placeName;
    cell.address.text = placeAddress;
    
    NSUInteger r = arc4random_uniform(11);
    
    switch (r) {
            
        case 10:
            cell.backgroundColor = kGuppieGreenColor;
            break;
            
        case 9:
            cell.backgroundColor = kFawnColor;
            break;
            
        case 8:
            cell.backgroundColor = kLinenColor;
            break;
            
        case 7:
            cell.backgroundColor = kTurquoiseColor;
            break;
            
        case 6:
            cell.backgroundColor = kBubbleGumColor;
            break;
            
        case 5:
            cell.backgroundColor = kAmberColor;
            break;
            
        case 4:
            cell.backgroundColor = kLavenderColor;
            break;
            
        case 3:
            cell.backgroundColor = kRedColor;
            break;
            
        case 2:
            cell.backgroundColor = kMintColor;
            break;
            
        case 1:
            cell.backgroundColor = kYellowColor;
            break;
            
        case 0:
            cell.backgroundColor = kBlueColor;
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

-(void)queryGooglePlaces {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&types=&name=bank&key=%@", self.location2D.latitude, self.location2D.longitude, kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            GMSCameraPosition *updatedCamera = [GMSCameraPosition cameraWithLatitude:self.location2D.latitude
                                                                           longitude:self.location2D.longitude
                                                                                zoom:17];
            [_mapView setCamera:updatedCamera];
            
            [self.spaceTableView reloadData];
        }];
    });
}

-(void)fetchedData:(NSData *)responseData {
    
    self.places = [NSMutableArray new];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"%@", json);
    
    if ([json objectForKey:@"results"]) {
        //The results from Google will be an array obtained from the NSDictionary object with the key "results".
        self.places = [json objectForKey:@"results"];
        
        //Write out the data to the console.
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        for (NSUInteger i = 0; i < [self.places count]; i++) {
            AALSpaceObject *tempSpaceObject = [[AALSpaceObject alloc]init];
            tempSpaceObject.name = self.places[i][@"name"];
            tempSpaceObject.address = self.places[i][@"vicinity"];
            tempSpaceObject.placeID = self.places[i][@"place_id"];
            tempSpaceObject.latitude = [self.places[i][@"geometry"][@"location"][@"lat"] floatValue];
            tempSpaceObject.longitude = [self.places[i][@"geometry"][@"location"][@"lon"] floatValue];
            
            [tempArray addObject:tempSpaceObject];
        }
        
        NSLog(@"%@", tempArray[0]);
        //NSLog(@"%@", self.places[0][@"vicinity"]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
