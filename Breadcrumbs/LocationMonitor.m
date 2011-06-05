//
//  LocationMonitor.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationMonitor.h"

static LocationMonitor *sharedLocationMonitor;

@implementation LocationMonitor

@synthesize locationManager, managedObjectContext, nearbyNoteCount;

#pragma mark - Singleton class implementation

+ (LocationMonitor *)sharedMonitor {
    if (!sharedLocationMonitor) {
        sharedLocationMonitor = [[super allocWithZone:NULL] init];
    }
    return sharedLocationMonitor;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedMonitor] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax; // cannot be released
}

- (void)release {
    // do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark - Properties

- (CLLocationManager *)locationManager {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    return locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    // calculate number of nearby notes
    NSUInteger nearbyCount = 0;
    
    // have to figure out when to display an alert (background) and when not to
    
    
    if (nearbyCount) {
        // display an alert
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    // do nothing
}

@end
