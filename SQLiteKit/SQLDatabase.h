/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@class SQLQuery;
@class SQLRow;
@class SQLFunction;

/**
 A string that contains the name of the notification sent when an update occurs on a table.

 @note The notification object contains a dictionary with the following keys: kSQLRowIDKey, kSQLDatabaseNameKey, kSQLTableNameKey. See the description of the keys for more details.
 */
extern NSString * const kSQLTableInsertNotification;

/**
 A string that contains the name of the notification sent when an update occurs on a table.

 @note The notification object contains a dictionary with the following keys: kSQLRowIDKey, kSQLDatabaseNameKey, kSQLTableNameKey. See the description of the keys for more details.
 */
extern NSString * const kSQLTableUpdateNotification;

/**
 A string that contains the name of the notification sent when an delete occurs on a table.

 @note The notification object contains a dictionary with the following keys: kSQLRowIDKey, kSQLDatabaseNameKey, kSQLTableNameKey. See the description of the keys for more details.
 */
extern NSString * const kSQLTableDeleteNotification;

#pragma mark -

/**
 A key that contains the rowID of a SQL resource.

 @see http://www.sqlite.org/autoinc.html
 */
extern NSString * const kSQLRowIDKey;

/**
 A key that contains the name of a SQL database.
 */
extern NSString * const kSQLDatabaseNameKey;

/**
 A key that contains the name of a SQL table.
 */
extern NSString * const kSQLTableNameKey;

#pragma mark -

/**
 A string that contains the name of the notification sent when a transaction is committed.
 */
extern NSString * const kSQLTransactionCommitNotification;

/**
 A string that contains the name of the notification sent when a transaction is rollbacked.
 */
extern NSString * const kSQLTransactionRollbackNotification;

#pragma mark -

enum
{
    /**
     An option that allows to cache the compiled statement. This option should be use for all the queries executed multiple times with different parameters.

     @note Using this option properly can result in a significant performance improvement.
     @see http://www.sqlite.org/cintro.html [3.0 Binding Parameters and Reusing Prepared Statements]
     */
    SQLExecuteCacheStatement        =   1 << 1,

    /**
     An option that allows to call the enumeration block if the request returns no row. In this case, the row is equal to nil and the index to NSNotFound. The pointer given for the stop variable is a valid pointer but the associated dereferenced value is ignored.
     */
    SQLExecuteCallBlockIfNoResult   = 1 << 2,
};
typedef NSUInteger SQLExecuteOptions;

enum
{
    /**
     An error code used for all the errors related to the SQLite C API.
     */
    SQLDatabaseErrorCInterface = 100,

    /**
     An error code used for all the errors related to the memory allocation.
     */
    SQLDatabaseErrorCannotAllocateMemory,

    /**
     An error code used to inform that an operation cannot proceed because the database is already open.
     */
    SQLDatabaseErrorDatabaseAlreadyOpen,

    /**
     An error code used to inform that an operation cannot proceed because the database is not open.
     */
    SQLDatabaseErrorDatabaseNotOpen,
};
typedef NSUInteger SQLDatabaseErrors;

/**
 @brief An object that represents a SQL database.
 */
@interface SQLDatabase : NSObject <NSCacheDelegate>
{
@private
    sqlite3 *_connectionHandle;
    NSString *_localPath;

@private
    NSCache *_statementsCache;

@private
    dispatch_once_t _functionsSetPredicate;
    NSCountedSet *_functionsCountedSet;

@private
    NSNotificationCenter *_notificationCenter;
}

/**
 An handle on the SQL database provided by the C library.

 @warning This property should be used outside the class only if some functionalities provided by the C library are not implemented yet. This property might disappear in the future.
 */
@property (nonatomic, readonly) sqlite3 *connectionHandle;

/**
 A string that contains the path of the database given during its initialization. May be nil.
 */
@property (nonatomic, readonly) NSString *localPath;

/**
 A notification center used to dispatch the notifications related to the events happening in the database.
 */
@property (atomic, retain, readonly) NSNotificationCenter *notificationCenter;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new in-memory database.

 @return A new database or nil if an error occurs during its allocation or initialization.
 @note A database living in memory will vanish when the database connection is closed!
 */
+ (id)database;

/**
 Creates a new database located at the given URL.

 @param fileURL A file URL that indicates where the database is located. If nil, the database is located in memory.
 @return A new database or nil if an error occurs during its allocation or initialization.
 */
