//
//  Business.m
//  FoodTalk
//
//  Created by Eric Hong on 5/3/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "Business.h"

@implementation Business

+(Business *)initWithYelpBusiness:(YLPBusiness *)yelpBusiness
{
    Business * business = [[Business alloc] init];
    business.yelpBusiness = yelpBusiness;
    business.expanded = false;
    
    return business;
}

@end
