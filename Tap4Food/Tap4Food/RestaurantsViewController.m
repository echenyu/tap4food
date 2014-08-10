//
//  RestaurantsViewController.m
//  Tap4Food
//
//  Created by Eric Yu on 7/28/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "OAuthConsumer.h"
#import <GHUnitIOS/GHUnit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GeocodeLatAndLong.h"

@interface RestaurantsViewController () {
    NSDictionary *resultsFromYelp;
    NSArray *restaurantsFromYelp;
    double restaurantLongitude;
    double restaurantLatitude;
    double restaurantDistance;
    NSString* phoneCallNumber;
}

@property (weak, nonatomic) IBOutlet UIView *googleMap;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPicture;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantRating;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRatings;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDescription;
@property (weak, nonatomic) IBOutlet UILabel *distanceFromCurrent;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UIImageView *yelpImage;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreOnYelpText;

@property (nonatomic, strong)NSString *restaurantUrl;
@property (strong,nonatomic)GMSMapView *mapView;
@property (strong, nonatomic) NSNumber *numberOfMetersFilter;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIImage *restaurantImage;
@property (nonatomic, strong)CLLocationManager *currentLocationManager;
@property (nonatomic, strong)GeocodeLatAndLong *gc;

@end

@implementation RestaurantsViewController

-(UIActivityIndicatorView *)activityIndicator {
    if(!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center=CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    }
    return _activityIndicator;
}

-(UIImage *)restaurantImage {
    if (!_restaurantImage) {
        _restaurantImage = [[UIImage alloc]init];
    }
    return _restaurantImage;
}

-(GeocodeLatAndLong *)gc {
    if (!_gc) {
        _gc = [[GeocodeLatAndLong alloc]init];
    }
    return _gc;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
}

-(NSString *)restaurantUrl {
    if (!_restaurantUrl) {
        _restaurantUrl = [[NSString alloc]init];
    }
    return _restaurantUrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    //Set the number of meters to search around.
    int metersFilter = (int)[settings integerForKey:@"numberOfMeters"];
    if(!metersFilter) {
        self.numberOfMetersFilter = [NSNumber numberWithInt: 5000];
    } else {
        self.numberOfMetersFilter = [NSNumber numberWithInt:metersFilter];
    }

    
    //Set things about the navigation controller here.
    self.title = @"Tap4Food";
    
    //Turns off the back navigation by swiping on the edge of the screen
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Zapfino" size:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
   
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Tap4FoodBarButton"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style: UIBarButtonItemStylePlain target:self action:@selector(pickRandomRestaurant)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
   
    //Adjust things on the storyboard here!
    self.errorLabel.hidden = YES;
    self.restaurantName.adjustsFontSizeToFitWidth = YES;
    self.restaurantName.minimumScaleFactor = 8/20;
    self.restaurantAddress.adjustsFontSizeToFitWidth = YES;
    self.restaurantAddress.userInteractionEnabled = YES;
    self.phoneNumber.userInteractionEnabled = YES;
    self.phoneNumber.adjustsFontSizeToFitWidth = YES;
    self.distanceFromCurrent.adjustsFontSizeToFitWidth = YES;
    [self.currentLocationManager startUpdatingLocation];
    [self.restaurantDescription sizeToFit];
    [self setupRestaurants];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setLatAndLong)
                                                name:@"t4fLatAndLongReceived"
                                              object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.currentLocationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Setup all restaurants when the view is first loaded.
