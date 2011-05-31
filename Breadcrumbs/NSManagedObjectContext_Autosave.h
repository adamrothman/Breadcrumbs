//
//  NSManagedObjectContext_Autosave.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define AUTOSAVE_DELAY  2

@interface NSManagedObjectContext (NSManagedObjectContext_Autosave)
+ (void)autosave:(NSManagedObjectContext *)context;
@end
