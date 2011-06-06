//
//  Note_Lifecycle.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@interface Note (Note_Lifecycle)
+ (Note *)noteWithInfo:(NSDictionary *)info
inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeNote:(Note *)note;
@end
