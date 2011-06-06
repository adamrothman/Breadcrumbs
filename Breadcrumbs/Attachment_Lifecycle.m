//
//  Attachment_Lifecycle.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Attachment_Lifecycle.h"
#import "NSManagedObjectContext_Autosave.h"

@implementation Attachment (Attachment_Lifecycle)

+ (Attachment *)attachmentWithInfo:(NSDictionary *)info
                           forNote:(Note *)note {
    NSManagedObjectContext *context = [note managedObjectContext];
    Attachment *attachment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                           inManagedObjectContext:context];;
    
    attachment.owner = note;
    attachment.unique = [NSString stringWithFormat:@"%lu", [attachment hash]];
    
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    
    // attachment gets saved at [documents]/[note.unique]/[attachment.unique].ext
    NSString *documentsDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *noteDirPath = [documentsDirPath stringByAppendingPathComponent:note.unique];
    if (![fileManager fileExistsAtPath:noteDirPath]) { // note's attachment directory does not exist, so create it
        [fileManager createDirectoryAtPath:noteDirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    NSString *attachmentPath = [noteDirPath stringByAppendingPathComponent:attachment.unique];
    
    dispatch_queue_t fileSystemQueue = dispatch_queue_create("Attachment creator", NULL);
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {          // image
        attachment.type = type;
        
        NSData *imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 1.0);
        attachment.bytes = [NSNumber numberWithUnsignedInteger:[imageData length]];
        attachment.path = [attachmentPath stringByAppendingPathExtension:@"jpeg"];
        
        dispatch_async(fileSystemQueue, ^{
            [fileManager createFileAtPath:attachment.path
                                 contents:imageData
                               attributes:nil];
        });
    } else if ([type isEqualToString:(NSString *)kUTTypeMovie]) {   // movie
        attachment.type = type;
        
        NSString *tempPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        attachment.bytes = [NSNumber numberWithUnsignedLongLong:
                            [[fileManager attributesOfItemAtPath:tempPath
                                                           error:NULL] fileSize]];
        attachment.path = [attachmentPath stringByAppendingPathExtension:
                           [[tempPath pathExtension] lowercaseString]];
        
        dispatch_async(fileSystemQueue, ^{
            [fileManager copyItemAtPath:tempPath
                                 toPath:attachment.path
                                  error:NULL];
        });
    } else {                                                        // audio
        attachment.type = (NSString *)kUTTypeAudio;
        
        // do some other stuff
    }
    
    dispatch_release(fileSystemQueue);
    
    attachment.added = [NSDate date];
    [NSManagedObjectContext autosave:context];
    
    return attachment;
}

// Delete the attachment's data from the file system, then remove from the data model.
+ (void)removeAttachment:(Attachment *)attachment {
    dispatch_queue_t fileSystemQueue = dispatch_queue_create("Attachment deleter", NULL);
    dispatch_async(fileSystemQueue, ^{
        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        
        if ([fileManager fileExistsAtPath:attachment.path]) {
            [fileManager removeItemAtPath:attachment.path
                                    error:NULL];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[attachment managedObjectContext] deleteObject:attachment];
            [NSManagedObjectContext autosave:[attachment managedObjectContext]];
        });
    });
    dispatch_release(fileSystemQueue);
}

@end
