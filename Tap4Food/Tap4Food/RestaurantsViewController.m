//
//  RestaurantsViewController.m
//  Tap4Food
//
//  Created by Eric Yu on 7/28/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "OAuthConsumer.h"
#import <YAJLiOS/YAJL.h>
#import <GHUnitIOS/GHUnit.h>

@interface RestaurantsViewController () {
    NSDictionary *resultsFromYelp;
    NSArray *restaurantsFromYelp;
}
@property (nonatomic, strong)NSDictionary *yelpResults;
@property (nonatomic, strong)NSMutableData *actualYelpResults;
@property (nonatomic, strong)NSAttributedString *phoneNumbers;
@property (nonatomic, strong)NSString *restaurantName;


@end

@implementation RestaurantsViewController

-(NSDictionary *)yelpResults {
    if (!_yelpResults) {
        _yelpResults = [[NSDictionary alloc]init];
    }
    return _yelpResults;
}

-(NSMutableData *)actualYelpResults {
    if(!_actualYelpResults) {
        _actualYelpResults = [[NSMutableData alloc]init];
    }
    return _actualYelpResults;
}

-(NSAttributedString *)phoneNumbers {
    if(!_phoneNumbers) {
        _phoneNumbers = [[NSAttributedString alloc]init];
    }
    return _phoneNumbers;
}

-(NSString *)restaurantName {
    if(!_restaurantName) {
        _restaurantName = [[NSString alloc]init];
    }
    return _restaurantName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setupRestaurants];
    [self pickRandomRestaurant];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)pickRandomRestaurant {
    NSLog(@"IS there anything here yet %@", restaurantsFromYelp);
    for (NSDictionary* dictionary in restaurantsFromYelp) {
        NSLog(@"I need phone numbers: %@",[dictionary objectForKey:@"display_phone"]);
    }
}

- (IBAction)button:(id)sender {
//    NSLog(@"%@ stuff", self.yelpResults);
//    NSLog(@"%@ other stuff", self.actualYelpResults);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
