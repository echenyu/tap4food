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
@property (nonatomic, strong)NSData *yelpResults;

@end

@implementation RestaurantsViewController

-(NSData *)yelpResults {
    if (!_yelpResults) {
        _yelpResults = [[NSData alloc]init];
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
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=food&amp;location=San+Francisco"]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    self.yelpResults = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *properties = [NSJSONSerialization JSONObjectWithData:self.yelpResults options:0 error:NULL];
    NSLog(@"%@ is the stuff", );
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
