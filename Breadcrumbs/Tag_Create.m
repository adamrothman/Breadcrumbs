//
//  Tag_Create.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag_Create.h"
#import "NSManagedObjectContext_Autosave.h"

@implementation Tag (Tag_Create)

+ (Tag *)tagWithTitle:(NSString *)title
inManagedObjectContext:(NSManagedObjectContext *)context {
    Tag *tag = nil;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                 inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [title lowercaseString]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request
                                                     error:&error];
    
    if (!fetchedObjects || fetchedObjects.count > 1) {
        NSLog(@"request failed or returned more than one object");
    } else {
        tag = [fetchedObjects lastObject];
        if (!tag) {
            tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                inManagedObjectContext:context];
            
            tag.title = [title lowercaseString];
            
            [NSManagedObjectContext autosave:context];
        }
    }
    
    return tag;
}

@end
