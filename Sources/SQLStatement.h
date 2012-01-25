//
//  SQLStatement.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import <sqlite3.h>

@class SQLDatabase;

@interface SQLStatement : NSObject
{
@private
    SQLDatabase *_database;
@private
    sqlite3_stmt *_preparedStatement;
}

@property (nonatomic, readonly) SQLDatabase *database;
@property (nonatomic, readonly) sqlite3_stmt *preparedStatement;

+ (id)statementWithDatabase:(SQLDatabase *)database query:(NSString *)SQLQuery;

/**
 @param database Must not be nil!
 @param SQLQuery Must not be nil!
 */
- (id)initWithDatabase:(SQLDatabase *)database query:(NSString *)SQLQuery;

#pragma mark -

/**
 @param object Must not be nil!
 */
- (void)bindObject:(id)object atIndex:(int)index;

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
