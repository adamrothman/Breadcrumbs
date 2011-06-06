//
//  LocationMonitor.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMonitor : NSObject <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSUInteger nearbyNoteCount;

+ (LocationMonitor *)sharedMonitor;
@end
