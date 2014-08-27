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
#import "AALSpaceProfileViewController.h"
#import "AALSpaceCustomCellTableViewCell.h"
#import "AALSpaceObject.h"
#import "AALConstants.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>


@interface AALViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D location2D;

@property (nonatomic) CGFloat currentLatitude;
@property (nonatomic) CGFloat currentLongitude;

@property (nonatomic) UITableView *spaceTableView;

@property (nonatomic) NSMutableArray *places;
@property (nonatomic) NSArray *parsePlaces;

@property (nonatomic) GMSCameraPosition *camera;
@property (nonatomic) GMSMapView *mapView;

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
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];

    // Setup - Map
    
    self.camera = [GMSCameraPosition cameraWithLatitude:40.705091
                                              longitude:-74.013506
                                                   zoom:15];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 200) camera:self.camera];
    
    self.mapView.myLocationEnabled = YES; // Notification to allow location services should pop up
    
    [self.view addSubview:self.mapView];
    
    // Setup - Table View (Heights: search bar = 44, map = 150
    
    self.spaceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 244, self.view.bounds.size.width, self.view.bounds.size.height - 200 - 44 - 44 - 20) style:UITableViewStylePlain];
    [self.view addSubview:self.spaceTableView];
    
    self.spaceTableView.delegate = self;
    self.spaceTableView.dataSource = self;
    [self.spaceTableView setSeparatorInset:UIEdgeInsetsZero];   // Removes leading space at beginning of row in a table view
    
    // Navigation Controller
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:searchBar];
    
    [self getLocationButtonPressed:nil];
    
}

- (IBAction)getLocationButtonPressed:(UIBarButtonItem *)sender {
    
    [self.locationManager startUpdatingLocation];
    
//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//        if (!error) {
//            
//            NSLog(@"%@", geoPoint);
//            PFGeoPoint *test = geoPoint;
//            NSLog(@"%f", test.latitude);
//            NSLog(@"%f", test.longitude);
//            
//            NSOperationQueue *parseQuery = [[NSOperationQueue alloc]init];
//            
//            [parseQuery addOperationWithBlock:^{
//                PFQuery *query = [PFQuery queryWithClassName:@"Space"];
//                // Interested in locations near user.
//                [query whereKey:@"location" nearGeoPoint:test withinMiles:1];
//                // Limit what could be a lot of points.
//                query.limit = 10;
//                // Final list of objects
//                self.parsePlaces = [query findObjects];
//                NSLog(@"Places %@", self.parsePlaces);
//                
//                NSLog(@"PlaceID %@", self.parsePlaces[0][@"PlaceId"]);
//                NSLog(@"Name %@", self.parsePlaces[0][@"name"]);
//                
//            }];
//        }
//    }];
    
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
    
    AALSpaceObject *tempObject = [[AALSpaceObject alloc]init];
    tempObject = self.places[indexPath.row];
    //tempObject = self.parsePlaces[indexPath.row];
    
    AALSpaceCustomCellTableViewCell *cell = (AALSpaceCustomCellTableViewCell *)[self.spaceTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AALSpaceCustomCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *placeName = tempObject.name;
    NSString *placeAddress = tempObject.address;
    
    cell.name.text = placeName;
    cell.address.text = placeAddress;
    
    if ([tempObject.openNow integerValue] == 1) {
        cell.open.backgroundColor = kMintColor;
    } else {
        cell.open.backgroundColor = kBubbleGumColor;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AALSpaceProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"spaceProfileView"];
    profileVC.spaceToDisplay = self.places[indexPath.row];
    
    [self.navigationController pushViewController:profileVC animated:YES];
    
}

// Change height of table view row
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50.0;
//}

-(void)queryGooglePlaces {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=50000&types=&name=wework&key=%@", self.location2D.latitude, self.location2D.longitude, kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            GMSCameraPosition *updatedCamera = [GMSCameraPosition cameraWithLatitude:self.location2D.latitude
                                                                           longitude:self.location2D.longitude
                                                                                zoom:12];
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
        //The results from Google will be in an array obtained from the NSDictionary object with the key "results".
        
        NSArray *tempArray = [json objectForKey:@"results"];
        
        for (NSUInteger i = 0; i < [tempArray count]; i++) {
            
            AALSpaceObject *tempSpaceObject = [[AALSpaceObject alloc]init];
            tempSpaceObject.name = tempArray[i][@"name"];
            tempSpaceObject.address = tempArray[i][@"vicinity"];
            tempSpaceObject.placeID = tempArray[i][@"place_id"];
            tempSpaceObject.openNow = tempArray[i][@"opening_hours"][@"open_now"];
            tempSpaceObject.latitude = tempArray[i][@"geometry"][@"location"][@"lat"];
            tempSpaceObject.longitude = tempArray[i][@"geometry"][@"location"][@"lng"];
            tempSpaceObject.photoReference = tempArray[i][@"photos"][0][@"photo_reference"];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([tempSpaceObject.latitude doubleValue], [tempSpaceObject.longitude doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = tempSpaceObject.name;
            marker.map = self.mapView;
            marker.appearAnimation = kGMSMarkerAnimationPop;
            
            [self.places addObject:tempSpaceObject];
            
        }
        
        //NSLog(@"%@", tempArray[0][@"photos"]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
