//
//  Note.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Tag;

@interface Note : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Note (CoreDataGeneratedAccessors)
- (void)addAttachmentsObject:(Attachment *)value;
- (void)removeAttachmentsObject:(Attachment *)value;
- (void)addAttachments:(NSSet *)value;
- (void)removeAttachments:(NSSet *)value;
- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)value;
- (void)removeTags:(NSSet *)value;

@end
