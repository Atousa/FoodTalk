//
//  YlpClientViewController.h
//  FoodTalk
//
//  Created by Eric Hong on 4/20/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//
#pragma mark - imports

#import <UIKit/UIKit.h>
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

@interface YlpClientViewController : UIViewController

@property NSString *consumerKey;
@property NSString *consumerSecret;
@property NSString *token;
@property NSString *tokenSecret;

#pragma mark - Search With Location Methods

-(void)searchWithLocation:(NSString *)location
           currentLatLong:(nullable YLPCurrentLatLong *)cll
                     term:(nullable NSString *)term
                    limit:(NSUInteger)limit
                   offset:(NSUInteger)offset sort:(NSUInteger)sort
        completionHandler:(YLPSearchCompletionHandler)completionHandler;

-(void)searchWithLocation:(NSString *)location
        completionHandler:(YLPSearchCompletionHandler)completionHandler;

#pragma mark - Search with Geographic Bounding Box Methods

-(void)searchWithBounds:(YLPGeoBoundingBox *)bounds
         currentLatLong:(nullable YLPCurrentLatLong *)cll
                   term:(nullable NSString *)term
                  limit:(NSUInteger)limit
                 offset:(NSUInteger)offset
                   sort:(NSUInteger)sort
      completionHandler:(YLPSearchCompletionHandler)completionHandler;

-(void)searchWithBounds:(YLPGeoBoundingBox *)bounds completionHandler:(YLPSearchCompletionHandler)completionHandler;

#pragma mark - Search With Geographic Coordinate Methods

-(void)searchWithGeoCoordinate:(YLPGeoCoordinate *)geoCoordiante currentLatLong:(nullable YLPCurrentLatLong *)cll term:(nullable NSString *)term limit:(NSUInteger)limit offset:(NSUInteger)offset sort:(NSUInteger)sort completionHandler:(YLPSearchCompletionHandler)completionHandler;

-(void)searchWithGeoCoordinate:(YLPCoordinate *)geoCoordiante completionHandler:(YLPSearchCompletionHandler)completionHandler;

#pragma mark - Business Methods

-(void)businessWithId:(NSString *)businessId
          countryCode:(nullable NSString *)countryCode
         languageCode:(nullable NSString *)countryCode
         languageCode:(nullable NSString *)languageCode
       languageFilter:(BOOL)languageFilter
          actionLinks:(BOOL)actionLinks
    completionHandler:(YLPBusinessCompletionHandler)completionHandler;

-(void)businessWithId:(NSString *)businessId completionHandler:(YLPBusinessCompletionHandler)completionHandler;

#pragma mark - Phone Search Methods

-(void)businessWithPhoneNumber:(NSString *)phoneNumber
                   countryCode:(nullable NSString *)countryCode
                      category:(nullable NSString *)category
             completionHandler:(YLPPhoneSearchCompletionHandler)completionHandler;

-(void)businessWithPhoneNumber:(NSString *)phoneNumber completionHandler:(YLPPhoneSearchCompletionHandler)completionHandler;






@end
