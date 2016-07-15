//
//  RestaurantCollection.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "RestaurantCollection.h"
#import "Restaurant.h"

static NSString *const YELP_BASE_URL = @"http://api.yelp.com/v2/search?term=restaurants&sort=1&ll=%f,%f";

@implementation RestaurantCollection

-(void) setupRestaurantsWith: (float)latitude and: (float)longitude {
    NSString *requestUrl = [self createYelpUrlWith:latitude and:longitude];
}

-(NSString *) createYelpUrlWith: (float) latitude and: (float)longitude {
    return [NSString stringWithFormat:YELP_BASE_URL, latitude,longitude];
}

@end
