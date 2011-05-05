//
//  Event.h
//  CoreDataFinders
//
//  Created by Jamie Pinkham on 5/5/11.
//  Copyright 2011 Jamie Pinkham. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSManagedObject {
    
}

@property (nonatomic, retain) NSDate *timeStamp;
@property (nonatomic, retain) NSString *name;


@end
