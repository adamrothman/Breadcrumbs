//
//  MKMapView_ZoomToFit.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MKMapView_ZoomToFit)
- (void)zoomToFitAnnotation:(id <MKAnnotation>)annotation
                   animated:(BOOL)animated;
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated;
- (void)zoomToFitUserAnimated:(BOOL)animated;
@end
