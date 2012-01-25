//
//  SQLDatabaseTests.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabaseTests.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"

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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [[SQLDatabase alloc] initWithPath:databaseLocalPath];

    [database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX)];
    [database executeSQLStatement:@"CREATE TABLE IF NOT EXISTS user (ID INTEGER PRIMARY KEY AUTOINCREMENT, full_name TEXT);"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Laborie"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Igor Laborie"];

    SQLQuery *query = [SQLQuery queryWithSQLStatement:@"SELECT full_name FROM user;"];

    [database executeQuery:query thenEnumerateRowsUsingBlock:^(id row, BOOL *stop) {
        NSLog(@"%s", __FUNCTION__);
    }];
    [database close];
    [database release];
}

@end
