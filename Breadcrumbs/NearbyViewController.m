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
#import "LocationMonitor.h"

@interface NearbyViewController()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL hasAppeared;
@end

@implementation NearbyViewController

@synthesize mapView;

@synthesize managedObjectContext, hasAppeared;

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

#pragma mark - KVO

// Update the badge on this view controller's tab bar item when the number of nearby notes changes.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == [LocationMonitor sharedMonitor] &&
        [keyPath isEqualToString:@"nearbyNoteCount"]) {
        NSUInteger newCount = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
        
        if (newCount) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", newCount];
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
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

- (void)viewDidLoad {
    [[LocationMonitor sharedMonitor] addObserver:self
                                      forKeyPath:@"nearbyNoteCount"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.showsUserLocation = YES;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:self.managedObjectContext];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request
                                                                       error:NULL];
    
    if ([fetchedObjects count]) {
        [self.mapView addAnnotations:fetchedObjects];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.hasAppeared) {    // only zoom in on the user the first time this view appears
        self.hasAppeared = YES;
        [self.mapView performSelector:@selector(zoomToFitUserAnimated:)
                           withObject:[NSNumber numberWithBool:YES]
                           afterDelay:1];
    }
}

- (void)viewDidUnload {
    [[LocationMonitor sharedMonitor] removeObserver:self
                                         forKeyPath:@"nearbyNoteCount"];
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
