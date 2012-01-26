//
//  SQLQueryTests.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/26/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLQueryTests.h"
#import "SQLQuery.h"

@implementation SQLQueryTests

- (void)testInitializations
{
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;"], @"The initialization of the application should not have failed");
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;"], @"The initialization of the application should not have failed");
    STAssertNotNil(([SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user;", nil]), @"The initialization of the application should not have failed");
    STAssertNotNil([SQLQuery queryWithStatement:@"SELECT * FROM user;" arguments:nil], @"The initialization of the application should not have failed");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;"], @"The initialization of the application should not have failed");
    STAssertNotNil(([[SQLQuery alloc] initWithStatementAndArguments:@"SELECT * FROM user;", nil]), @"The initialization of the application should not have failed");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;" arguments:nil], @"The initialization of the application should not have failed");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user;" arguments:nil orArgumentsList:NULL], @"The initialization of the application should not have failed");
    STAssertNotNil(([[SQLQuery alloc] initWithStatementAndArguments:@"SELECT * FROM user WHERE name = ?;", @"einstein", nil]), @"The initialization of the application should not have failed");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user WHERE name = ?;" arguments:[NSArray arrayWithObject:@"einstein"]], @"The initialization of the application should not have failed");
    STAssertNotNil([[SQLQuery alloc] initWithStatement:@"SELECT * FROM user WHERE name = ?;" arguments:[NSArray arrayWithObject:@"einstein"] orArgumentsList:NULL], @"The initialization of the application should not have failed");
}

@end
