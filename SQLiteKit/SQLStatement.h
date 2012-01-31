//
//  SQLStatement.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

@class SQLDatabase;
@class SQLQuery;

@interface SQLStatement : NSObject
{
@private
    SQLDatabase *_database;
    sqlite3_stmt *_compiledStatement;
}

@property (nonatomic, readonly) SQLDatabase *database;
@property (nonatomic, readonly) sqlite3_stmt *compiledStatement;

+ (id)statementWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

/**
 @param database Must not be nil!
 @param query Must not be nil!
 */
- (id)initWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

#pragma mark -

/**
 @return YES if the statement was reset successfully. Returns NO if an error occured.
 */
- (BOOL)reset;

/**
 @return YES if the statement was finalized successfully. Returns NO if an error occured.
 */
- (BOOL)finialize;

@end
