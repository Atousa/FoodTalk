//
//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;


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
    
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    
//    YLPCoordinate *coordinate = [[YLPCoordinate alloc]initWithLatitude:(37.7) longitude:-122.40];
    
    self.searchTerm = @"food";
    
    [client searchWithLocation:@"San Francisco, CA" currentLatLong:nil term:self.searchTerm limit:10 offset:1 sort:2 completionHandler:^(YLPSearch *search, NSError *error) {
        for (YLPBusiness *business in search.businesses) {
            NSLog(@"%@", business);
            [self.arrayOfBusinesses addObject:business];
            NSLog(@"Array of Businesses: %@", self.arrayOfBusinesses);
        }
        [self.searchTableView reloadData];
        NSLog(@"%@", self.arrayOfBusinesses);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    YLPBusiness *businessOfMany = self.arrayOfBusinesses[indexPath.row];
    
    cell.textLabel.text = businessOfMany.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f of %lu reviews.", businessOfMany.rating, (unsigned long)businessOfMany.reviewCount];
    cell.imageView.image = [UIImage imageNamed:@"watson"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
