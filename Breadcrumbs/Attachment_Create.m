//
//  Attachment_Create.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Attachment_Create.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSManagedObjectContext_Autosave.h"

@implementation Attachment (Attachment_Create)

+ (Attachment *)attachmentWithInfo:(NSDictionary *)info
                           forNote:(Note *)note {
    Attachment *attachment = nil;
    
    NSManagedObjectContext *context = [note managedObjectContext];
    
    attachment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                               inManagedObjectContext:context];
    
    attachment.owner = note;
    attachment.type = [info objectForKey:UIImagePickerControllerMediaType];
    
    // copy to filesystem
    
    attachment.bytes = 0;
    attachment.path = @"";
    attachment.added = [NSDate date];
    
    [NSManagedObjectContext autosave:context];
    
    return attachment;
}

@end