-(void)setupRestaurants {
    //Use Oauth to authorize the user/the app to use Yelp's API
    OAConsumer *consumer = [[OAConsumer alloc]initWithKey:@"D2WSy72QA5ilrtzEq7U-kg" secret:@"7WzTKp11knWN3dFT4MkjPjuiCk4"];
    
    OAToken *token = [[OAToken alloc]initWithKey:@"2wgDXaivi_U-uFRGL4jNMnsVkyQqoZPU" secret:@"LdGfbZ4Bi6Q3eW7zEWLPhIJWReM"];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc]init];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=restaurants&sort=1&ll=%f,%f&radius_filter=%i",_latitude,_longitude, [self.numberOfMetersFilter intValue]];
    
    NSURL *URL = [NSURL URLWithString: urlString];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]initWithURL:URL
                                                                  consumer:consumer
                                                                     token:token
                                                                     realm:nil
                                                         signatureProvider:provider];
    
    [request setHTTPMethod:@"GET"];
    [request prepare];
    
    NSURLSessionTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(!error) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *businesses = [jsonDictionary objectForKey:@"businesses"];
            NSLog(@"%@ is error", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                resultsFromYelp = jsonDictionary;
                restaurantsFromYelp = businesses;
                [self pickRandomRestaurant];
                [self.activityIndicator stopAnimating];
            });
        } else {
            NSLog(@"ughhh error");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                self.errorLabel.text = @"Connection Error! Try again or \n wait until you have a data connection";
                [self setupErrorLabel];
            });

        }
        
    }];
    
    [task resume];
}

-(void)pickRandomRestaurant {
    int numberOfRestaurants = (int)[restaurantsFromYelp count];
    int randomRestaurantNumber = arc4random()%numberOfRestaurants;
    
    if(numberOfRestaurants == 0) {
        self.errorLabel.text = @"No restaurants found nearby! Change the distance filter in settings";
        [self setupErrorLabel];
    } else {
        NSDictionary *pickedRestaurant = [restaurantsFromYelp objectAtIndex:randomRestaurantNumber];
        NSURL *imageUrl;
        NSData *imageData;
        
        NSLog(@"%@", pickedRestaurant);
        if([pickedRestaurant objectForKey:@"image_url"] == nil) {
            imageUrl = [[NSURL alloc]init];
        } else {
            imageUrl = [[NSURL alloc]initWithString:[pickedRestaurant objectForKey:@"image_url"]];
        }
        
        if(imageUrl == nil) {
            imageData = [[NSData alloc]init];
        } else {
            imageData = [[NSData alloc]initWithContentsOfURL:imageUrl];
            self.restaurantPicture.image = [UIImage imageWithData:imageData];
        }
        
    //Everything regarding the phone number is here
        NSString *phoneNumber = [pickedRestaurant objectForKey:@"display_phone"];
        
        NSMutableAttributedString *attributedPhoneNumber = [self setupAttributedLinkString:phoneNumber];
        self.phoneNumber.attributedText = attributedPhoneNumber;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(phoneCallRecognizer)];
        [self.phoneNumber addGestureRecognizer:tapGesture];

    //Set the restaurant name label
        self.restaurantName.text = [pickedRestaurant objectForKey:@"name"];
        
        
    //EVerything regarding the address is put in here
        NSDictionary *addressDictionary = [pickedRestaurant objectForKey:@"location"];
        NSArray *address = [addressDictionary objectForKey:@"display_address"];
        NSString *addressString = [[NSString alloc]init];
        
        for (int i = 0; i < [address count]; i++) {
            addressString = [addressString stringByAppendingString:[address objectAtIndex:i]];
            if(i != [address count] - 1) {
                addressString = [addressString stringByAppendingString:@", "];
            }
        }
        
        NSMutableAttributedString *attributedAddress = [self setupAttributedLinkString:addressString];
        self.restaurantAddress.attributedText = attributedAddress;
        
        UITapGestureRecognizer *tapForAddress = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(openAddress)];
        [self.restaurantAddress addGestureRecognizer:tapForAddress];
        self.restaurantAddress.textAlignment = NSTextAlignmentCenter;

        
    //Setup images for the restaurant
        NSURL *ratingImgURL;
        NSData *ratingImgData;
        if([pickedRestaurant objectForKey:@"rating_img_url"] == nil) {
            ratingImgURL = [[NSURL alloc]init];
        } else {
            ratingImgURL = [[NSURL alloc]initWithString:[pickedRestaurant objectForKey:@"rating_img_url"]];
        }
        
        if(ratingImgURL == nil) {
            ratingImgData = [[NSData alloc]init];
        } else {
            ratingImgData = [[NSData alloc]initWithContentsOfURL:ratingImgURL];
            self.restaurantRating.image = [UIImage imageWithData:ratingImgData];
        }
        
        restaurantDistance = [[pickedRestaurant objectForKey:@"distance"]doubleValue];
        
        self.numberOfRatings.text = [NSString stringWithFormat:@"%@ reviews", [pickedRestaurant objectForKey:@"review_count"] ];
        
        self.restaurantDescription.text = [pickedRestaurant objectForKey:@"snippet_text"];
        
        self.restaurantUrl = [pickedRestaurant objectForKey:@"url"];
        
        phoneCallNumber = [pickedRestaurant objectForKey:@"phone"];
        [self.seeMoreOnYelpText setTitle:@"See more on" forState:UIControlStateNormal];
        
        NSLog(@"%@", [pickedRestaurant objectForKey:@"phone"]);
      
        self.distanceFromCurrent.text = [NSString stringWithFormat: @"%.2f miles",restaurantDistance* 0.00086763];
        
        self.phoneIcon.image = [UIImage imageNamed:@"phoneImage"];
        self.locationIcon.image = [UIImage imageNamed:@"Location"];
        self.yelpImage.image = [UIImage imageNamed:@"yelpLogo"];
        [self setupMap];
        [self getLatAndLong:addressString];
    }
}

