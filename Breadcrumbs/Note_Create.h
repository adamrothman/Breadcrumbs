//
//  Note_Create.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface Note (Note_Create)

+ (Note *)noteWithInfo:(NSDictionary *)info
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
