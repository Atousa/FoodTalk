//
//  SearchResultViewController.h
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "YLPBusiness.h"
#import "YLPCategory.h"
#import "YLPClient.h"
#import "YLPClient+Business.h"
#import "YLPClient+PhoneSearch.h"
#import "YLPClient+Search.h"
#import "YLPClientPrivate.h"
#import "YLPCommonPrivate.h"
#import "YLPCoordinate.h"
#import "YLPCoordinateDelta.h"
#import "YLPDeal.h"
#import "YLPDealOption.h"
#import "YLPGeoBoundingBox.h"
#import "YLPGeoCoordinate.h"
#import "YLPGiftCertificate.h"
#import "YLPGiftCertificateOption.h"
#import "YLPLocation.h"
#import "YLPPhoneSearch.h"
#import "YLPRegion.h"
#import "YLPResponsePrivate.h"
#import "YLPReview.h"
#import "YLPSearch.h"
#import "YLPSortType.h"
#import "YLPUser.h"


@interface SearchResultViewController : UIViewController

@property CLLocation *locationYelpVC;
@property NSString *locationAddressYelpVC;
@property NSString *searchTerm;
@property NSUInteger searchLimit;
@property NSUInteger searchSort;
@property NSUInteger searchOffset;
@property NSString *distance;

-(void)searchForFoodPlaces:(NSString *)place searchString:(NSString *)searchString;

@end
