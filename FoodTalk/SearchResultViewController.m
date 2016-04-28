//
//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property double latitude;
@property double longitude;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;


@property NSString *consumerKey;
@property NSString *consumerSecret;
@property NSString *token;
@property NSString *tokenSecret;


@property YLPSearch *searchResult;
@property NSMutableArray *arrayOfBusinesses;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfBusinesses = [NSMutableArray new];
    
    self.searchTableView.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    self.latitude = 0;
    self.longitude = 0;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.searchActivityIndicator startAnimating];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.searchTerm = self.type;
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;

    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    
    //Eric you have latitude and Longitude(look at @property), now you can use these to make this search dynamic, I have already changed the searchTerm , now it searches based on the user preferences. You also have distance (@property NSString *type;@property NSString *distance; in case that you want to do search based on the distance
 


    [client searchWithLocation:@"San Francisco, CA" currentLatLong:nil term:self.searchTerm limit:10 offset:1 sort:2 completionHandler:^(YLPSearch *search, NSError *error) {
        for (YLPBusiness *business in search.businesses) {
            [self.arrayOfBusinesses addObject:business];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    YLPBusiness *businessOfMany = self.arrayOfBusinesses[indexPath.row];
    NSMutableArray *categories = [NSMutableArray new];
    
    
    for (YLPCategory *category in businessOfMany.categories) {
        [categories addObject:category.name];
        NSLog(@"%@", categories);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
