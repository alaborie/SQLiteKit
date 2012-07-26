/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLDatabase.h"
#import "SQLQuery.h"
#import "SQLPreparedStatement.h"
#import "SQLRow.h"
#import "SQLFunction.h"
#import "SQLFile.h"

#import "SQLFunction+Private.h"

NSString * const kSQLTableInsertNotification = @"SQLTableInsertNotification";
NSString * const kSQLTableUpdateNotification = @"SQLTableUpdateNotification";
NSString * const kSQLTableDeleteNotification = @"SQLTableDeleteNotification";

NSString * const kSQLRowIDKey = @"SQLRowIDKey";
NSString * const kSQLDatabaseNameKey = @"SQLDatabaseNameKey";
NSString * const kSQLTableNameKey = @"SQLTableNameKey";

NSString * const kSQLTransactionCommitNotification = @"SQLTransactionCommitNotification";
NSString * const kSQLTransactionRollbackNotification = @"SQLTransactionRollbackNotification";

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

void sqldatabase_update_hook(void *object, int type, char const *database, char const *table, sqlite3_int64 rowID);
int sqldatabase_commit_hook(void *object);
void sqldatabase_rollback_hook(void *object);

void sqldatabase_update_hook(void *object, int type, char const *databaseName, char const *tableName, sqlite3_int64 rowID)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");
    NSString *notificationName = nil;

    switch ( type )
    {
        case SQLITE_INSERT:
        {
            notificationName = kSQLTableInsertNotification;
            break;
        }
        case SQLITE_UPDATE:
        {
            notificationName = kSQLTableUpdateNotification;
            break;
        }
        case SQLITE_DELETE:
        {
            notificationName = kSQLTableDeleteNotification;
            break;
        }
        default:
        {
            sqlitekit_cwarning(@"Cannot determine the type of the update, call ignored (database = %s, table = %s, type = %d).", databaseName, tableName, type);
        }
    }
    if ( notificationName != nil )
    {
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithLongLong:rowID], kSQLRowIDKey,
                                      [NSString stringWithUTF8String:databaseName], kSQLDatabaseNameKey,
                                      [NSString stringWithUTF8String:tableName], kSQLTableNameKey,
                                      nil];

        sqlitekit_cverbose(@"Posts notification '%@'.", notificationName);
        [database.notificationCenter postNotificationName:notificationName object:database userInfo:userInfoDict];
    }
}

int sqldatabase_commit_hook(void *object)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");

    sqlitekit_cverbose(@"Posts notification '%@'.", kSQLTransactionCommitNotification);
    [database.notificationCenter postNotificationName:kSQLTransactionCommitNotification object:database];
    return 0;
}

void sqldatabase_rollback_hook(void *object)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");

    sqlitekit_cverbose(@"Posts notification '%@'.", kSQLTransactionRollbackNotification);
    [database.notificationCenter postNotificationName:kSQLTransactionRollbackNotification object:database];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@interface SQLDatabase ()

@property (nonatomic, readonly) NSCache *statementsCache;

@property (nonatomic, readonly) NSCountedSet *functionsCountedSet;

@property (atomic, retain, readwrite) NSNotificationCenter *notificationCenter;

- (NSString *)_humanReadableStringWithBytes:(int)numberOfBytes;

@end

@implementation SQLDatabase

@synthesize connectionHandle = _connectionHandle;
@synthesize localPath = _localPath;

@synthesize statementsCache = _statementsCache;

@synthesize functionsCountedSet = _functionsCountedSet;

- (NSCountedSet *)functionsCountedSet
{
    dispatch_once(&_functionsSetPredicate, ^{
        _functionsCountedSet = [[NSCountedSet alloc] init];
    });
    return _functionsCountedSet;
}

@synthesize notificationCenter = _notificationCenter;

#pragma mark -
#pragma mark Lifecycle

+ (id)database
{
    return [[[self alloc] init] autorelease];
}

+ (id)databaseWithFileURL:(NSURL *)fileURL
{
    return [[[self alloc] initWithFileURL:fileURL] autorelease];
}

