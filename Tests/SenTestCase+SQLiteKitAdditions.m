//
//  SenTestCase+SQLiteKitAdditions.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 3/21/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "SenTestCase+SQLiteKitAdditions.h"

@implementation SenTestCase (SQLiteKitAdditions)

- (NSString *)generateValidTemporaryPathWithComponent:(NSString *)component
{
    NSParameterAssert(component);
    NSString *newPath = [NSTemporaryDirectory() stringByAppendingPathComponent:component];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:newPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
        return nil;
    }
    return newPath;
}

- (NSString *)pathForSQLResource:(NSString *)resource
{
    NSParameterAssert(resource);
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];

    return [mainBundle pathForResource:resource ofType:@"sql"];
}

@end
