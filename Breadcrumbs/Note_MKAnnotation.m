//
//  Note_MKAnnotation.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note_MKAnnotation.h"
#import "NSManagedObjectContext_Autosave.h"

@implementation Note (Note_MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
    return ((CLLocation *)self.location).coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    CLLocation *newLocation = [[[CLLocation alloc] initWithLatitude:newCoordinate.latitude
                                                          longitude:newCoordinate.longitude] autorelease];
    self.location = newLocation;
    
    [NSManagedObjectContext autosave:[self managedObjectContext]];
}

- (NSString *)subtitle {
    return self.text;
}

@end
