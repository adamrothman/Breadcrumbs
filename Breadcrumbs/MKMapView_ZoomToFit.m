//
//  MKMapView_ZoomToFit.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MKMapView_ZoomToFit.h"

#define PADDING_MULTIPLIER  1.05

@implementation MKMapView (MKMapView_ZoomToFit)

/**
 * Zoom and center the map view so that it displays all of its annotations
 * with a bit of padding around them.
 */
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated {
    if ([self.annotations count]) {
        CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(-90, 180);
        CLLocationCoordinate2D bottomRight = CLLocationCoordinate2DMake(90, -180);
        
        for (id <MKAnnotation> annotation in self.annotations) {
            topLeft.latitude = fmax(topLeft.latitude, annotation.coordinate.latitude);
            topLeft.longitude = fmin(topLeft.longitude, annotation.coordinate.longitude);
            
            bottomRight.latitude = fmin(bottomRight.latitude, annotation.coordinate.latitude);
            bottomRight.longitude = fmax(bottomRight.longitude, annotation.coordinate.longitude);
        }
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                                                                   topLeft.longitude + (bottomRight.longitude - topLeft.longitude) / 2);
        MKCoordinateSpan span = MKCoordinateSpanMake(fabs(topLeft.latitude - bottomRight.latitude) * PADDING_MULTIPLIER,
                                                     fabs(bottomRight.longitude - topLeft.longitude) * PADDING_MULTIPLIER);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        [self setRegion:[self regionThatFits:region] animated:animated];
    }
}

@end
