//
//  NSManagedObjectContext_Autosave.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext_Autosave.h"

@implementation NSManagedObjectContext (NSManagedObjectContext_Autosave)

+ (void)autosave:(NSManagedObjectContext *)context {
    [self cancelPreviousPerformRequestsWithTarget:self
                                         selector:@selector(save:)
                                           object:context];
    
    [self performSelector:@selector(save:)
               withObject:context
               afterDelay:AUTOSAVE_DELAY];
}

+ (void)save:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"error in [NSManagedObjectContext autosave:%@] %@ (%@)", [context description], [error localizedDescription], [error localizedFailureReason]);
    }
}

@end