-(void)setupMap {
    [self.mapView removeFromSuperview];
    int zoomLevel = [self zoomLevel];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:zoomLevel];
    self.mapView = [GMSMapView mapWithFrame:self.googleMap.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.googleMap addSubview: self.mapView];
    
}

-(void)addMarker {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(restaurantLatitude, restaurantLongitude);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = self.mapView;
    NSLog(@"%f and %f", restaurantLatitude, restaurantLongitude);

}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"%@ locations", locations);
}

-(int)zoomLevel {
    if(restaurantDistance < 100) {
        return 16;
    } else if(restaurantDistance < 200) {
        return 15;
    } else if(restaurantDistance < 600) {
        return 14;
    } else if(restaurantDistance < 1000) {
        return 13;
    } else if (restaurantDistance < 2000) {
        return 12;
    } else {
        return 11;
    }
}

-(void)phoneCallRecognizer {
    NSLog(@"%@", phoneCallNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneCallNumber]]];
}

-(void)getLatAndLong: (NSString *)addressString {
    [[self gc] geocodeAddress:addressString];
    
}

-(void)setLatAndLong {
    NSString *gcRestaurantLat = [[[self gc] latAndLong]objectForKey:@"lat"];
    NSString *gcRestaurantLong = [[[self gc] latAndLong]objectForKey:@"lng"];
    restaurantLatitude = [gcRestaurantLat doubleValue];
    restaurantLongitude = [gcRestaurantLong doubleValue];
    NSLog(@"%f and %f", restaurantLatitude, restaurantLongitude);

    [self addMarker];
}

- (IBAction)goToYelp:(id)sender {
    NSURL *restaurantURL = [NSURL URLWithString:self.restaurantUrl];
    if([[UIApplication sharedApplication]canOpenURL:restaurantURL]) {
        [[UIApplication sharedApplication]openURL:restaurantURL];
    }
}

-(void)setupErrorLabel {
    self.errorLabel.hidden = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.errorLabel setTextColor:[UIColor colorWithRed:49.0f/255.0f
                                                 green:87.0f/255.0f
                                                  blue:161.0f/255.0f
                                                 alpha:1.0f]];
    
}

-(NSMutableAttributedString *)setupAttributedLinkString: (NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blueColor]
                              range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                              value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                              range:NSMakeRange(0, [attributedString length])];
    return attributedString;
}

-(void)openAddress {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Open in Maps" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", @"Copy Address", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        //Apple Maps
        NSString* address = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", self.restaurantName.text];
        NSURL* url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (buttonIndex==1) {
        //Google Maps
        NSString *address = [NSString stringWithFormat: @"comgooglemaps://?q=%@+%@", self.restaurantAddress.text, self.restaurantName.text];
        
        NSURL *url = [[NSURL alloc]initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            //left as an exercise for the reader: open the Google Maps mobile website instead!
        } else {
             NSString *address = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@+%@", self.restaurantAddress.text, self.restaurantName.text];
            NSURL *url = [[NSURL alloc]initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (buttonIndex == 2) {
        [[UIPasteboard generalPasteboard] setString:self.restaurantAddress.text];
    }
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
