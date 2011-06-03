//
//  Note_Create.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note_Create.h"
#import "NSManagedObjectContext_Autosave.h"

@implementation Note (Note_Create)

+ (Note *)noteWithInfo:(NSDictionary *)info
inManagedObjectContext:(NSManagedObjectContext *)context {
    Note *note = nil;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                 inManagedObjectContext:context];
    // maybe every note should have a unique? a hash of the contents or something?
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [info objectForKey:@"title"]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request
                                                     error:&error];
    
    if (!fetchedObjects || [fetchedObjects count] > 1) {
        if (error) {
            NSLog(@"failed to create Note: %@, (%@)", [error localizedDescription], [error localizedFailureReason]);
        }
    } else {
        note = [fetchedObjects lastObject];
        if (!note) {
            note = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                 inManagedObjectContext:context];
            
            note.title = [info objectForKey:@"title"];
            note.text = [info objectForKey:@"text"];
            note.location = [info objectForKey:@"location"];
            note.modified = [info objectForKey:@"modified"];
            
            // note.attachments = [info objectForKey:@"attachments"];
            // note.tags = [info objectForKey:@"tags"];
            
            [NSManagedObjectContext autosave:context];
        }
    }
    
    return note;
}

@end
