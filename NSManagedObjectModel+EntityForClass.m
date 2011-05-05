//
//  NSManagedObjectModel+EntityForClass.m
//  CoreDataFinders
//
//  Created by Jamie Pinkham on 5/5/11.
//  Copyright 2011 Jamie Pinkham. All rights reserved.
//

#import "NSManagedObjectModel+EntityForClass.h"
#import <objc/runtime.h>

@implementation NSManagedObjectModel (EntityForClass)

const char *kClassToEntityMappingCache;

- (NSDictionary *)entitiesByClass{
    return objc_getAssociatedObject(self, kClassToEntityMappingCache);
}

- (NSEntityDescription *)entityDescriptionForClass:(Class)aClass{
    if([self entitiesByClass] == nil){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *entities = [self entities];
        for(NSEntityDescription *description in entities){
            [dict setObject:description forKey:[description managedObjectClassName]];
        }
        objc_setAssociatedObject(self, kClassToEntityMappingCache, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return [[self entitiesByClass] objectForKey:NSStringFromClass(aClass)];
}

@end
