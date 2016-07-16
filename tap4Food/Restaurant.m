//
//  Restaurant.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "Restaurant.h"


@interface Restaurant () {
    
}
@end

@implementation Restaurant

-(void) setupRestaurantWith: (NSDictionary *)restaurantJSON {
    self.phoneNumber = [restaurantJSON objectForKey:@"display_phone"];
    self.restaurantName = [restaurantJSON objectForKey:@"name"];
    self.restaurantAddress = [self createAddressForRestaurant:restaurantJSON];
    self.numberOfRatings = (int)[restaurantJSON objectForKey:@"review_count"];
    self.restaurantDescription = [restaurantJSON objectForKey:@"snippet_text"];
    self.restaurantURL = [restaurantJSON objectForKey:@"url"];
    self.restaurantRatingImgUrl = [restaurantJSON objectForKey:@"rating_img_url"];
    self.distanceFromLocation = [[restaurantJSON objectForKey:@"distance"]doubleValue];
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

@end


