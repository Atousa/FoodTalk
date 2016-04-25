//
//  SearchFoodViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/24/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchFoodViewController.h"

@interface SearchFoodViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property NSString *consumerKey;
@property NSString *consumerSecret;
@property NSString *token;
@property NSString *tokenSecret;

@property YLPSearch *searchResult;
@property NSMutableArray *businessResult;
@property NSMutableArray *arrayOfBusinesses;

@end

@implementation SearchFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    
    [client searchWithLocation:_locationFromWatson currentLatLong:nil term:_searchTerm limit:_searchLimit offset:_searchOffset sort:_searchSort completionHandler:^(YLPSearch * _Nullable search, NSError * _Nullable error) {
        for (YLPBusiness *business in self.businessResult) {
            [self.arrayOfBusinesses addObject:business];
        }
        [self.searchTableView reloadData];
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell" forIndexPath:indexPath];
    
    YLPBusiness *business = self.arrayOfBusinesses[indexPath.row];
    
    
//    let business = self.arrayOfBusinesses[indexPath.row]
    
    cell.textLabel.text = business.name;
//    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f of %lu reviews.", business.rating, (unsigned long)business.reviewCount];
    cell.imageView.image = [UIImage imageNamed:@"watson"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