+ (id)databaseWithFileURL:(NSURL *)fileURL;

/**
 Creates a new database at the given path.

 @param filePath A path that indicates where the database is located. If nil, the database is located in memory. The URL must be a file URL!
 @return A new database or nil if an error occurs during its allocation or initialization.
 */
+ (id)databaseWithFilePath:(NSString *)filePath;

/**
 Initializes a new database located at the given URL.

 @param fileURL A file URL that indicates where the database is located. If nil, the database is located in memory. The URL must be a file URL!
 @return An initialized database or nil if an error occured.
 */
- (id)initWithFileURL:(NSURL *)fileURL;

/**
 Initializes a new database located at the given path.

 @param filePath A path that indicates where the database is located. If nil, the database is located in memory. The URL must be a file URL!
 @return An initialized database or nil if an error occured.
 @note Designated initializer.
 */
- (id)initWithFilePath:(NSString *)filePath;

#pragma mark -
/// @name Open & Close

/**
 Opens the database.

 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the database has been open or not.
 */
- (BOOL)open:(NSError **)error  __attribute__ ((pure));

/**
 Opens the database by using the specified flags.

 @param flags An integer that specifies the parameters of the open operation.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the database has been open or not.
 @see http://www.sqlite.org/34to35.html
 */
- (BOOL)openWithFlags:(int)flags error:(NSError **)error;

/**
 Closes the database.

 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the database has been close or not.
 */
- (BOOL)close:(NSError **)error;

#pragma mark -
/// @name Execution

/**
 Executes the given SQL statement.

 @param SQLStatement A string that contains the SQL statement to execute. Must not be nil!
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the execution has succeed or not.
 @see executeStatement:arguments:error:
 */
- (BOOL)executeStatement:(NSString *)SQLStatement error:(NSError **)error __attribute__ ((nonnull(1)));

/**
 Executes the given SQL statement by using the array of arguments.

 @param SQLStatement A string that contains the SQL statement to execute. Must not be nil!
 @param arguments An array that contains the arguments required by the SQL statement. The number of arguments must be exactly the number required by the statement.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the execution has succeed or not.
 @see executeStatement:error:
 */
- (BOOL)executeStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments error:(NSError **)error __attribute__ ((nonnull(1)));

/**
 Executes all the SQL statements contained in the file located at the given path.

 @param path A string that indicates the path of the file containing the statements to execute. Must not be nil;
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the execution has succeed or not.
 */
- (BOOL)executeSQLFileAtPath:(NSString *)path error:(NSError **)error __attribute__ ((nonnull(1)));

/**
 Executes the given query.

 @param query A query object to execute. Must not be nil!
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the execution has succeed or not.
 @see executeQuery:error:thenEnumerateRowsUsingBlock:
 @see executeQuery:options:error:thenEnumerateRowsUsingBlock:
 */
- (BOOL)executeQuery:(SQLQuery *)query error:(NSError **)error __attribute__ ((nonnull(1)));

/**
 Executes the given query and calls the enumeration block for each row contained in the result.

 @param query A query object. Must not be nil!
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @param block A block that will be called for each row in the result. May be nil. It takes three arguments:
    - row A row object that contains the data of the current row.
    - index An integer that contains the position of the row inside the result.
    - stop A pointer to a BOOL that if set to YES will stop further processing of the result.
 @return A boolean value that indicates whether the execution has succeed or not.
 @see executeQuery:error:
 @see executeQuery:options:error:thenEnumerateRowsUsingBlock:
 */
- (BOOL)executeQuery:(SQLQuery *)query error:(NSError **)error thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block __attribute__ ((nonnull(1)));

/**
 Executes the given query by using the specified options and calls the enumeration block for each row contained in the result.

 @param query A query object. Must not be nil!
 @param options An integer that specifies the options of the execution.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @param block A block that will be called for each row in the result. It takes three arguments: a row object that contains the data of the row, an index that contains the position of the row inside the result, and a pointer to a BOOL that if set to YES will stop further processing of the result. May be nil.
 @return A boolean value that indicates whether the execution has succeed or not.
 @see executeQuery:error:
 @see executeQuery:error:thenEnumerateRowsUsingBlock:
 */
