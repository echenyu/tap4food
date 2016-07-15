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
@property (nonatomic, strong) NSString *restaurantsName;
@property (nonatomic, strong) NSString *restaurantAddress;
@property (nonatomic, strong) NSString *numberOfRatings;
@property (nonatomic, strong) NSString *distanceFromLocation;
@property (nonatomic, strong) NSString *restaurantDescription;
@property (nonatomic, strong) NSString *restaurantURL;

@property (nonatomic, strong) UIImage *restaurantPicture;


@end
