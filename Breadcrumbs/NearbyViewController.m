//
//  NearbyViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewController.h"
#import "MKMapView_ZoomToFit.h"
#import "Note.h"
#import "NoteViewController.h"

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
        mapView.delegate = self;
    }
    return mapView;
}

- (void)centerOnUser:(UIBarButtonItem *)sender {
    [self.mapView zoomToFitUserAnimated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)sender
            viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) return nil;
    
    static NSString *reuseIdentifier = @"NearbyViewController.AnnotationView";
    
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!aView) {
        aView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:reuseIdentifier] autorelease];
        ((MKPinAnnotationView *)aView).animatesDrop = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.canShowCallout = YES;
    }
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[Note class]]) {
        NoteViewController *noteViewer = [[[NoteViewController alloc] initWithNote:(Note *)view.annotation] autorelease];
        [self.navigationController pushViewController:noteViewer animated:YES];
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.showsUserLocation = YES;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:self.managedObjectContext];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES
                                                              selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request
                                                                       error:&error];
    
    if ([fetchedObjects count]) {
        [self.mapView addAnnotations:fetchedObjects];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // should be set according to number of "nearby" notes
    self.navigationController.tabBarItem.badgeValue = @"1";
    
    // should zoom to fit user
    [self.mapView zoomToFitUserAnimated:YES];
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
