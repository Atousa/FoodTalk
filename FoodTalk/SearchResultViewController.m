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


@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, ResultsTableViewCellDelegate>



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
    
    
    [self searchForFoodPlaces:
     self.locationFromWatson searchString:self.searchTerm];
    
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
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"%@", placemark.addressDictionary);
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
    NSMutableArray *categories = [NSMutableArray new];
    
    NSData *data = [NSData dataWithContentsOfURL:businessOfMany.imageURL];
    NSData *ratingImageData = [NSData dataWithContentsOfURL:businessOfMany.ratingImgURL];
    cell.yelpImageView.image = [UIImage imageWithData:data];
    cell.yelpRatingImageView.image = [UIImage imageWithData:ratingImageData];
    
    NSString *streetAddress = [businessOfMany.location.displayAddress objectAtIndex:0];

    cell.yelpRestaurantTitleAddress.text = [NSString stringWithFormat:@"%@ \n %@ \n %@, %@", businessOfMany.name, streetAddress, businessOfMany.location.city, businessOfMany.location.stateCode];
    
    NSLog(@"%@", businessOfMany.name);
    for (YLPCategory *category in businessOfMany.categories) {
        [categories addObject:category.name];
    }
    
    
    
    
//    self.restaurantName.textColor = makeWhiteTextColor;
//    self.restaurantName.font = makeFontAndSize;
//    self.restaurantName.text = businessOfMany.name;
//    
//    self.restaurantStreet.textColor = makeWhiteTextColor;
//    self.restaurantStreet.font = makeFontAndSize;
//    self.restaurantStreet.text = [businessOfMany.location.displayAddress objectAtIndex:0];
    
    
//
//    Set the textLabel color, font, and text
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.font = [UIFont fontWithName:@"Copperplate" size:21];
//    cell.textLabel.text = businessOfMany.name;
//    cell.detailTextLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Black" size:16];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", categories];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)resultsTableViewCell:(id)cell didFavoriteButton:(UIButton *)favoriteButton {
    
    UIImage *checkedBox = [UIImage imageNamed:@"Checkedbox"];
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox"];
    restaurantDescriptor *rd = [[restaurantDescriptor alloc] init];
    long index = [self.searchTableView indexPathForCell:cell].row;
    YLPBusiness *business = self.arrayOfBusinesses[index];
    rd.name = business.name;
    rd.state = business.location.stateCode;
    rd.city = business.location.countryCode;
    rd.address = business.location.address[0];
    rd.country = business.location.countryCode;
    rd.latitude = business.location.coordinate.latitude;
    rd.longitude = business.location.coordinate.longitude;
    //NSLog(@"%@,%@,%@,%@,%@,%f,%f", rd.name, rd.address, rd.city, rd.state, rd.country, rd.latitude, rd.longitude);

    if ([favoriteButton.imageView.image isEqual: uncheckedBox]) {
        [CDM addRestaurant: rd presentViewController: self];
        [favoriteButton setImage:checkedBox forState:UIControlStateNormal];
    } else {
        Restaurant *r = [CDM findRestaurant:rd];
        [CDM deleteObject:r];
        [favoriteButton setImage:uncheckedBox forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end