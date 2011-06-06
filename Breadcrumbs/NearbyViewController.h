//
//  NearbyViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NearbyViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, retain) MKMapView *mapView;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context;
@end
