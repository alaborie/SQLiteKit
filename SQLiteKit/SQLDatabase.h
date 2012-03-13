/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <sqlite3.h>

@class SQLQuery;
@class SQLRow;

extern NSString * const kSQLDatabaseInsertNotification;
extern NSString * const kSQLDatabaseUpdateNotification;
extern NSString * const kSQLDatabaseDeleteNotification;
extern NSString * const kSQLDatabaseCommitNotification;
extern NSString * const kSQLDatabaseRollbackNotification;

enum
{
    /**
     An option that allows to cache the compiled statement. This option should be use for all the queries executed multiple times with different parameters.

     @note Using this option properly can result in a significant performance improvement.
     @see http://www.sqlite.org/cintro.html [3.0 Binding Parameters and Reusing Prepared Statements]
     */
    SQLDatabaseExecutingOptionCacheStatement     =   1 << 1,
};
typedef NSUInteger SQLDatabaseExecutingOptions;

@interface SQLDatabase : NSObject <NSCacheDelegate>
{
@private
    sqlite3 *_connectionHandle;
    NSString *_localPath;

@private
    NSCache *_statementsCache;

@private
    NSNotificationCenter *_notificationCenter;
}

@property (nonatomic, readonly) sqlite3 *connectionHandle;
@property (nonatomic, readonly) NSString *localPath;

@property (atomic, retain, readonly) NSNotificationCenter *notificationCenter;

#pragma mark -

+ (id)database;
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
- (BOOL)executeStatement:(NSString *)SQLStatement __attribute__ ((nonnull(1)));

/**
 @param SQLStatement Must not be nil!
 @note The arguments list must be nil terminated.
 */
- (BOOL)executeWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 @param SQLStatement Must not be nil!
 */
- (BOOL)executeWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments __attribute__ ((nonnull(1)));

/**
 @param path Must not be nil;
 */
- (BOOL)executeSQLFileAtPath:(NSString *)path __attribute__ ((nonnull(1)));

/**
 @param query Must not be nil!
 */
- (BOOL)executeQuery:(SQLQuery *)query __attribute__ ((nonnull(1)));

/**
 @param query Must not be nil!
 */
- (BOOL)executeQuery:(SQLQuery *)query thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block __attribute__ ((nonnull(1)));

/**
 @param query Must not be nil!
 @param block If the query returns no row, the block will be called once with a row equals to nil, an index equals to NSNotFound and a stop value equals to NULL.
 */
- (BOOL)executeQuery:(SQLQuery *)query withOptions:(SQLDatabaseExecutingOptions)options thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block __attribute__ ((nonnull(1)));

#pragma mark -

- (NSNumber *)lastInsertRowID;

- (NSUInteger)numberOfChanges;

- (NSUInteger)totalNumberOfChanges;

#pragma mark -

/**
 Begins the generation of notifications of database changes. A notification will be send for each commit, each rollback, each row inserted in a table, each row updated in a table and each row delete in a table.

 @param notificationCenter The notification center that will be used to dispatch the notifications. Must not be nil!

 @note The receiver will post kSQLDatabaseCommitNotification to inform of a commit on the database. It will post kSQLDatabaseRollbackNotification to inform of a rollback. Then, to be informed of updates on a specific table an observer should be added using the following constants: kSQLDatabaseInsertNotification, kSQLDatabaseUpdateNotification and kSQLDatabaseDeleteNotification. For instance to be informed of an insertion on the table bike of the main database, an observer should be add for the notification [kSQLDatabaseDeleteNotification stringByAppendingString:@"main.bike"]. A more generic way will be [kSQLDatabaseDeleteNotification stringByAppendingFormat:@"%@.%@", databaseName, tableName].
 @warning The responder of a notification must not modify the database that posted the notification! Any actions to modify the database connection must be deferred until after the completion of the operation that triggered the notification. A good pratice is to add an operation to a queue that will modify the database later.
 */
- (void)beginGeneratingNotificationsIntoCenter:(NSNotificationCenter *)notificationCenter __attribute__ ((nonnull(1)));

- (void)endGeneratingNotifications;

#pragma mark -

- (void)printRuntimeStatusWithResetFlag:(BOOL)shouldReset;

@end
