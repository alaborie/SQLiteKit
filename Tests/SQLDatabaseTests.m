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
    /// @todo Check the return values to make sure that the operations have succeed.

    [database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX)];
    [database executeStatement:@"CREATE TABLE IF NOT EXISTS user (ID INTEGER PRIMARY KEY AUTOINCREMENT, full_name TEXT);"];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Steinbeck", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Dumas", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ernest Hemingway", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jack Kerouac", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Victor Hugo", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Boris Vian", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Romain Gary", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Hermann Hesse", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Paulo Coelho", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jean Jacques Rousseau", nil];
    [database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Joseph Conrad", nil];

    SQLQuery *queryAllUsers = [SQLQuery queryWithStatement:@"SELECT * FROM user;"];

    [database executeQuery:queryAllUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"#%02u - %@", index, row);
    }];

    SQLQuery *queryCountUsers = [SQLQuery queryWithStatement:@"SELECT count(ID) AS `number of users` FROM user;"];

    [database executeQuery:queryCountUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"#%u - %@", index, row);
    }];

    SQLQuery *queryBorisVian = [SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user WHERE full_name = ?;", @"Boris Vian", nil];

    [database executeQuery:queryBorisVian thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }];

    SQLQuery *queryLike = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE full_name LIKE 'J%';"];

    [database executeQuery:queryLike thenEnumerateRowsUsingBlock:^(SQLRow *row, NSUInteger index, BOOL *stop) {
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }];

    [database close];
    [database release];
}

@end
