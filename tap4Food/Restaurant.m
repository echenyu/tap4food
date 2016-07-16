//
//  Restaurant.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "Restaurant.h"

static float const METER_TO_MILE = 0.00086763;

@interface Restaurant () {
    
}
@end

@implementation Restaurant

-(void) setupRestaurantWith: (NSDictionary *)restaurantJSON {
    //NSStrings to initialize
    self.phoneNumber = [restaurantJSON objectForKey:@"display_phone"];
    self.restaurantName = [restaurantJSON objectForKey:@"name"];
    self.restaurantAddress = [self createAddressForRestaurant:restaurantJSON];
    self.restaurantDescription = [restaurantJSON objectForKey:@"snippet_text"];
    
    //URLs to initialize
    self.restaurantURL = [self createUrlWith:restaurantJSON and: @"mobile_url"];
    self.restaurantRatingImgUrl = [self createUrlWith:restaurantJSON and: @"rating_img_url"];
    self.restaurantPictureURL = [self createUrlWith:restaurantJSON and:@"image_url"];
    
    //Doubles to initialize
    self.distanceFromLocation = [[restaurantJSON objectForKey:@"distance"]doubleValue] * METER_TO_MILE;
    self.numberOfRatings = (int)[restaurantJSON objectForKey:@"review_count"];

}


-(NSString *) createAddressForRestaurant: (NSDictionary *) currentRestaurant{
    NSDictionary *addressDictionary = [currentRestaurant objectForKey:@"location"];
    NSArray *address = [addressDictionary objectForKey:@"display_address"];
    NSString *addressString = [[NSString alloc]init];
    
    for (int i = 0; i < [address count]; i++) {
        addressString = [addressString stringByAppendingString:[address objectAtIndex:i]];
        if(i != [address count] - 1) {
            addressString = [addressString stringByAppendingString:@", "];
        }
    }
    
    return addressString;
}

-(NSURL *)createUrlWith: (NSDictionary *)restaurantJSON and: (NSString *)key{
    NSMutableString *urlString = [restaurantJSON objectForKey:key];
    NSLog(@"%@", urlString);
//    [urlString insertString:@"s" atIndex:4];
    return [NSURL URLWithString:urlString];
}
@end


