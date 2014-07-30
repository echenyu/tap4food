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
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantPicture;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIImage *restaurantImage;

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
    // Do any additional setup after loading the view.
    [self setupRestaurants];
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

-(void)setupRestaurants {
    //Use Oauth to authorize the user/the app to use Yelp's API
    OAConsumer *consumer = [[OAConsumer alloc]initWithKey:@"D2WSy72QA5ilrtzEq7U-kg" secret:@"7WzTKp11knWN3dFT4MkjPjuiCk4"];
    
    OAToken *token = [[OAToken alloc]initWithKey:@"2wgDXaivi_U-uFRGL4jNMnsVkyQqoZPU" secret:@"LdGfbZ4Bi6Q3eW7zEWLPhIJWReM"];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc]init];
    
    NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=new%20york"];
    
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
    NSLog(@"The random restaurant number is %i", randomRestaurantNumber);
    
    NSDictionary *pickedRestaurant = [restaurantsFromYelp objectAtIndex:randomRestaurantNumber];
    NSURL *imageUrl = [[NSURL alloc]initWithString:[pickedRestaurant objectForKey:@"image_url"]];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageUrl];
    NSLog(@"random place %@", [pickedRestaurant objectForKey:@"name"]);
    self.restaurantName.text = [pickedRestaurant objectForKey:@"name"];
    self.phoneNumber.text = [pickedRestaurant objectForKey:@"display_phone"];
    self.restaurantPicture.image = [UIImage imageWithData:imageData];

}

-(void)activitySpinnerEnd {
    [self.activityIndicator stopAnimating];
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
