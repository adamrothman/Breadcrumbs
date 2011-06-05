//
//  Attachment.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Attachment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * bytes;
@property (nonatomic, retain) NSDate * added;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Note * owner;

@end
