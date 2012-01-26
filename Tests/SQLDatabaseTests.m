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
#import "SQLRow.h"

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
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"John Steinbeck"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Dumas"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Ernest Hemingway"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Jack Kerouac"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Victor Hugo"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Boris Vian"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Romain Gary"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Hermann Hesse"];
    [database executeSQLStatement:@"INSERT INTO user(full_name) VALUES(?);", @"Paulo Coelho"];

    SQLQuery *queryAllUsers = [SQLQuery queryWithSQLStatement:@"SELECT * FROM user;"];

    [database executeQuery:queryAllUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"#%u - %@", index, row);
    }];

    SQLQuery *queryCountUsers = [SQLQuery queryWithSQLStatement:@"SELECT count(ID) AS `number of users` FROM user;"];

    [database executeQuery:queryCountUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"#%u - %@", index, row);
    }];

    [database close];
    [database release];
}

@end
