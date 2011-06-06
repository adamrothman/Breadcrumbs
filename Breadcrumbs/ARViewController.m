//
//  ARViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"
#import "Note_MKAnnotation.h"
#import "ARGeoCoordinate.h"

@interface ARViewController()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation ARViewController

@synthesize arController, managedObjectContext;

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

- (ARController *)arController {
    if (!arController) {
        arController = [[ARController alloc] initWithViewController:self];
    }
    return arController;
}

#pragma mark - View lifecycle

- (void)loadView {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:self.managedObjectContext];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request
                                                                       error:NULL];
    
    for (Note *note in fetchedObjects) {
        ARGeoCoordinate *coordinate = [[[ARGeoCoordinate alloc] initWithCoordinate:note.location
                                                                          andTitle:note.title] autorelease];
        [self.arController addCoordinate:coordinate animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.arController presentModalARControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Memory management

- (void)dealloc {
    [arController release];
    [managedObjectContext release];
    [super dealloc];
}

@end
