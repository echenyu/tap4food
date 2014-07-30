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

@interface Tap4FoodViewController ()

@end

@implementation Tap4FoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performSegue) name:@"NSURLSessionNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)generateRandomRestaurants:(id)sender {
    [self setupRestaurants];
}

-(void)setup {
    //Set the color of the navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
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
        NSLog(@"%@ is business", businesses);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLSessionNotification" object:nil userInfo:nil];
        });
        
    }];
    
    [task resume];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) performSegue {
    [self performSegueWithIdentifier:@"pushSegue" sender:self];
}
@end
