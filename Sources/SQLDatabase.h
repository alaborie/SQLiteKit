//
//  SQLDatabase.h
//  SQLiteKit
//
//  Created by Laborie Alexandre on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

@class SQLQuery;

@interface SQLDatabase : NSObject
{
@private
    sqlite3 *_connectionHandle;
    NSString *_localPath;
}

@property (nonatomic, readonly) sqlite3 *connectionHandle;
@property (nonatomic, readonly) NSString *localPath;

#pragma mark -

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

- (BOOL)executeSQLStatement:(NSString *)statement, ...;
- (BOOL)executeQuery:(SQLQuery *)query;
- (BOOL)executeQuery:(SQLQuery *)query thenEnumerateRowsUsingBlock:(void (^)(id row, BOOL *stop))block;
- (BOOL)executeQuery:(SQLQuery *)query withOptions:(int)options thenEnumerateRowsUsingBlock:(void (^)(id row, BOOL *stop))block;

@end
