//
//  RestaurantCollection.h
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantCollection : NSObject

-(void) setupRestaurantsWith: (float)latitude and:(float)longitude;
-(Restaurant *) pickRandomRestaurant;

@property BOOL dataLoaded;
@end
