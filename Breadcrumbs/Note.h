//
//  Note.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Tag;

@interface Note : NSManagedObject {
@private
}
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) NSSet* attachments;

@end
