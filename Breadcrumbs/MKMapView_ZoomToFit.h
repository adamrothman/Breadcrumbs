//
//  MKMapView_ZoomToFit.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MKMapView_ZoomToFit)
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated;
@end
