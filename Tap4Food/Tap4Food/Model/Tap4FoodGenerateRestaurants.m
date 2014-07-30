//
//  Tap4FoodGenerateRestaurants.m
//  Tap4Food
//
//  Created by Eric Yu on 7/30/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "Tap4FoodGenerateRestaurants.h"

@implementation Tap4FoodGenerateRestaurants

-(void)generateRestaurants {
    //        NSArray *keys = [jsonDictionary allKeys];
    //        NSArray *values = [jsonDictionary allValues];
    NSArray *businesses = [self.restaurantData objectForKey:@"businesses"];
    for (NSDictionary* dictionary in businesses) {
        NSLog(@"I need phone numbers: %@",[dictionary objectForKey:@"display_phone"]);
    }
    NSDictionary *phoneNumbers = [businesses objectAtIndex:0];
    // NSLog(@"%@", phoneNumbers);
    
};

@end
