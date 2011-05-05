//
//  NSManagedObjectModel+EntityForClass.h
//  CoreDataFinders
//
//  Created by Jamie Pinkham on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectModel (EntityForClass)

- (NSDictionary *)entitiesByClass;
- (NSEntityDescription *)entityDescriptionForClass:(Class)aClass;

@end
