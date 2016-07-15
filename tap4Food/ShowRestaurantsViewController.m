//
//  ShowRestaurantsViewController.m
//  tap4Food
//
//  Created by Eric Yu on 7/15/16.
//  Copyright © 2016 ericYu. All rights reserved.
//

#import "ShowRestaurantsViewController.h"

@interface ShowRestaurantsViewController () {
    UIActivityIndicatorView *activityIndicator;
}
@end



@implementation ShowRestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIActivityIndicatorView *)activityIndicator {
    if(!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    }
    return activityIndicator;
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
