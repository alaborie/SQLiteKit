/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLQueryTests.h"

@implementation SQLQueryTests

#pragma mark -
#pragma mark Tests

- (void)testInitializations
{
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;"], @"Initialization operation failed.");
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;"], @"Initialization operation failed.");
    STAssertNotNil(([SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user;", nil]), @"Initialization operation failed.");
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;" arguments:nil], @"Initialization operation failed.");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;"], @"Initialization operation failed.");
    STAssertNotNil(([[SQLQuery alloc] initWithStatementAndArguments:@"SELECT * FROM user;", nil]), @"Initialization operation failed.");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;" arguments:nil], @"Initialization operation failed.");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;" arguments:nil orArgumentsList:NULL], @"Initialization operation failed.");
    STAssertNotNil(([[SQLQuery alloc] initWithStatementAndArguments:@"SELECT * FROM user WHERE name = ?;", @"einstein", nil]), @"Initialization operation failed.");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user WHERE name = ?;" arguments:[NSArray arrayWithObject:@"einstein"]], @"Initialization operation failed.");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user WHERE name = ?;" arguments:[NSArray arrayWithObject:@"einstein"] orArgumentsList:NULL], @"Initialization operation failed.");
}

- (void)testArguments
{
    SQLQuery *insertQuery = [SQLQuery queryWithStatement:@"INSERT INTO user(name, age, job) values(?, ?, ?)"];

    sqlitekit_verbose(@"%@", insertQuery);
    STAssertNotNil(insertQuery, @"Initialization operation failed.");
    insertQuery.arguments = [NSArray arrayWithObjects:@"Bob", [NSNumber numberWithInteger:12], @"ice cream maker", nil];
    STAssertNotNil(insertQuery.arguments, @"The arguments property should not be nil.");
    sqlitekit_verbose(@"%@", insertQuery);
    insertQuery.arguments = [NSArray arrayWithObjects:@"Foo", [NSNumber numberWithInteger:12], @"teacher", nil];
    STAssertNotNil(insertQuery.arguments, @"The arguments property should not be nil.");
    sqlitekit_verbose(@"%@", insertQuery);
    insertQuery.arguments = [NSArray arrayWithObjects:@"Bar", [NSNumber numberWithInteger:12], @"attorney", nil];
    STAssertNotNil(insertQuery.arguments, @"The arguments property should not be nil.");
    sqlitekit_verbose(@"%@", insertQuery);
    insertQuery.arguments = nil;
    STAssertNil(insertQuery.arguments, @"The arguments property should be nil.");
    sqlitekit_verbose(@"%@", insertQuery);
}

@end
