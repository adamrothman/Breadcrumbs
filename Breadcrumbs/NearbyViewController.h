//
//  NearbyViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NearbyViewController : UIViewController

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context;

@end
