//
//  JPManagedObject.m
//  CoreDataFinders
//
//  Created by Jamie Pinkham on 5/5/11.
//  Copyright 2011 Jamie Pinkham. All rights reserved.
//

#import "JPManagedObject.h"
#import "NSManagedObjectModel+EntityForClass.h"
#import <objc/runtime.h>

@implementation JPManagedObject

+ (BOOL)resolveClassMethod:(SEL)sel{
    NSString *selectorName = NSStringFromSelector(sel);
    if([selectorName isEqualToString:@"findAllInContext:"]){
        NSArray *(^findAllBlock)(id, NSManagedObjectContext *context) = ^(id _self, NSManagedObjectContext *context){
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            NSPersistentStoreCoordinator *psc = [context persistentStoreCoordinator];
            NSManagedObjectModel *mom = [psc managedObjectModel];
            [request setEntity:[mom entityDescriptionForClass:_self]];
            NSError *error = nil;
            return [context executeFetchRequest:request error:&error];
        };
        IMP findAllImp = (void *)imp_implementationWithBlock(findAllBlock);
        NSString *types = [NSString stringWithFormat:@"%s%s%s%S", @encode(id), @encode(id), @encode(SEL), @encode(id)];
        class_addMethod([self class]->isa, sel, findAllImp, [types UTF8String]);
        return YES;
    }else if([selectorName hasPrefix:@"findBy"]){
        NSArray *(^findByBlock)(id, id, NSManagedObjectContext *context) = ^(id _self, id attribute, NSManagedObjectContext *context){
            NSPersistentStoreCoordinator *psc = [context persistentStoreCoordinator];
            NSManagedObjectModel *mom = [psc managedObjectModel];
            NSInteger inContextLocation = [selectorName rangeOfString:@":inContext:"].location;
            NSString *selectorWithoutContext = [selectorName substringWithRange:NSMakeRange(0,inContextLocation)];
            NSString *propertyName = [selectorWithoutContext stringByReplacingCharactersInRange:NSMakeRange(0, [@"findBy" length]) withString:@""];
            NSString *firstCharacter = [propertyName substringWithRange:NSMakeRange(0, 1)];
            NSString *loweredPropertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstCharacter lowercaseString]];
            NSEntityDescription *description = [mom entityDescriptionForClass:_self];
            NSDictionary *propertyNames = [description propertiesByName];
            if([propertyNames objectForKey:loweredPropertyName]){
                NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ == %@", loweredPropertyName, attribute];
                [request setPredicate:predicate];
                [request setEntity:description];
                NSError *error = nil;
                return [context executeFetchRequest:request error:&error];
            }else{
                NSArray *emptyArray = [NSArray array];
                return emptyArray;
            }
        };
        IMP findByImp = (void *)imp_implementationWithBlock(findByBlock);
        NSString *types = [NSString stringWithFormat:@"%s%s%s%s%s", @encode(id), @encode(id), @encode(SEL), @encode(id), @encode(id)];
        class_addMethod([self class]->isa, sel, findByImp, [types UTF8String]);
    }
    return [super resolveClassMethod:sel];
}


@end