- (BOOL)executeQuery:(SQLQuery *)query options:(SQLExecuteOptions)options error:(NSError **)error thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block __attribute__ ((nonnull(1)));

#pragma mark -
/// @name Status

/**
 Returns a number containing a unique 64-bit signed integer that identifies the latest row successfully inserted.

 @return A number or nil if the operation is impossible (for instance, If no successful insertion have ever occurs on this database).
 @see http://www.sqlite.org/c3ref/last_insert_rowid.html
 */
- (NSNumber *)lastInsertRowID;

/**
 Returns an unsigned integer that contains the number of changes caused by the most recent SQL statement on the database.

 @return An unsigned integer that indicates the number of changes caused by the most recent SQL statement.
 @see http://www.sqlite.org/c3ref/changes.html
 */
- (NSUInteger)numberOfChanges;

/**
 Returns an unsigned integer that contains the total number of changes caused by insert, delete or update since the database was opened.

 @return An unsigned integer that indicates the total number of changes.
 @see http://www.sqlite.org/c3ref/total_changes.html
 */
- (NSUInteger)totalNumberOfChanges;

/**
 Prints the runtime status information about the performance of SQLite, and optionally to reset various highwater marks.

 @param shouldReset A boolean that indicates if the highest record values must be reseted.
 */
- (void)printRuntimeStatusWithResetFlag:(BOOL)shouldReset;

#pragma mark -
/// @name SQL Function

/**
 Defines a new SQL function with the given parameters.

 @param function A SQL function object. Must not be nil!
 @param name A string that contains the name of the new function. Must not be nil!
 @param encoding An integer that defines the supported text encoding of this function. The supported values are: SQLITE_UTF8, SQLITE_UTF16LE, SQLITE_UTF16BE, SQLITE_UTF16, SQLITE_ANY, SQLITE_UTF16_ALIGNED.
 @param object A context object that will be provided to the function when executed.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the function has been defined successfully or not.
 @note If the operation succeed, the SQL function object will be retained. It will be released automatically, if the function is removed or if the database is closed.
 */
- (BOOL)defineFunction:(SQLFunction *)function withName:(NSString *)name encoding:(NSInteger)encoding context:(id)object error:(NSError **)error __attribute__ ((nonnull(1, 2)));

/**
 Removes the SQL function that matches the given parameters.

 @param function A SQL function object. Must not be nil!
 @param name A string that contains the name of the existing function. Must not be nil!
 @param encoding An integer that defines the supported text encoding of this function. The supported values are: SQLITE_UTF8, SQLITE_UTF16LE, SQLITE_UTF16BE, SQLITE_UTF16, SQLITE_ANY, SQLITE_UTF16_ALIGNED.
 @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information. You may specify nil for this parameter if you do not want the error information.
 @return A boolean value that indicates whether the function has been removed successfully or not.
 @note Remove a function that does not exists will succeed.
 @note If the operation succeed, the object function will be released.
 @warning Make sure you are giving the right parameters! Otherwise, you might released the wrong function, which might cause a dealloced object to be used in the future.
 */
- (BOOL)removeFunction:(SQLFunction *)function withName:(NSString *)name encoding:(NSInteger)encoding error:(NSError **)error __attribute__ ((nonnull(1, 2)));

#pragma mark -
/// @name Notification

/**
 Begins the generation of notifications related to the activities of the receiver.

 @param notificationCenter The notification center that will be used to dispatch the notifications. Must not be nil!
 @note There is two kind of notifications sent: those related to the tables and those related to the transactions. Here the complete list:
    - kSQLTableInsertNotification: each time an insertion occurs in a table.
    - kSQLTableUpdateNotification: each time an update occurs in a table.
    - kSQLTableDeleteNotification: each time a delete occurs in a table.
    - kSQLTransactionCommitNotification: each time a transaction is committed.
    - kSQLTransactionRollbackNotification: each time a transaction is rollback.
 @warning When responding to a notification do not modify the database that posted the notification! Any operations should be deffered until the completion of the transaction that triggered the notification. A good approach is to add operations on a serial queue that will update the database later.
 */
- (void)beginGeneratingNotificationsIntoCenter:(NSNotificationCenter *)notificationCenter __attribute__ ((nonnull(1)));

/**
 Ends the generation of notifications related to the receiver.
 */
- (void)endGeneratingNotifications;

@end
