//
//  Tap4FoodViewController.m
//  Tap4Food
//
//  Created by Eric Yu on 7/28/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "Tap4FoodViewController.h"
#import "OAuthConsumer.h"
#import <YAJLiOS/YAJL.h>
#import <GHUnitIOS/GHUnit.h>
#import "RestaurantsViewController.h"

@interface Tap4FoodViewController ()
@property (nonatomic,strong)CLLocationManager *currentLocationManager;

@end

@implementation Tap4FoodViewController

-(CLLocationManager *)currentLocationManager {
    if (!_currentLocationManager) {
        _currentLocationManager = [[CLLocationManager alloc]init];
        _currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _currentLocationManager.delegate = self;
        
    }
    return _currentLocationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)generateRandomRestaurants:(id)sender {
    [self performSegueWithIdentifier:@"pushSegue" sender:self];
}

-(void)setup {
    //Set the color of the navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CLLocation *currentLocation = [self.currentLocationManager location];
    float latitude = currentLocation.coordinate.latitude;
    float longitude = currentLocation.coordinate.longitude;
    RestaurantsViewController *rViewController = [segue destinationViewController];
    rViewController.latitude = latitude;
    rViewController.longitude = longitude;
}
@end
