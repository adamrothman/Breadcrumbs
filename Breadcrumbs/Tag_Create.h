//
//  Tag_Create.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"

@interface Tag (Tag_Create)
+ (Tag *)tagWithTitle:(NSString *)title
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
