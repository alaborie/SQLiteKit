//
//  SQLDatabase.h
//  SQLiteKit
//
//  Created by Laborie Alexandre on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

@class SQLQuery;
@class SQLRow;

enum
{
    SQLDatabaseOptionCacheStatement    =   1 << 1,
};

@interface SQLDatabase : NSObject <NSCacheDelegate>
{
@private
    sqlite3 *_connectionHandle;
    NSString *_localPath;

@private
    NSCache *_statementsCache;
}

@property (nonatomic, readonly) sqlite3 *connectionHandle;
@property (nonatomic, readonly) NSString *localPath;

#pragma mark -

+ (id)databaseWithURL:(NSURL *)storeURL;
+ (id)databaseWithPath:(NSString *)storePath;

- (id)initWithURL:(NSURL *)storeURL;

/**
 @param storePath If nil, the database will be created in-memory. This in-memory database will vanish when the database connection is closed! The object property will be equal to @":memory:".
 @note Designated initializer.
 */
- (id)initWithPath:(NSString *)storePath;

#pragma mark -

- (BOOL)open __attribute__ ((pure));

/**
 @return YES if the database was opened successfully. Returns NO if an error occured.

 @note In this method we are using sqlite3_open_v2(), which has been introduced in the version 3.5.0.
 @see http://www.sqlite.org/34to35.html
 */
- (BOOL)openWithFlags:(int)flags;

/**
 @return YES if the database was closed successfully. Returns NO if an error occured.
 */
- (BOOL)close;

#pragma mark -

/**
 @param SQLStatement Must not be nil!
 */
- (BOOL)executeStatement:(NSString *)SQLStatement;

/**
 @param SQLStatement Must not be nil!
 @note The arguments list must be nil terminated.
 */
- (BOOL)executeWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 @param SQLStatement Must not be nil!
 */
- (BOOL)executeWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments;

/**
 @param path Must not be nil;
 */
- (BOOL)executeSQLFileAtPath:(NSString *)path;

/**
 @param query Must not be nil!
 */
- (BOOL)executeQuery:(SQLQuery *)query;

/**
 @param query Must not be nil!
 */
- (BOOL)executeQuery:(SQLQuery *)query thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block;

/**
 @param query Must not be nil!
 @param block If the query returns no row, the block will be called once with a row equals to nil, an index equals to NSNotFound and a stop value equals to NULL.
 */
- (BOOL)executeQuery:(SQLQuery *)query withOptions:(int)options thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block;

#pragma mark -

- (void)printRuntimeStatusWithResetFlag:(BOOL)shouldReset;

@end
