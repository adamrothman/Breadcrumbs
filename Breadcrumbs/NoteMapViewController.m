//
//  NoteMapViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteMapViewController.h"
#import "Note_MKAnnotation.h"
#import "MKMapView_ZoomToFit.h"

@interface NoteMapViewController()
@property (nonatomic, retain) Note *note;
@end

@implementation NoteMapViewController

@synthesize delegate;
@synthesize mapView;
@synthesize note;

- (id)initWithNote:(Note *)aNote {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.note = aNote;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)sender
            viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) return nil;
    
    static NSString *reuseIdentifier = @"NoteMapViewController.AnnotationView";
    
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!aView) {
        aView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:reuseIdentifier] autorelease];
        ((MKPinAnnotationView *)aView).animatesDrop = YES;
        aView.canShowCallout = YES;
    }
    aView.annotation = annotation;
    
    // another place having a unique might be nice
    if (annotation.coordinate.latitude == self.note.coordinate.latitude &&
        annotation.coordinate.longitude == self.note.coordinate.longitude &&
        [annotation.title isEqualToString:self.note.title]) {
        ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorPurple;
        aView.draggable = YES;
    } else {
        ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorRed;
        aView.draggable = NO;
    }
    
    return aView;
}

#pragma mark - Button actions

- (void)done:(UIButton *)sender {
    [self.delegate modalDismiss:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.navigationItem.title = @"Drag to move";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(done:)] autorelease];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.showsUserLocation = YES;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:[self.note managedObjectContext]];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES
                                                              selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self.note managedObjectContext] executeFetchRequest:request
                                                                              error:&error];
    
    if ([fetchedObjects count]) {
        [self.mapView addAnnotations:fetchedObjects];
    }
    
    [self.mapView zoomToFitAnnotation:self.note animated:YES];
}

- (void)viewDidUnload {
    self.mapView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [mapView release];
    [note release];
    [super dealloc];
}

@end
