//
//  LocationObjC.m
//  FoodTalk
//
//  Created by Atousa Duprat on 5/5/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "LocationObjC.h"
#import "SearchResultViewController.h"

@implementation LocationObjC

-(void)initStuff:(id <CLLocationManagerDelegate>)VC {
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationObtained = NO;
    self.locationQuery = YES;
    self.locationManager.delegate = VC;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestLocation];
    }
}

-(void)alertEnableLocationServicesRequired:(UIViewController *)viewController {
    if (self.locationQuery == NO) {
    }
    
    self.locationQuery = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You must enable location services to get search results" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
