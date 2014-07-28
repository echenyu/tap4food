//
//  RestaurantsViewController.m
//  Tap4Food
//
//  Created by Eric Yu on 7/28/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "OAuthConsumer.h"

@interface RestaurantsViewController ()
@property (nonatomic, strong)NSMutableData *yelpResults;

@end

@implementation RestaurantsViewController

-(NSData *)yelpResults {
    if (!_yelpResults) {
        _yelpResults = [[NSMutableData alloc]init];
    }
    return _yelpResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRestaurants];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRestaurants {
    //Use Oauth to authorize the user/the app to use Yelp's API
    
    OAConsumer *consumer = [[OAConsumer alloc]initWithKey:@"D2WSy72QA5ilrtzEq7U-kg" secret:@"7WzTKp11knWN3dFT4MkjPjuiCk4"];
    OAToken *token = [[OAToken alloc]initWithKey:@"x-qRDH6wasCJ5lfpp0QMw1n_ZEQpAyUw" secret:@"6nlB_E-kg0dDNr5t1wn3iSu5WIw"];
    
    NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=new%20york"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc]initWithURL:URL
                                                                  consumer:consumer
                                                                     token:token
                                                                     realm:nil
                                                         signatureProvider:nil];
    
    [request setHTTPMethod:@"GET"];
    
    self.yelpResults = [NSMutableData dataWithContentsOfURL:URL];
    NSLog(@"%@ haha", self.yelpResults);
    
    
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
