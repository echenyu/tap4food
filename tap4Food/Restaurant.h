//
//  Restaurant.h
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface Restaurant : NSObject

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *restaurantAddress;
@property (nonatomic, strong) NSString *restaurantDescription;

@property (nonatomic, strong) NSURL *restaurantURL;
@property (nonatomic, strong) NSURL *restaurantRatingImgUrl;
@property (nonatomic, strong) NSURL *restaurantPictureURL;

@property double distanceFromLocation;
@property int numberOfRatings;

//Public Methods
-(void) setupRestaurantWith: (NSDictionary *)restaurantJSON; 

@end
