//
//  GeocodeLatAndLong.m
//  Tap4Food
//
//  Created by Eric Yu on 8/8/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "GeocodeLatAndLong.h"

@implementation GeocodeLatAndLong

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

-(id)init {
    self = [super init];
    self.latAndLong = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0", @"lat", @"0.0", @"long", nil];
    return self;
}

-(void)geocodeAddress:(NSString *)address {
    NSString *googleURL = @"https://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", googleURL, address];
    NSString* string = [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *query = [NSURL URLWithString:string];
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:query];
        [self fetchedData:data];
    });
}

-(void)fetchedData: (NSData *)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    NSArray *results = [json objectForKey:@"results"];
    NSDictionary *result = [results objectAtIndex:0];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    NSString *lat = [location objectForKey:@"lat"];
    NSString *lng = [location objectForKey:@"lng"];
    NSDictionary *gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
    self.latAndLong = gc;
    NSLog(@"%@", gc);
    
    //Doing this for now to wait for the information to finish being parsed before calling a method in the Restaurants view controller. Try to think of a different way to do this. 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"t4fLatAndLongReceived" object:nil];
}
@end
