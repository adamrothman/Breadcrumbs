//
//  Attachment_Create.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"
#import "Note.h"

@interface Attachment (Attachment_Create)
+ (Attachment *)attachmentWithInfo:(NSDictionary *)info
                           forNote:(Note *)note;
@end
