//
//  Note_Lifecycle.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note_Lifecycle.h"
#import "Attachment_Lifecycle.h"
#import "NSManagedObjectContext_Autosave.h"

@implementation Note (Note_Lifecycle)

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
            note.unique = [NSString stringWithFormat:@"%lu", [note hash]];
            note.location = [info objectForKey:@"location"];
            note.modified = [info objectForKey:@"modified"];
            
            [NSManagedObjectContext autosave:context];
        }
    }
    
    return note;
}

// Delete the directory that contains this note's attachments, then remove from the data model.
+ (void)removeNote:(Note *)note {
    dispatch_queue_t fileSystemQueue = dispatch_queue_create("Note attachments deleter", NULL);
    dispatch_async(fileSystemQueue, ^{
        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        
        NSString *documentsDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *noteDirPath = [documentsDirPath stringByAppendingPathComponent:note.unique];
        
        [fileManager removeItemAtPath:noteDirPath
                                error:NULL];
        
        for (Attachment *attachment in note.attachments) {
            [Attachment removeAttachment:attachment];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[note managedObjectContext] deleteObject:note];
            [NSManagedObjectContext autosave:[note managedObjectContext]];
        });
    });
    dispatch_release(fileSystemQueue);
}

@end
