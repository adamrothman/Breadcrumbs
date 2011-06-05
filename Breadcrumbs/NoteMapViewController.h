//
//  NoteMapViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Note.h"
#import "NoteEditorController.h"

@interface NoteMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, assign) UIViewController *delegate;
@property (nonatomic, retain) MKMapView *mapView;

- (id)initWithNote:(Note *)aNote;
@end
