//
//  SearchResultViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DetailFoodViewController.h"

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
    self.searchTableView.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.token tokenSecret:self.tokenSecret];
    
    self.searchTerm = @"food";
    
    [client searchWithLocation:@"San Francisco, CA" currentLatLong:nil term:self.searchTerm limit:10 offset:1 sort:2 completionHandler:^(YLPSearch *search, NSError *error) {
        for (YLPBusiness *business in search.businesses) {
            [self.arrayOfBusinesses addObject:business];
        }
        [self.searchTableView reloadData];
    }];
}

#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfBusinesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];

    YLPBusiness *businessOfMany = self.arrayOfBusinesses[indexPath.row];
    
//    Set the background color of tableView and text color
    cell.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Copperplate" size:21];
    
    cell.textLabel.text = businessOfMany.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f of %lu reviews.", businessOfMany.rating, (unsigned long)businessOfMany.reviewCount];
    cell.imageView.image = [UIImage imageNamed:@"watson"];
    
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailFoodViewController *destVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.searchTableView indexPathForCell:sender];
    destVC.selectedBusiness = self.arrayOfBusinesses[indexPath.row];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
