//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;


@property NSString *consumerKey;
@property NSString *consumerSecret;
@property NSString *token;
@property NSString *tokenSecret;

@property YLPSearch *searchResult;
@property NSMutableArray *arrayOfBusinesses;

@property CLLocationManager *locationManager;
@property CLLocation *location;
@property NSString *myAddress;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.arrayOfBusinesses = [NSMutableArray new];
    
    self.searchTableView.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    [self searchForFoodPlaces:@"San Francisco, CA" searchString:self.searchTerm];
    
}

-(void)instantiateYelpAuthTokens {
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
}

-(void)searchForFoodPlaces:(NSString *)place searchString:(NSString *)searchString {
    [self instantiateYelpAuthTokens];
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    
    self.searchTerm = @"thai food";
    
    [client searchWithLocation:@"11121 Flanagan Lane Germantown, MD" currentLatLong:nil term:self.searchTerm limit:10 offset:1 sort:2 completionHandler:^(YLPSearch *search, NSError *error) {
        [self.searchActivityIndicator startAnimating];
        for (YLPBusiness *business in search.businesses) {
            [self.arrayOfBusinesses addObject:business];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchTableView reloadData];
            [self.searchActivityIndicator stopAnimating];
        });
    }];
}

#pragma mark - Location methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    self.location = [locations lastObject];
    NSLog(@"%f", self.location.coordinate.latitude);
}
//  Atousa, fix this please. We need to grab the location
//- (void)reverseGeocode:(CLLocation *)location {
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Finding address");
//        if (error) {
//            NSLog(@"Error %@", error.description);
//        } else {
//            CLPlacemark *placemark = [placemarks lastObject];
//            self.myAddress = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
//        }
//    }];
//}



#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    YLPBusiness *businessOfMany = self.arrayOfBusinesses[indexPath.row];
    NSMutableArray *categories = [NSMutableArray new];
    
    
    for (YLPCategory *category in businessOfMany.categories) {
        [categories addObject:category.name];
        
    }
    
    //    Set the background color of tableView
    cell.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0];
    
    //    Set the textLabel color, font, and text
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Copperplate" size:21];
    cell.textLabel.text = businessOfMany.name;
    
    //    Set the detailTextLabel text, font
    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Black" size:16];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", categories];
    
    
    
    //    Set the imageView's image and size
    NSData *data = [NSData dataWithContentsOfURL:businessOfMany.imageURL];
    cell.imageView.image = [UIImage imageWithData:data];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end