//
//  LocationMonitor.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationMonitor.h"
#import "Note.h"

// future versions will let the user set this radius
#define NEARBY_RADIUS   7500

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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
    }
    return locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Note"
                                 inManagedObjectContext:self.managedObjectContext];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request
                                                                       error:NULL];
    
    // have to fetch all notes then filter because SQLite doesn't support block predicates
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Note *note = (Note *)evaluatedObject;
        
        if ([self.locationManager.location distanceFromLocation:note.location] < NEARBY_RADIUS) {
            return YES;
        } else {
            return NO;
        }
    }];
    NSArray *nearbyNotes = [fetchedObjects filteredArrayUsingPredicate:predicate];
    
    if (nearbyNotes) self.nearbyNoteCount = [nearbyNotes count];
    
    // only need to fire a notification if the note is in the background and there are notes nearby
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground &&
        self.nearbyNoteCount) {
        UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
        notification.alertBody = [NSString stringWithFormat:@"You have %lu nearby notes", (unsigned long)self.nearbyNoteCount];
        notification.applicationIconBadgeNumber = self.nearbyNoteCount;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertAction = @"View";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"LocationMonitor: location update failed");
}

@end
