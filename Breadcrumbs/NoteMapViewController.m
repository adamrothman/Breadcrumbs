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

#pragma mark - Properties

- (MKMapView *)mapView {
    if (!mapView) {
        mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        mapView.delegate = self;
    }
    return mapView;
}

#pragma mark - MKMapViewDelegate

// Current note's pin is a different color and is draggable
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
    
    if ([annotation isKindOfClass:[Note class]]) {
        Note *annotationNote = (Note *)annotation;
        
        if ([annotationNote.unique isEqualToString:self.note.unique]) {
            ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorPurple;
            aView.draggable = YES;
        } else {
            ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorRed;
            aView.draggable = NO;
        }
    }
    
    return aView;
}

#pragma mark - Button actions

- (void)done:(UIButton *)sender {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.mapView;
    
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
    
    NSArray *fetchedObjects = [[self.note managedObjectContext] executeFetchRequest:request
                                                                              error:NULL];
    
    if ([fetchedObjects count]) {
        [self.mapView addAnnotations:fetchedObjects];
    }
    
    [self.mapView zoomToFitAnnotation:self.note animated:YES];
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
