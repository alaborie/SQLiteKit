//
//  SQLDatabaseTests.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabaseTests.h"
#import "SQLDatabase.h"

@implementation SQLDatabaseTests

- (void)testLifeCycle
{
    SQLDatabase *database = [[SQLDatabase alloc] init];

    [database open];
    [database close];
    [database release];
}

- (void)testLifeCycleAdvanced
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"foo.db"];
    SQLDatabase *database = [[SQLDatabase alloc] initWithPath:databaseLocalPath];

    [database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX)];
    [database executeQuery:@"CREATE TABLE IF NOT EXISTS user (ID INTEGER PRIMARY KEY AUTOINCREMENT, full_name TEXT);"];
    [database executeQuery:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Laborie"];
    [database executeQuery:@"INSERT INTO user(full_name) VALUES(?);", @"Igor Laborie"];
    [database close];
    [database release];
}

@end
