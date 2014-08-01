//
//  settingsViewController.m
//  Tap4Food
//
//  Created by Eric Yu on 8/1/14.
//  Copyright (c) 2014 EricYu. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSegmentControl;
@property (nonatomic, strong)NSNumber *selectedIndex;
@end

@implementation settingsViewController

-(NSNumber *)selectedIndex{
    if (!_selectedIndex) {
        _selectedIndex = [NSNumber numberWithInt:0];
    }
    return _selectedIndex;
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    switch((int)[settings integerForKey:@"mySelectedValueKey"]) {
        case 0:
            self.distanceSegmentControl.selectedSegmentIndex = 0;
            break;
        case 1:
            self.distanceSegmentControl.selectedSegmentIndex = 1;
            break;
        case 2:
            self.distanceSegmentControl.selectedSegmentIndex = 2;
            break;
        case 3:
            self.distanceSegmentControl.selectedSegmentIndex = 3;
            break;
        case 4:
            self.distanceSegmentControl.selectedSegmentIndex = 4;
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tap4Food Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Zapfino" size:12], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)segmentControlDistance: (UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            return 805;
            break;
        case 1:
            return 1610;
            break;
        case 2:
            return 4828;
            break;
        case 3:
            return 8047;
            break;
        case 4:
            return 16093;
            break;
        default:
            return 5000;
            break;
    }
}

- (IBAction)distanceChange:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    self.selectedIndex = [NSNumber numberWithInt:(int)[segmentedControl selectedSegmentIndex]];
    int metersDistance = [self segmentControlDistance:segmentedControl];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setInteger:segmentedControl.selectedSegmentIndex forKey:@"mySelectedValueKey"];
    [settings setInteger:metersDistance forKey:@"numberOfMeters"];
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
