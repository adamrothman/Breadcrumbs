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
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                               inManagedObjectContext:context];
    
    note.unique = [NSString stringWithFormat:@"%lu", [note hash]];
    
    note.location = [info objectForKey:@"location"];
    note.modified = [info objectForKey:@"modified"];
    
    // these two keys don't exist when creating new notes
    // just here to allow batch note creation for testing
    note.title = [info objectForKey:@"title"];
    note.text = [info objectForKey:@"text"];
    
    [NSManagedObjectContext autosave:context];
    
    return note;
}

// delete note's attachments, then remove it from data model
+ (void)removeNote:(Note *)note {
    dispatch_queue_t fileSystemQueue = dispatch_queue_create("Note attachments deleter", NULL);
    dispatch_async(fileSystemQueue, ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
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
