//
//  TapScreenViewController.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "TapScreenViewController.h"
#import "ShowRestaurantsViewController.h"
@import CoreLocation;

@interface TapScreenViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager; 
@end

@implementation TapScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"tap4FoodSegue"]) {
        float latitude = self.locationManager.location.coordinate.latitude;
        float longitude = self.locationManager.location.coordinate.longitude;

        ShowRestaurantsViewController *srViewController = [segue destinationViewController];
        srViewController.longitude = longitude;
        srViewController.latitude = latitude;
    }
    if([[segue identifier] isEqualToString:@"settingsSeque"]) {
        //Do nothing for the settings segue
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if ([identifier isEqualToString:@"tap4FoodSegue"] && (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied || [CLLocationManager locationServicesEnabled] == NO)) {
        UIAlertController *locationServicesDisabledAlert = [UIAlertController alertControllerWithTitle:@"Location Services Disabled"
                                                                                               message:@"Enable location services in settings to use this application."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *settingsButton = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self goToSettings];
        }];
        
        [locationServicesDisabledAlert addAction:okButton];
        [locationServicesDisabledAlert addAction:settingsButton];
        
        [self presentViewController:locationServicesDisabledAlert animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

-(void) goToSettings {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    });
}

@end
