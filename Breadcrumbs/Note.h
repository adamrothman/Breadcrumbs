//
//  Note.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Tag;

@interface Note : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) NSSet* attachments;

@end
