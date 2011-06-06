//
//  NSManagedObjectContext_Autosave.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define AUTOSAVE_DELAY  2

@interface NSManagedObjectContext (NSManagedObjectContext_Autosave)
+ (void)autosave:(NSManagedObjectContext *)context;
@end
