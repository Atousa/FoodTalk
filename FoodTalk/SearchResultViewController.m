//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ResultsTableViewCell.h"
#import "FoodTalk-Swift.h"
#import "Business.h"
#import <MapKit/MapKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LocationObjC.h"


@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource,  ResultsTableViewCellDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

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

@property MKPointAnnotation *restaurantAnnotation;
@property MKPointAnnotation *currentLocationAnnotation;
@property CLPlacemark *placemark;

@property CGFloat heightOfCell;

@property CLLocationManager *locationManager;
@property LocationObjC *locationClass;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightOfCell = 185;
    
//    Capitalize the first letter of the search term
    NSString *foo = [NSString stringWithFormat:@"%@", self.searchTerm];
    NSString *upperCase = [[foo substringToIndex:1]uppercaseString];
    NSString *lowerCase = [[foo substringFromIndex:1] lowercaseString];
    self.navigationItem.title = [upperCase stringByAppendingString:lowerCase];
    
    self.restaurantAnnotation = [[MKPointAnnotation alloc]init];

    self.arrayOfBusinesses = [NSMutableArray new];
    
    
    self.locationClass = [[LocationObjC alloc] init];
    [self.locationClass initStuff:self];
}

-(void)instantiateYelpAuthTokens {
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
}

-(double)calculateDistance:(CLLocation*)destination {
    double distanceMeters = [self.locationYelpVC distanceFromLocation:destination];
    double distanceKM = distanceMeters / 1000.0;
    double distanceMI = distanceKM * 0.621371;
    return distanceMI;
}


-(double)computeUserRange:(NSString *)distance {
    
    if([distance isEqual:@"2 blocks"] || [distance isEqual:@"2 Blocks"]) {
        return 0.2*0.621371; // 200m in mi
    } else if([distance isEqual:@"6 blocks"] || [distance isEqual:@"6 Blocks"]) {
        return 0.6*0.621371; // 600m in mi
    } else if([distance isEqual:@"1 mile"] || [distance isEqual:@"1 Mile"]) {
        return 1.; // 1 mi
    } else if([distance isEqual:@"5 miles"] || [distance isEqual:@"6 Blocks"]) {
        return 5.; // 5 mi
    } else if([distance isEqual:@"6 blocks"] || [distance isEqual:@"6 Blocks"]) {
        return 20.; // 20. mi
    }

    return 99999.;
}


-(void)searchForFoodPlaces:(NSString *)place searchString:(NSString *)searchString {
    [self instantiateYelpAuthTokens];
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    if (place == nil) {
        place = [[NSString alloc] init];
    }
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
                if (self.locationYelpVC != nil) {
                    CLLocation *destination = [[CLLocation alloc] initWithLatitude:business.location.coordinate.latitude longitude:business.location.coordinate.longitude];
                    double distanceToDest = [self calculateDistance:destination];
                    if(distanceToDest <= [self computeUserRange:self.distance]) {
                        NSLog(@"%@ = %f mi (accepted)", r.name, distanceToDest);
                        Business * yelpBusiness = [Business initWithYelpBusiness:business];
                        [self.arrayOfBusinesses addObject:yelpBusiness];
                    } else {
                        NSLog(@"%@ = %f mi (rejected)", r.name, distanceToDest);
                    }
                } else {
                    // if no location, no distance-based filtering
                    Business * yelpBusiness = [Business initWithYelpBusiness:business];
                    [self.arrayOfBusinesses addObject:yelpBusiness];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchTableView reloadData];
            [self.searchActivityIndicator stopAnimating];
        });
    }];
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    cell.delegateCheckmark = self;
    [cell.yelpRestaurantTitleAddress sizeToFit];
    
    Business * businessOfMany = self.arrayOfBusinesses[indexPath.row];
    
    //    Get the categories from an array and append them into a string
    NSMutableString *restaurantCategory = [[NSMutableString alloc] init];
    int i = 0;
    for (YLPCategory *category in businessOfMany.yelpBusiness.categories) {
        if (i>0) {
            [restaurantCategory appendFormat:@", "];
        }
        [restaurantCategory appendFormat:@"%@",category.name];
        i++;
    }
    
    //    Set the food imageView and rating imageView
    [cell.yelpImageView setImageWithURL:businessOfMany.yelpBusiness.imageURL];
    [cell.yelpRatingImageView setImageWithURL:businessOfMany.yelpBusiness.ratingImgURLLarge];
    
    //    Display the restaurant name + address, also set the number of reviews
    NSString *streetAddress = [businessOfMany.yelpBusiness.location.displayAddress objectAtIndex:0];
    
    cell.yelpRestaurantTitleAddress.text = [NSString stringWithFormat:@"%@ \n\n%@ \n%@, %@ \n%@", businessOfMany.yelpBusiness.name, streetAddress, businessOfMany.yelpBusiness.location.city, businessOfMany.yelpBusiness.location.stateCode, restaurantCategory];
    cell.yelpNumOfReviews.text = [NSString stringWithFormat:@"(%0.1lu Reviews)", (unsigned long)businessOfMany.yelpBusiness.reviewCount];
    cell.yelpRestaurantTitleAddress.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    
