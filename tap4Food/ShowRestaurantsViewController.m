//
//  ShowRestaurantsViewController.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "ShowRestaurantsViewController.h"
#import "RestaurantCollection.h"
#import "Restaurant.h"

@interface ShowRestaurantsViewController () {
    UIActivityIndicatorView *activityIndicator;
    Restaurant *randomRestaurant;
}
@end

//View Elements




@implementation ShowRestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setupPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupPage {
    [self setupActivityIndicator];
//    [self setupRestaurants];
}

-(void) setupActivityIndicator {
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void) setupRestaurants {
    RestaurantCollection *newCollection = [[RestaurantCollection alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [newCollection setupRestaurantsWith:_latitude and:_longitude];

        //Keep looping until dataLoaded is YES
        while([newCollection dataLoaded] == NO) {}
        randomRestaurant = [newCollection pickRandomRestaurant];
        [self setupView];
    });
}

-(void) setupView {
    
}

-(UIActivityIndicatorView *)activityIndicator {
    if(!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    }
    return activityIndicator;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
