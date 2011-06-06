//
//  NewTagViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NewTagViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, assign) UIViewController *delegate;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context;
@end
