//
//  Event.m
//  CoreDataFinders
//
//  Created by Jamie Pinkham on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "NSManagedObjectModel+EntityForClass.h"
#import <objc/runtime.h>

@implementation Event

@dynamic timeStamp;

+ (BOOL)resolveClassMethod:(SEL)sel{
    NSString *selectorName = NSStringFromSelector(sel);
    if([selectorName isEqualToString:@"findAllInContext:"]){
        NSArray *(^findAllBlock)(id, NSManagedObjectContext *context) = ^(id _self, NSManagedObjectContext *context){
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSPersistentStoreCoordinator *psc = [context persistentStoreCoordinator];
            NSManagedObjectModel *mom = [psc managedObjectModel];
            [request setEntity:[mom entityDescriptionForClass:_self]];
            NSError *error = nil;
            return [context executeFetchRequest:request error:&error];
        };
        IMP findAllImp = (void *)imp_implementationWithBlock(findAllBlock);
        NSString *types = [NSString stringWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)];
        class_addMethod([self class]->isa, sel, findAllImp, [types UTF8String]);
        return YES;
    }
    return [super resolveClassMethod:sel];
}

@end
