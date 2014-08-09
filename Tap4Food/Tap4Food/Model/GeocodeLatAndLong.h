//
//  GeocodeLatAndLong.h
//  Tap4Food
//
//  Created by Eric Yu on 8/8/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeocodeLatAndLong : NSObject

-(id)init;
-(void)geocodeAddress: (NSString *)address;

@property (nonatomic, strong) NSDictionary *latAndLong;

@end
