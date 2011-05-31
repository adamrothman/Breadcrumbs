//
//  NearbyViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewController.h"

#define LATITUDE_PADDING    0.1
#define LONGITUDE_PADDING   0.1

@interface NearbyViewController()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation NearbyViewController

@synthesize mapView, managedObjectContext;

#pragma mark - Designated initializer

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithNibName:nil bundle:nil];
        if (self) {
            self.managedObjectContext = context;
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
}

#pragma mark - Properties

- (MKMapView *)mapView {
    if (!mapView) {
        mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        mapView.showsUserLocation = YES;
    }
    return mapView;
}

- (void)centerOnUser:(UIBarButtonItem *)sender {
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate,
                                                       MKCoordinateSpanMake(LATITUDE_PADDING, LONGITUDE_PADDING));
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.mapView;
    
    self.navigationItem.title = @"Nearby";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mini-location-arrow-white"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(centerOnUser:)] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this should get set programmatically
    self.navigationController.tabBarItem.badgeValue = @"1";
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//    request.entity = [NSEntityDescription entityForName:@"Note"
//                                 inManagedObjectContext:self.managedObjectContext];
//    
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    NSError *error = nil;
//    [self.mapView addAnnotations:[self.managedObjectContext executeFetchRequest:request error:&error]];
//}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [mapView release];
    [managedObjectContext release];
    [super dealloc];
}

@end
