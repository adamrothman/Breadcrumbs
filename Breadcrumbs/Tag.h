//
//  Tag.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Tag : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet* notes;

@end