+ (id)databaseWithFilePath:(NSString *)filePath
{
    return [[[self alloc] initWithFilePath:filePath] autorelease];
}

- (id)init
{
    return [self initWithFilePath:nil];
}

- (id)initWithFileURL:(NSURL *)fileURL
{
    if ( fileURL.isFileURL == NO )
    {
        return nil;
    }
    return [self initWithFilePath:fileURL.path];
}

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if ( self != nil )
    {
        _localPath = [filePath retain];
        _statementsCache = [[NSCache alloc] init];
        sqlitekit_verbose(@"The database has been initialized (storePath = %@).", filePath);
    }
    return self;
}

- (void)dealloc
{
    if ( _connectionHandle != NULL )
    {
        [self close:NULL];
    }
    _statementsCache.delegate = nil;

    [_localPath release];
    [_statementsCache release];
    [_functionsCountedSet release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSObject

+ (void)initialize
{
    if ( strcmp(sqlite3_sourceid(), SQLITE_SOURCE_ID) != 0 )
    {
        sqlitekit_error(@"SQLite header and source version mismatch, this might cause a crash caused by a symbol not found (header = %s, source = %s).", sqlite3_sourceid(), SQLITE_SOURCE_ID);
    }
#ifdef SQLITEKIT_VERBOSE
    NSLog(@" > SQLite version %s [ ID %s ] ", sqlite3_libversion(), sqlite3_sourceid());
#endif
}

#pragma mark -
#pragma mark NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)object
{
    SQLPreparedStatement *preparedStatement = (SQLPreparedStatement *)object;
    NSAssert([preparedStatement isKindOfClass:[SQLPreparedStatement class]] == YES, @"Invalid kind of class.");

    // Completes the prepared statement before removing it from the cache.
    [preparedStatement complete];
}

#pragma mark -
#pragma mark Public

- (BOOL)open:(NSError **)error
{
    return [self openWithFlags:0 error:error];
}

- (BOOL)openWithFlags:(int)flags error:(NSError **)error
{
    if ( self.connectionHandle != NULL )
    {
        sqlitekit_warning(@"The database is already opened.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorDatabaseAlreadyOpen, @"The database is already opened.");
        return NO;
    }

    const char *filename = [self.localPath fileSystemRepresentation];
    int openResult;

    if ( filename == NULL )
    {
        filename = ":memory:";
        sqlitekit_verbose(@"The database does not have a path, will be created in-memory.");
    }
    if ( flags == 0 )
    {
        flags = (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE); // Default flags.
    }
    openResult = sqlite3_open_v2(filename, &_connectionHandle, flags, NULL);
    if ( openResult == SQLITE_OK )
    {
        sqlitekit_verbose(@"The database was opened successfully (flags = %i).", flags);
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while opening the database (filename = %s).", filename);
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot allocate memory to hold the sqlite3 object.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCannotAllocateMemory, @"Cannot allocate memory to hold the sqlite3 object.");
    }
    else
    {
        sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
        sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
        /// @note We have to explicitly close the database even if the open failed.
        /// @see http://www.sqlite.org/c3ref/open.html
        [self close:NULL];
    }
    return NO;
}

- (BOOL)close:(NSError **)error
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot close a database that is not open.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorDatabaseNotOpen, @"Cannot close a database that is not open.");
        return NO;
    }
    // We have to stop generating the database notifications.
    [self endGeneratingNotifications];
    // We have to remove all the prepared statements otherwise the close operation will fail.
    /// @note The prepared statement will be completed in the delegate method of NSCache.
    self.statementsCache.delegate = self;
    [self.statementsCache removeAllObjects];
    self.statementsCache.delegate = nil;

    if ( sqlite3_close(self.connectionHandle) == SQLITE_OK )
    {
        // Releases all the objects retained during the functions creation. We don't use 'self', because this might cause the set to be create on the fly.
        [_functionsCountedSet removeAllObjects];

        // NULL out the connection handle as soon as the close operation succeed, the pointer became obsolete.
        _connectionHandle = NULL;
        sqlitekit_verbose(@"The database was closed successfully.");
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while closing the database.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
    sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
    return NO;
}

#pragma mark -

