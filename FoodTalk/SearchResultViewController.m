//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ResultsTableViewCell.h"
#import "FoodTalk-Swift.h"
#import <MapKit/MapKit.h>



@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, ResultsTableViewCellDelegate, MKMapViewDelegate>

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;

#pragma mark - Properties
@property NSString *consumerKey;
@property NSString *consumerSecret;
@property NSString *token;
@property NSString *tokenSecret;

@property YLPSearch *searchResult;
@property NSMutableArray *arrayOfBusinesses;

@property CLLocationManager *locationManager;
@property CLLocation *location;
@property NSString *myAddress;
@property MKPointAnnotation *restaurantAnnotation;


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantAnnotation = [[MKPointAnnotation alloc]init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];

    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.arrayOfBusinesses = [NSMutableArray new];
    
    
    [self searchForFoodPlaces:self.locationFromWatson searchString:self.searchTerm];
    
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
    
    [client searchWithLocation:place currentLatLong:nil term:searchString limit:10 offset:1 sort:2 completionHandler:^(YLPSearch *search, NSError *error) {
        [self.searchActivityIndicator startAnimating];
        restaurantDescriptor *r = [[restaurantDescriptor alloc] init];
        for (YLPBusiness *business in search.businesses) {
            r.name = business.name;
            r.address = business.location.address[0];
            r.city = business.location.city;
            r.latitude = business.location.coordinate.latitude;
            r.longitude = business.location.coordinate.longitude;
            if (![CDM findRestaurant:r]) {
                [self.arrayOfBusinesses addObject:business];
            }
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

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
//            self.myAddress = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
        }
    }];
}



#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    cell.delegateCheckmark = self;
    
    
    YLPBusiness *businessOfMany = self.arrayOfBusinesses[indexPath.row];
    
    //    Get the categories from an array and append them into a string
    NSMutableString *restaurantCategory = [[NSMutableString alloc] init];
    int i = 0;
    for (YLPCategory *category in businessOfMany.categories) {
        if (i>0) {
            [restaurantCategory appendFormat:@", "];
        }
        [restaurantCategory appendFormat:@"%@",category.name];
        i++;
    }
    
    //    Set the food imageView and rating imageView
    NSData *data = [NSData dataWithContentsOfURL:businessOfMany.imageURL];
    NSData *ratingImageData = [NSData dataWithContentsOfURL:businessOfMany.ratingImgURLLarge];
    cell.yelpImageView.image = [UIImage imageWithData:data];
    cell.yelpRatingImageView.image = [UIImage imageWithData:ratingImageData];
    
    //    Display the restaurant name + address, also set the number of reviews
    NSString *streetAddress = [businessOfMany.location.displayAddress objectAtIndex:0];
    
    cell.yelpRestaurantTitleAddress.text = [NSString stringWithFormat:@"%@ \n\n%@ \n%@, %@ \n%@", businessOfMany.name, streetAddress, businessOfMany.location.city, businessOfMany.location.stateCode, restaurantCategory];
    cell.yelpNumOfReviews.text = [NSString stringWithFormat:@"(%0.1lu Reviews)", (unsigned long)businessOfMany.reviewCount];
    cell.yelpRestaurantTitleAddress.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    
    //    Set up the annotation of the restaurant mapView
    double restaurantLatitude = businessOfMany.location.coordinate.latitude;
    double restaurantLongitude = businessOfMany.location.coordinate.longitude;
    self.restaurantAnnotation.coordinate = CLLocationCoordinate2DMake(restaurantLatitude, restaurantLongitude);
    [cell.restaurantMapView addAnnotation:self.restaurantAnnotation];
    MKCoordinateRegion region = MKCoordinateRegionMake(self.restaurantAnnotation.coordinate, MKCoordinateSpanMake(0.03, 0.03));
    [cell.restaurantMapView setRegion:region animated:YES];

    // Set favorite button state to unchecked
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox-100"];
    [cell.favoriteButton setImage:uncheckedBox forState:UIControlStateNormal];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Delegate method from ResultsTableViewCell

-(void)resultsTableViewCell:(id)cell didFavoriteButton:(UIButton *)favoriteButton {
    
    UIImage *checkedBox = [UIImage imageNamed:@"Checkedbox-100"];
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox-100"];
    restaurantDescriptor *rd = [[restaurantDescriptor alloc] init];
    long index = [self.searchTableView indexPathForCell:cell].row;
    YLPBusiness *business = self.arrayOfBusinesses[index];
    rd.name = business.name;
    rd.state = business.location.stateCode;
    rd.city = business.location.city;
    rd.address = business.location.address[0];
    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: business.location.countryCode forKey: NSLocaleCountryCode]];
    
    NSString *countryName = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
    rd.country = countryName;
    NSLog(@"Country Name: %@ (%@)", countryName, business.location.countryCode);
    rd.latitude = business.location.coordinate.latitude;
    rd.longitude = business.location.coordinate.longitude;
    NSString *longCategory = @"";
    for (YLPCategory *category in business.categories) {
        longCategory=[longCategory stringByAppendingString:category.name];
        longCategory=[longCategory stringByAppendingString:@" "];
    }
    rd.type = longCategory;

    if ([favoriteButton.imageView.image isEqual: uncheckedBox]) {
        [CDM addRestaurant: rd presentViewController: self];
        [favoriteButton setImage:checkedBox forState:UIControlStateNormal];
    } else {
        Restaurant *r = [CDM findRestaurant:rd];
        if (r != nil) {
            [CDM deleteObject:r];
        }
        [favoriteButton setImage:uncheckedBox forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
