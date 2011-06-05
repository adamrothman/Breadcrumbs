//
//  Note.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"
#import "Attachment.h"
#import "Tag.h"


@implementation Note
@dynamic location;
@dynamic title;
@dynamic text;
@dynamic modified;
@dynamic unique;
@dynamic tags;
@dynamic attachments;

- (void)addTagsObject:(Tag *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] addObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTagsObject:(Tag *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tags"] removeObject:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTags:(NSSet *)value {    
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] unionSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTags:(NSSet *)value {
    [self willChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tags"] minusSet:value];
    [self didChangeValueForKey:@"tags" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAttachmentsObject:(Attachment *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"attachments"] addObject:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAttachmentsObject:(Attachment *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"attachments"] removeObject:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAttachments:(NSSet *)value {    
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"attachments"] unionSet:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAttachments:(NSSet *)value {
    [self willChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"attachments"] minusSet:value];
    [self didChangeValueForKey:@"attachments" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
