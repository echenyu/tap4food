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
@import GoogleMaps;

@interface ShowRestaurantsViewController () {
    UIActivityIndicatorView *activityIndicator;
    Restaurant *randomRestaurant;
    GMSMapView *restaurantMapView;
}

//View Elements
@property (nonatomic, weak) IBOutlet UILabel *phoneNumber;
@property (nonatomic, weak) IBOutlet UILabel *restaurantName;
@property (nonatomic, weak) IBOutlet UILabel *restaurantAddress;
@property (nonatomic, weak) IBOutlet UILabel *numberOfRatings;
@property (nonatomic, weak) IBOutlet UILabel *restaurantDescription;
@property (nonatomic, weak) IBOutlet UILabel *distanceFromLocation;
@property (nonatomic, weak) IBOutlet UIImageView *restaurantPicture;
@property (nonatomic, weak) IBOutlet UIImageView *restaurantRating;
@property (nonatomic, weak) IBOutlet UIView *restaurantMap;

@end


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
    [self setupRestaurants];
}

-(void) setupActivityIndicator {
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
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
    [self.activityIndicator stopAnimating];
    self.phoneNumber.text = randomRestaurant.phoneNumber;
    self.restaurantName.text = randomRestaurant.restaurantName;
    self.restaurantDescription.text = randomRestaurant.restaurantDescription;
    self.numberOfRatings.text = [NSString stringWithFormat:@"%i reviews", randomRestaurant.numberOfRatings];
    self.distanceFromLocation.text = [NSString stringWithFormat:@"%.2f miles", randomRestaurant.distanceFromLocation];
    self.restaurantAddress.text = randomRestaurant.restaurantAddress;

    self.restaurantPicture.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:randomRestaurant.restaurantPictureURL]];
    self.restaurantRating.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL: randomRestaurant.restaurantRatingImgUrl]];
    [self setupMap];
}

-(void) setupMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_latitude
                                                            longitude:_longitude
                                                                 zoom:15];
    restaurantMapView = [GMSMapView mapWithFrame:self.restaurantMap.bounds camera:camera];
    restaurantMapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_latitude, _longitude);
    marker.map = restaurantMapView;
    
    [self.restaurantMap addSubview: restaurantMapView];
}

-(UIActivityIndicatorView *)activityIndicator {
    if(!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    }
    return activityIndicator;
}

-(IBAction)openYelp:(id)sender {
    if([[UIApplication sharedApplication]canOpenURL:randomRestaurant.restaurantURL]) {
        [[UIApplication sharedApplication]openURL:randomRestaurant.restaurantURL];
    }
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