- (BOOL)executeStatement:(NSString *)SQLStatement error:(NSError **)error
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;

    query = [[[SQLQuery alloc] initWithStatement:SQLStatement] autorelease];
    return [self executeQuery:query options:0 error:error thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments error:(NSError **)error
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;

    query = [[[SQLQuery alloc] initWithStatement:SQLStatement] autorelease];
    query.arguments = arguments;
    return [self executeQuery:query options:0 error:error thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeSQLFileAtPath:(NSString *)path error:(NSError **)error
{
    NSParameterAssert(path);
    SQLFile *file = [SQLFile fileWithFilePath:path];
    __block BOOL executionSucceed = YES;

    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        NSParameterAssert(request);

        sqlitekit_verbose(@"#%u %@", index, request);
        if ( [self executeStatement:request error:error] == NO )
        {
            executionSucceed = NO;
            *stop = YES;
        }
    }];
    return executionSucceed;
}

- (BOOL)executeQuery:(SQLQuery *)query error:(NSError **)error
{
    return [self executeQuery:query options:0 error:error thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeQuery:(SQLQuery *)query error:(NSError **)error thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block
{
    return [self executeQuery:query options:0 error:error thenEnumerateRowsUsingBlock:block];
}

- (BOOL)executeQuery:(SQLQuery *)query options:(SQLExecuteOptions)options error:(NSError **)error thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot execute a query with a database that is not open.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorDatabaseNotOpen, @"Cannot execute a query with a database that is not open.");
        return NO;
    }

    NSParameterAssert(query);
    sqlitekit_verbose(@"Execute new query (query = %@).", query);

    // PREPARE STATEMENT
    SQLPreparedStatement *statement = [[self.statementsCache objectForKey:query.SQLStatement] retain];
    BOOL shouldCompleteStatement = YES;

    if ( statement == nil )
    {
        // If no cached statement has been found for this query, we create a new one.
        statement = [[SQLPreparedStatement alloc] initWithDatabase:self query:query];
        if ( statement == nil )
        {
            sqlitekit_verbose(@"Cannot create a prepared statement from the given query.");
            sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
            sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
            return NO;
        }
        if ( options & SQLExecuteCacheStatement )
        {
            shouldCompleteStatement = NO;
            sqlitekit_verbose(@"Add the prepared statement in cache (query = %@).", query);
            [self.statementsCache setObject:statement forKey:query.SQLStatement];
        }
    }
    else
    {
        sqlitekit_verbose(@"Prepared statement retrieved from the cache (query = %@).", query);
        shouldCompleteStatement = NO;
        [statement clearBindings];
        [statement bindArguments:query.arguments];
    }

    // STEP
    SQLRow *row = nil;
    BOOL isExecuting = YES;
    BOOL stop = NO;
    NSInteger index = 0;

    while ( isExecuting == YES )
    {
        switch ( sqlite3_step(statement.compiledStatement) )
        {
            case SQLITE_DONE:
            {
                if ( index == 0 && options & SQLExecuteCallBlockIfNoResult && block != NULL )
                {
                    /// @note The flag stop is not used but we still have to provide a valid pointer, otherwise it might crash if the pointer is dereferenced.
                    block(nil, NSNotFound, &stop);
                }
                isExecuting = NO;
                break;
            }
            case SQLITE_ROW:
            {
                if (block != NULL)
                {
                    if ( row == nil )
                    {
                        row = [SQLRow rowWithDatabase:self statement:statement];
                    }
                    block(row, index, &stop);
                    isExecuting = ( stop == NO );
                    index++;
                }
                break;
            }
            default:
            {
                sqlitekit_verbose(@"A problem occurred while executing the prepared statement (query = %@).", query);
                sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
                sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
                isExecuting = NO;
                break;
            }
        }
    }

    // COMPLETE
    BOOL executionSucceed = ( shouldCompleteStatement == YES ) ? [statement complete] : [statement reset];

    [statement release];
    if ( executionSucceed == NO )
    {
        sqlitekit_verbose(@"Cannot %@ the prepared statement.", ( shouldCompleteStatement == YES ) ? @"finalized" : @"reset");
        sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
        sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
    }
    return executionSucceed;
}

