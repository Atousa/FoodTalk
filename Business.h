//
//  Business.h
//  FoodTalk
//
//  Created by Eric Hong on 5/3/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLPBusiness.h"

@interface Business : NSObject

@property (nonatomic, strong) YLPBusiness * yelpBusiness;
@property (nonatomic) BOOL expanded;

+(Business*)initWithYelpBusiness:(YLPBusiness * )yelpBusiness;

@end
