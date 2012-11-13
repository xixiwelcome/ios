//
//  OHWProviderFriendViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 11/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWProviderFriendViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWProviderFriendViewController ()

@end

@implementation OHWProviderFriendViewController
@synthesize userImage = _userImage;
@synthesize mapView = _mapView;
@synthesize userNameLabel = _userNameLabel;
@synthesize location = _location;
@synthesize webViewButton = _webViewButton;

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  ProviderFriend *providerFriend = [appDelegate userProviderFriend].providerFriend;
  _userNameLabel.text = providerFriend.fullName;
  NSString *url = [providerFriend.pictureUrl stringByAppendingString:@"?type=large"];
  [_userImage setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
  
  _location = providerFriend.location;
  
  if (_location != nil) {
    float latitude = [_location.latitude floatValue];
    float longitude = [_location.longitude floatValue];
    CLLocationCoordinate2D location = {latitude, longitude};
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = .025;
    span.longitudeDelta = .025;
    region.center = location;
    region.span = span;
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    [_mapView setCenterCoordinate:_mapView.region.center animated:NO];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    [point setCoordinate:(region.center)];
    [point setTitle:_location.address];
    [_mapView addAnnotation:point];
  }
}

- (MKAnnotationView *) mapView:(MKMapView *)currentMapView viewForAnnotation:(id <MKAnnotation>) annotation {
  if (annotation == currentMapView.userLocation) {
    return nil; //default to blue dot
  }
  MKPinAnnotationView *dropPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
  dropPin.pinColor = MKPinAnnotationColorGreen;
  dropPin.animatesDrop = YES;
  dropPin.canShowCallout = YES;
  return dropPin;
}

- (IBAction)openWebView:(id)sender {
  OHWProviderFriendWebViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderFriendWebView"];
  [self.navigationController pushViewController:controller animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, 160, 280, 280)];
  _mapView.delegate = self;
  _mapView.showsUserLocation = YES;
  [self.view addSubview:_mapView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end