//
//  OHWCheckinViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWCheckinViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWCheckinViewController ()

@end

@implementation OHWCheckinViewController
@synthesize locationManager = _locationManager;
@synthesize placeCacheDescriptor = _placeCacheDescriptor;
@synthesize hudView = _hudView;

- (void)startLocationManager {
  [self.locationManager startUpdatingLocation];
}

- (void)dealloc {
  _locationManager.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Check In";
  
  // Get the CLLocationManager going.
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  self.locationManager.distanceFilter = 50;
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
  [_hudView startActivityIndicator:self.view];
  [self startLocationManager];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  if (!oldLocation ||
      (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
       oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
       newLocation.horizontalAccuracy <= 100.0)) {
        [self.placeCacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        [settings setDouble:newLocation.coordinate.latitude forKey:@"lastLatitude"];
        [settings setDouble:newLocation.coordinate.longitude forKey:@"lastLongitude"];
        [settings synchronize];
        //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([settings doubleForKey:@"lastLatitude"], [settings doubleForKey:@"lastLongitude"]);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
          if (error != nil){
            return;
          }
          [_hudView stopActivityIndicator];
          if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            NSLog(@"%@", [placeMark.addressDictionary valueForKey:@"FormattedAddressLines"]);
            
          }
        }];
      }
}

- (IBAction)checkin:(id)sender {
  [_locationManager stopUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
  [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
