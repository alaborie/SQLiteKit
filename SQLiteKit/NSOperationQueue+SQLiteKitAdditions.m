//
//  SQLGlobal.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSOperationQueue+SQLiteKitAdditions.h"

@implementation NSOperationQueue (SQLiteKitAdditions)

+ (id)databaseQueue
{
    static NSOperationQueue *SQLiteQueue = nil;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{

        SQLiteQueue = [[NSOperationQueue alloc] init];
        SQLiteQueue.name = @"databaseQueue";
        SQLiteQueue.maxConcurrentOperationCount = 1;
    });
    return SQLiteQueue;
}

@end
