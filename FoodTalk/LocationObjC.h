//
//  LocationObjC.h
//  FoodTalk
//
//  Created by Atousa Duprat on 5/5/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationObjC : CLLocation <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property BOOL locationObtained;
@property BOOL locationQuery;
@property CLLocation *location;
@property NSMutableString *locationAddress;

-(void)initStuff:(UIViewController *)VC;
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;
-(void)alertEnableLocationServicesRequired:(UIViewController *)viewController;


@end
