//
//  Note_MKAnnotation.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note_MKAnnotation.h"

@implementation Note (Note_MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
    return ((CLLocation *)self.location).coordinate;
}

- (NSString *)subtitle {
    return [self.text substringToIndex:64];
}

@end
