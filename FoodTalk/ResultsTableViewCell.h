//
//  ResultsTableViewCell.h
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol ResultsTableViewCellDelegate

@optional

-(void)resultsTableViewCell:(id)cell didFavoriteButton:(UIButton *)favoriteButton;

@end

@interface ResultsTableViewCell : UITableViewCell

@property (nonatomic, assign) id<ResultsTableViewCellDelegate>delegateCheckmark;

@property (weak, nonatomic) IBOutlet UIImageView *yelpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yelpRatingImageView;
@property (weak, nonatomic) IBOutlet UITextView *yelpRestaurantTitleAddress;
@property (weak, nonatomic) IBOutlet UITextView *yelpNumOfReviews;
@property (weak, nonatomic) IBOutlet MKMapView *restaurantMapView;



@end
