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

@interface RestaurantsViewController ()
@property (nonatomic, strong)NSDictionary *yelpResults;
@property (nonatomic, strong)NSMutableData *actualYelpResults;

@end

@implementation RestaurantsViewController

-(NSDictionary *)yelpResults {
    if (!_yelpResults) {
        _yelpResults = [[NSDictionary alloc]init];
    }
    return _yelpResults;
}

-(NSMutableData *)actualYelpResults {
    if(!_actualYelpResults) {
        _actualYelpResults = [[NSMutableData alloc]init];
    }
    return _actualYelpResults;
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
    
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
    NSURLSessionTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSLog(@"%@",data);
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSDictionary *itemsArray = [jsonArray objectAtIndex: 0];
        NSString *string = [itemsArray objectForKey:@"businesses"];
        NSLog(@"%@ is string", string);
    }];
    
    [task resume];
    NSLog(@"%@ haha", self.yelpResults);
    //[connection description];
    
    
}
- (IBAction)button:(id)sender {
    NSLog(@"%@ stuff", self.yelpResults);
    NSLog(@"%@ other stuff", self.actualYelpResults);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.yelpResults = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSDictionary *restaurantData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    self.yelpResults = restaurantData;
    [_actualYelpResults appendData:data];
    NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:NULL];
    NSLog(@"Flickr %@", propertyList);
    //NSLog(@"%@ is JSON", JSON);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%@ of stuff", self.yelpResults); 
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
