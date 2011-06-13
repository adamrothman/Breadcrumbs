//
//  Tag.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"
#import "Note.h"


@implementation Tag
@dynamic title;
@dynamic notes;

- (void)addNotesObject:(Note *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notes"] addObject:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeNotesObject:(Note *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"notes"] removeObject:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}

- (void)addNotes:(NSSet *)value {    
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notes"] unionSet:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeNotes:(NSSet *)value {
    [self willChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"notes"] minusSet:value];
    [self didChangeValueForKey:@"notes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
