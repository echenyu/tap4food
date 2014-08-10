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
    self.canDisplayBannerAds = YES;
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
    UIColor *navigationBarColor = [UIColor colorWithRed:49.0f/255.0f
                                                  green:87.0f/255.0f
                                                   blue:161.0f/255.0f
                                                  alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:navigationBarColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Tap4Food";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Zapfino" size:14], NSFontAttributeName, nil]];
    
    //Setup the settings bar button now
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsSegue)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:24], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
}

-(void)settingsSegue {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}
                                              
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"pushSegue"]) {
        CLLocation *currentLocation = [self.currentLocationManager location];
        float latitude = currentLocation.coordinate.latitude;
        float longitude = currentLocation.coordinate.longitude;
        RestaurantsViewController *rViewController = [segue destinationViewController];
        rViewController.latitude = latitude;
        rViewController.longitude = longitude;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    if([[segue identifier] isEqualToString:@"settingsSegue"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}
@end
