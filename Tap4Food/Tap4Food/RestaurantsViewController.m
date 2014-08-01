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

@interface RestaurantsViewController () {
    NSDictionary *resultsFromYelp;
    NSArray *restaurantsFromYelp;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPicture;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantRating;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRatings;
@property (weak, nonatomic) IBOutlet UILabel *restaurantDescription;


@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIImage *restaurantImage;
@property (nonatomic, strong)CLLocationManager *currentLocationManager;

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

-(void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Make sure the user can't change the phone number
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.title = @"Tap4Food";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Zapfino" size:14], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.phoneNumber.enabled = NO;
    self.restaurantAddress.enabled = NO;
    self.restaurantName.adjustsFontSizeToFitWidth = YES;
    self.restaurantAddress.adjustsFontSizeToFitWidth = YES;
    [self.currentLocationManager startUpdatingLocation];
    
    [self setupRestaurants];
    
    //ADD observers here
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activitySpinnerEnd)
                                                name:@"NSURLSessionNotification"
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Setup all restaurants when the view is first loaded.
-(void)setupRestaurants {
    //Get user's location information from here
    
    
    NSLog(@"%f latitude. %f longitude", _latitude, _longitude);
    
    //Use Oauth to authorize the user/the app to use Yelp's API
    OAConsumer *consumer = [[OAConsumer alloc]initWithKey:@"D2WSy72QA5ilrtzEq7U-kg" secret:@"7WzTKp11knWN3dFT4MkjPjuiCk4"];
    
    OAToken *token = [[OAToken alloc]initWithKey:@"2wgDXaivi_U-uFRGL4jNMnsVkyQqoZPU" secret:@"LdGfbZ4Bi6Q3eW7zEWLPhIJWReM"];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc]init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=restaurants&sort=1&ll=%f,%f&radius_filter=1000",_latitude,_longitude];
    
    NSURL *URL = [NSURL URLWithString: urlString];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]initWithURL:URL
                                                                  consumer:consumer
                                                                     token:token
                                                                     realm:nil
                                                         signatureProvider:provider];
    
    [request setHTTPMethod:@"GET"];
    [request prepare];
    
    NSURLSessionTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *businesses = [jsonDictionary objectForKey:@"businesses"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            resultsFromYelp = jsonDictionary;
            restaurantsFromYelp = businesses;
            [self pickRandomRestaurant];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLSessionNotification" object:nil userInfo:nil];
        });
        
    }];
    
    [task resume];
}

-(void)pickRandomRestaurant {
    int numberOfRestaurants = (int)[restaurantsFromYelp count];
    int randomRestaurantNumber = arc4random()%numberOfRestaurants;
    NSLog(@"%@ is what we have to work with", restaurantsFromYelp);
    NSLog(@"The random restaurant number is %i: number of restaurants is %i", randomRestaurantNumber, numberOfRestaurants);
    
    NSDictionary *pickedRestaurant = [restaurantsFromYelp objectAtIndex:randomRestaurantNumber];
    NSURL *imageUrl;
    NSData *imageData;
    
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
    NSString *phoneNumber = [pickedRestaurant objectForKey:@"display_phone"];
    
    NSMutableAttributedString *attributedPhoneNumber = [[NSMutableAttributedString alloc]initWithString:phoneNumber];
    [attributedPhoneNumber addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor blueColor]
                                  range:NSMakeRange(0, [attributedPhoneNumber length])];
    [attributedPhoneNumber addAttribute:NSUnderlineStyleAttributeName
                                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                  range:NSMakeRange(0, [attributedPhoneNumber length])];
    
    NSLog(@"random place %@", [pickedRestaurant objectForKey:@"review_count"]);
    self.restaurantName.text = [pickedRestaurant objectForKey:@"name"];
    self.phoneNumber.attributedText = attributedPhoneNumber;
    NSDictionary *addressDictionary = [pickedRestaurant objectForKey:@"location"];
    NSArray *address = [addressDictionary objectForKey:@"display_address"];
    NSLog(@"%@", address);
   
    NSString *addressString = [[NSString alloc]init];
    
    for (int i = 0; i < [address count]; i++) {
        addressString = [addressString stringByAppendingString:[address objectAtIndex:i]];
        if(i != [address count] - 1) {
            addressString = [addressString stringByAppendingString:@", \n"];
        }
    }
    self.restaurantAddress.text = addressString;
    
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
    
    self.numberOfRatings.text = [NSString stringWithFormat:@"%i reviews", (int)[pickedRestaurant objectForKey:@"review_count"] ];
    
    self.restaurantDescription.text = [pickedRestaurant objectForKey:@"snippet_text"];

}

-(void)activitySpinnerEnd {
    [self.activityIndicator stopAnimating];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"%@ locations", locations);
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
