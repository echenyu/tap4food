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
@property (nonatomic, strong) NSString *restaurantURL;
@property (nonatomic, strong) NSString *restaurantRatingImgUrl;

@property (nonatomic, strong) UIImage *restaurantPicture;

@property double distanceFromLocation;
@property int numberOfRatings;

//Public Methods
-(void) setupRestaurantWith: (NSDictionary *)restaurantJSON; 

@end
