//
//  Attachment_Lifecycle.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Attachment.h"
#import "Note.h"

@interface Attachment (Attachment_Lifecycle)
+ (Attachment *)attachmentWithInfo:(NSDictionary *)info
                           forNote:(Note *)note;
+ (void)removeAttachment:(Attachment *)attachment;
@end
