//
//  RestaurantCollection.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "RestaurantCollection.h"
#import "OAuthConsumer.h"

static NSString *const YELP_BASE_URL = @"https://api.yelp.com/v2/search?term=food&sort=1&ll=%f,%f";

@interface RestaurantCollection () {
    OAConsumer *consumer;
    OAToken *token;
    NSArray *jsonArrayFromYelp;
    NSMutableArray *restaurantsArray;
}

@end

@implementation RestaurantCollection

-(void) setupRestaurantsWith: (float)latitude and: (float)longitude {
    _dataLoaded = NO;
    NSString *requestUrl = [self createYelpUrlWith:latitude and:longitude];
    
    OAMutableURLRequest *request = [self setupOAuthWithUrl:requestUrl];

    [request setHTTPMethod:@"GET"];
    [request prepare];
    
    
    NSURLSessionTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(!error) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *businesses = [jsonDictionary objectForKey:@"businesses"];
            jsonArrayFromYelp = businesses;
            [self setupRestaurantsArray];
            _dataLoaded = YES;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
               //Segue back to the home page and alert user that there was error
            });
            _dataLoaded = YES; 
        }
    }];
    [task resume];
}

-(Restaurant *) pickRandomRestaurant {
    //If yelp returns 0 results, we return nil as a result from restaurant collection
    if([restaurantsArray count] == 0) {
        return nil;
    }
    
    int randomNumber = arc4random()%[restaurantsArray count];
    return [restaurantsArray objectAtIndex:randomNumber]; 
}

-(OAMutableURLRequest *) setupOAuthWithUrl: (NSString *) requestUrl {
    consumer = [[OAConsumer alloc]initWithKey:@"D2WSy72QA5ilrtzEq7U-kg" secret:@"7WzTKp11knWN3dFT4MkjPjuiCk4"];
    token = [[OAToken alloc]initWithKey:@"wdrLuP1YWDcOWcJlMpWMU8WbnQFgPgL6" secret:@"x_nYbE2w3HkUnoNKbYQXJzY_wFI"];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc]init];
    NSURL *URL = [NSURL URLWithString: requestUrl];
    
    return [[OAMutableURLRequest alloc]initWithURL:URL
                                          consumer:consumer
                                             token:token
                                             realm:nil
                                 signatureProvider:provider];
}

-(NSString *) createYelpUrlWith: (float) latitude and: (float)longitude {
    return [NSString stringWithFormat:YELP_BASE_URL, latitude, longitude];
}


-(void) setupRestaurantsArray {
    restaurantsArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [jsonArrayFromYelp count]; i++) {
        Restaurant *newRestaurant = [[Restaurant alloc]init];
        NSDictionary *currentRestaurant = [jsonArrayFromYelp objectAtIndex:i];
        [newRestaurant setupRestaurantWith: currentRestaurant];
        [restaurantsArray addObject:newRestaurant];
    }
}


@end