//    Set up the annotation of the restaurant mapView
    double restaurantLatitude = businessOfMany.yelpBusiness.location.coordinate.latitude;
    double restaurantLongitude = businessOfMany.yelpBusiness.location.coordinate.longitude;
    self.restaurantAnnotation.coordinate = CLLocationCoordinate2DMake(restaurantLatitude, restaurantLongitude);
    [cell.restaurantMapView addAnnotation:self.restaurantAnnotation];
    
//    Zooms in on the region
    MKCoordinateRegion region = MKCoordinateRegionMake(self.restaurantAnnotation.coordinate, MKCoordinateSpanMake(0.03, 0.03));
    [cell.restaurantMapView setRegion:region animated:YES];

    // Set favorite button state to unchecked
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox-100"];
    [cell.favoriteButton setImage:uncheckedBox forState:UIControlStateNormal];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGRect tblViewCellHeight = [tableView rectForRowAtIndexPath:indexPath];
//    CGFloat collapsedHeight = 185;
//    CGFloat expandedHeight = 375;
    
//    if (tblViewCellHeight.size.height == collapsedHeight) {
//        self.heightOfCell = expandedHeight;
//        
//    } else {
//        self.heightOfCell = collapsedHeight;
//    }
    Business *business = self.arrayOfBusinesses[indexPath.row];
    
    if (business.expanded) {
        business.expanded = false;
    } else {
        business.expanded = true;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *rowToReload = [NSArray arrayWithObjects:indexPath, nil];
    [tableView reloadRowsAtIndexPaths:rowToReload withRowAnimation:UITableViewRowAnimationNone];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat collapsedHeight = 185;
    CGFloat expandedHeight = 375;
    
    Business *business = self.arrayOfBusinesses[indexPath.row];

    if (business.expanded) {
        return expandedHeight;
    }
    return collapsedHeight;
}


#pragma mark - Delegate method from ResultsTableViewCell

-(void)resultsTableViewCell:(id)cell didFavoriteButton:(UIButton *)favoriteButton {
    
    UIImage *checkedBox = [UIImage imageNamed:@"Checkedbox-100"];
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox-100"];
    restaurantDescriptor *rd = [[restaurantDescriptor alloc] init];
    long index = [self.searchTableView indexPathForCell:cell].row;
    Business *business = self.arrayOfBusinesses[index];
    rd.name = business.yelpBusiness.name;
    rd.state = business.yelpBusiness.location.stateCode;
    rd.city = business.yelpBusiness.location.city;
    rd.address = business.yelpBusiness.location.address[0];
    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: business.yelpBusiness.location.countryCode forKey: NSLocaleCountryCode]];
    
    NSString *countryName = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
    rd.country = countryName;
    rd.latitude = business.yelpBusiness.location.coordinate.latitude;
    rd.longitude = business.yelpBusiness.location.coordinate.longitude;
    NSString *longCategory = @"";
    for (YLPCategory *category in business.yelpBusiness.categories) {
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    self.locationClass.locationObtained = YES;
    if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
        self.locationClass.location = location;
        [self reverseGeoCode:location];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
        [self.locationClass alertEnableLocationServicesRequired:self];

}

-(void)reverseGeoCode: (CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.locationClass.locationAddress = [NSMutableString stringWithFormat:@""];
        if ([placemark subThoroughfare] != nil) {
            [self.locationClass.locationAddress appendFormat:@"%@", placemark.subThoroughfare];
        }
        if ([placemark thoroughfare] != nil) {
            [self.locationClass.locationAddress appendFormat:@" %@", placemark.thoroughfare];
        }
        if ([placemark locality] != nil) {
            [self.locationClass.locationAddress appendFormat:@" %@", placemark.locality];
        }
        if ([placemark administrativeArea] != nil) {
            [self.locationClass.locationAddress appendFormat:@", %@", placemark.administrativeArea];
        }
        
        NSLog(@"%@", self.locationClass.locationAddress);
        
        [self searchForFoodPlaces:self.locationClass.locationAddress searchString:self.searchTerm];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
