//
//  Attachment_Types.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"

typedef enum {
    AttachmentTypePhoto,
    AttachmentTypeMovie,
    AttachmentTypeAudio
} AttachmentType;

@interface Attachment (Attachment_Types)

@end