#pragma mark -

- (NSNumber *)lastInsertRowID
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot retrieve the last row ID with a database that is not open.");
        return nil;
    }

    sqlite3_int64 rowid = sqlite3_last_insert_rowid(self.connectionHandle);

    if ( rowid == 0LL )
    {
        return nil;
    }
    return [NSNumber numberWithLongLong:rowid];
}

- (NSUInteger)numberOfChanges
{
    return (NSUInteger)sqlite3_changes(self.connectionHandle);
}

- (NSUInteger)totalNumberOfChanges
{
    return (NSUInteger)sqlite3_total_changes(self.connectionHandle);
}

- (void)printRuntimeStatusWithResetFlag:(BOOL)shouldReset
{
    const int mesureParameters[] =
    {
        SQLITE_STATUS_MEMORY_USED,
        SQLITE_STATUS_MALLOC_SIZE,
        SQLITE_STATUS_MALLOC_COUNT,
        SQLITE_STATUS_PAGECACHE_USED,
        SQLITE_STATUS_PAGECACHE_OVERFLOW,
        SQLITE_STATUS_PAGECACHE_SIZE,
        SQLITE_STATUS_SCRATCH_USED,
        SQLITE_STATUS_SCRATCH_OVERFLOW,
        SQLITE_STATUS_SCRATCH_SIZE,
        SQLITE_STATUS_PARSER_STACK
    };
    const int mesureParametersCount = 10;
    int parameterIndex = 0;
    int currentValue;
    int maxValue;
    int resetFlag = ( shouldReset == YES ) ? true : false;
    int statusResult;
    NSMutableString *output = [NSMutableString string];

    while ( parameterIndex < mesureParametersCount )
    {
        statusResult = sqlite3_status(mesureParameters[parameterIndex], &currentValue, &maxValue, resetFlag);
        if ( statusResult != SQLITE_OK )
        {
            sqlitekit_verbose(@"A problem occurred while fetching the runtime status (parameterIndex = %d).", parameterIndex);
            sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
            return;
        }
        switch ( mesureParameters[parameterIndex] )
        {
                // Malloc.
            case SQLITE_STATUS_MEMORY_USED:
            {
                [output setString:@""];
                [output appendFormat:@"MEMORY: used = %@ [ max = %@ ]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_MALLOC_SIZE:
            {
                [output appendFormat:@", largest_allocation = %@", [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_MALLOC_COUNT:
            {
                [output appendFormat:@", allocation_count = %d", currentValue];
                sqlitekit_log(@"%@", output);
                break;
            }
                // Page.
            case SQLITE_STATUS_PAGECACHE_USED:
            {
                [output setString:@""];
                [output appendFormat:@"PAGE: used = %@ [ max = %@ ]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_PAGECACHE_OVERFLOW:
            {
                [output appendFormat:@", overflow = %@ [ max = %@ ]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_PAGECACHE_SIZE:
            {
                [output appendFormat:@", cache_size = %@", [self _humanReadableStringWithBytes:maxValue]];
                sqlitekit_log(@"%@", output);
                break;
            }
                // Stack.
            case SQLITE_STATUS_SCRATCH_USED:
            {
                [output setString:@""];
                [output appendFormat:@"SCRATCH: %@ [ max = %@ ]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_SCRATCH_OVERFLOW:
            {
                [output appendFormat:@", overflow = %@ [ max = %@ ]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
                break;
            }
            case SQLITE_STATUS_SCRATCH_SIZE:
            {
                [output appendFormat:@", largest_allocation = %@", [self _humanReadableStringWithBytes:maxValue]];
                sqlitekit_log(@"%@", output);
                break;
            }
                // Misc.
            case SQLITE_STATUS_PARSER_STACK:
            {
                sqlitekit_log(@"PARSER: deepest_stack = %d", currentValue);
                break;
            }
            default:
            {
                sqlitekit_warning(@"Cannot print the details of an invalid status parameter.");
                break;
            }
        }
        parameterIndex++;
    }
}

#pragma mark -

- (BOOL)defineFunction:(SQLFunction *)function withName:(NSString *)name encoding:(NSInteger)encoding context:(id)object error:(NSError **)error
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot create a function with a database that is not open.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorDatabaseNotOpen, @"Cannot create a function with a database that is not open.");
        return NO;
    }

    NSParameterAssert(function);
    NSParameterAssert(name);

    /// @note Need more work to be able to use the v2 function (dlopen, dlsym, etc.). iOS 4.3 does not support the v2 function.
    if ( sqlite3_create_function(self.connectionHandle, [name UTF8String], function.numberOfArguments, encoding, function, function.function, function.step, function.final) == SQLITE_OK )
    {
        [self.functionsCountedSet addObject:function];
        function.context = object;
        sqlitekit_verbose(@"Custom function '%@' has been created successfully.", name);
        return YES;
    }
    sqlitekit_verbose(@"Cannot create the custom function (function = %@, name = %@, encoding = %d, context = %@).", function, name, encoding, object);
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
    sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
    return NO;
}

- (BOOL)removeFunction:(SQLFunction *)function withName:(NSString *)name encoding:(NSInteger)encoding error:(NSError **)error
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot remove a function with a database that is not open.");
        sqlitekit_create_error(error, kSQLiteKitErrorDomain, SQLDatabaseErrorDatabaseNotOpen, @"Cannot remove a function with a database that is not open.");
        return NO;
    }

    NSParameterAssert(name);
    if ( sqlite3_create_function(self.connectionHandle, [name UTF8String], function.numberOfArguments, encoding, function, NULL, NULL, NULL) == SQLITE_OK )
    {
        [self.functionsCountedSet removeObject:function];
        sqlitekit_verbose(@"Custom function '%@' has been removed successfully.", name);
        return YES;
    }
    sqlitekit_verbose(@"Cannot remove the custom function (name = %@, encoding = %d).", name, encoding);
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
    sqlitekit_create_error_cstring(error, kSQLiteKitErrorDomain, SQLDatabaseErrorCInterface, sqlite3_errmsg(self.connectionHandle));
    return NO;
}

#pragma mark -

- (void)beginGeneratingNotificationsIntoCenter:(NSNotificationCenter *)notificationCenter
{
    NSParameterAssert(notificationCenter);
    if ( self.notificationCenter != nil )
    {
        if ( [self.notificationCenter isEqual:notificationCenter] == YES )
        {
            return;
        }
        [self endGeneratingNotifications];
    }
    self.notificationCenter = notificationCenter;
    sqlite3_update_hook(self.connectionHandle, &sqldatabase_update_hook, self);
    sqlite3_commit_hook(self.connectionHandle, &sqldatabase_commit_hook, self);
    sqlite3_rollback_hook(self.connectionHandle, &sqldatabase_rollback_hook, self);
}

- (void)endGeneratingNotifications
{
    if ( self.notificationCenter != nil )
    {
        sqlite3_update_hook(self.connectionHandle, NULL, NULL);
        sqlite3_commit_hook(self.connectionHandle, NULL, NULL);
        sqlite3_rollback_hook(self.connectionHandle, NULL, NULL);
        self.notificationCenter = nil;
    }
}

#pragma mark -
#pragma mark Private

- (NSString *)_humanReadableStringWithBytes:(int)numberOfBytes
{
    if ( numberOfBytes >= 1099511627776 )
    {
        return [NSString stringWithFormat:@"%.2fTB", ((float)numberOfBytes / 1099511627776.0f)];

    }
    else if ( numberOfBytes >= 1073741824 )
    {
        return [NSString stringWithFormat:@"%.2fGB", ((float)numberOfBytes / 1073741824.0f)];
    }
    else if ( numberOfBytes >=  1048576 )
    {
        return [NSString stringWithFormat:@"%.2fMB", ((float)numberOfBytes / 1048576.0f)];
    }
    else if ( numberOfBytes >= 1024 )
    {
        return [NSString stringWithFormat:@"%.2fkB", ((float)numberOfBytes / 1024.0f)];
    }
    return [NSString stringWithFormat:@"%dB", numberOfBytes];
}

@end
