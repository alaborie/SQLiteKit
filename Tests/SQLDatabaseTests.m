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

- (void)testExecuteFile
{
    NSError *error = nil;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie-db.sql"];
    NSString *databaseDump = @"\
    PRAGMA foreign_keys=OFF;\
    BEGIN TRANSACTION;\
    CREATE TABLE movies(ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, rating INTEGER);\
    INSERT INTO movies VALUES(1,'The Shawshank Redemption',9.2);\
    INSERT INTO movies VALUES(2,'The Godfather',9.2);\
    INSERT INTO movies VALUES(3,'The Godfather: Part II',9);\
    INSERT INTO movies VALUES(4,'The Good, the Bad and the Ugly',8.9);\
    INSERT INTO movies VALUES(5,'Pulp Fiction',8.9);\
    CREATE TABLE actors(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);\
    INSERT INTO actors VALUES(1,'Morgan Freeman');\
    INSERT INTO actors VALUES(2,'Tim Robbins');\
    INSERT INTO actors VALUES(3,'Marlon Brando');\
    INSERT INTO actors VALUES(4,'Al Pacino');\
    INSERT INTO actors VALUES(5,'Robert Duvall');\
    INSERT INTO actors VALUES(6,'Eli Wallach');\
    INSERT INTO actors VALUES(7,'Clint Eastwood');\
    INSERT INTO actors VALUES(8,'John Travolta');\
    INSERT INTO actors VALUES(9,'Samuel L. Jackson');\
    CREATE TABLE act(movie_ID INTEGER, actor_ID INTEGER);\
    INSERT INTO act VALUES(1,1);\
    INSERT INTO act VALUES(1,2);\
    INSERT INTO act VALUES(2,3);\
    INSERT INTO act VALUES(2,4);\
    INSERT INTO act VALUES(3,4);\
    INSERT INTO act VALUES(3,5);\
    INSERT INTO act VALUES(4,6);\
    INSERT INTO act VALUES(4,7);\
    INSERT INTO act VALUES(5,8);\
    INSERT INTO act VALUES(5,9);\
    DELETE FROM sqlite_sequence;\
    INSERT INTO sqlite_sequence VALUES('movies',5);\
    INSERT INTO sqlite_sequence VALUES('actors',9);\
    COMMIT;";

    [databaseDump writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:&error];
    STAssertNil(error, [error localizedDescription]);

    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *movieDatabase = [SQLDatabase databaseWithPath:databaseLocalPath];

    [movieDatabase open];
    [movieDatabase executeSQLFileAtPath:filePath];
    [movieDatabase close];
}

@end
