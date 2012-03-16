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

NSString * const kSQLDatabaseInsertNotification = @"@insert.";
NSString * const kSQLDatabaseUpdateNotification = @"@update.";
NSString * const kSQLDatabaseDeleteNotification = @"@delete.";
NSString * const kSQLDatabaseCommitNotification = @"@commit";
NSString * const kSQLDatabaseRollbackNotification = @"@rollback";

void sqldatabase_update_hook(void *object, int type, char const *database, char const *table, sqlite3_int64 rowID);
int sqldatabase_commit_hook(void *object);
void sqldatabase_rollback_hook(void *object);

@interface SQLDatabase ()

@property (nonatomic, readonly) NSCache *statementsCache;

@property (atomic, retain, readwrite) NSNotificationCenter *notificationCenter;

- (NSString *)_humanReadableStringWithBytes:(int)numberOfBytes;

@end

////////////////////////////////////////////////////////////////////////////////

void sqldatabase_update_hook(void *object, int type, char const *databaseName, char const *tableName, sqlite3_int64 rowID)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");
    NSString *notificationName = nil;

    switch ( type )
    {
        case SQLITE_INSERT:
        {
            notificationName = [kSQLDatabaseInsertNotification stringByAppendingFormat:@"%s.%s", databaseName, tableName];
            break;
        }
        case SQLITE_UPDATE:
        {
            notificationName = [kSQLDatabaseUpdateNotification stringByAppendingFormat:@"%s.%s", databaseName, tableName];
            break;
        }
        case SQLITE_DELETE:
        {
            notificationName = [kSQLDatabaseDeleteNotification stringByAppendingFormat:@"%s.%s", databaseName, tableName];
            break;
        }
        default:
        {
            sqlitekit_cwarning(database, @"Cannot determine the type of the update, call ignored (database = %s, table = %s).", databaseName, tableName);
        }
    }
    if ( notificationName != nil )
    {
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithLongLong:rowID], @"rowID",
                                      [NSString stringWithUTF8String:databaseName], @"databaseName",
                                      [NSString stringWithUTF8String:tableName], @"tableName",
                                      nil];

        sqlitekit_cverbose(database, @"Posts notification '%@'.", notificationName);
        [database.notificationCenter postNotificationName:notificationName object:database userInfo:userInfoDict];
    }
}

int sqldatabase_commit_hook(void *object)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");

    sqlitekit_cverbose(database, @"Posts notification '%@'.", kSQLDatabaseCommitNotification);
    [database.notificationCenter postNotificationName:kSQLDatabaseCommitNotification object:database];
    return 0;
}

void sqldatabase_rollback_hook(void *object)
{
    SQLDatabase *database = (SQLDatabase *)object;
    NSCAssert([database isKindOfClass:[SQLDatabase class]] == YES, @"Invalid kind of class.");

    sqlitekit_cverbose(database, @"Posts notification '%@'.", kSQLDatabaseRollbackNotification);
    [database.notificationCenter postNotificationName:kSQLDatabaseRollbackNotification object:database];
}

////////////////////////////////////////////////////////////////////////////////

@implementation SQLDatabase

@synthesize connectionHandle = _connectionHandle;
@synthesize localPath = _localPath;

@synthesize statementsCache = _statementsCache;

@synthesize notificationCenter = _notificationCenter;

#pragma mark -
#pragma mark Lifecycle

+ (id)database
{
    return [[[self alloc] init] autorelease];
}

+ (id)databaseWithURL:(NSURL *)storeURL
{
    return [[[self alloc] initWithURL:storeURL] autorelease];
}

+ (id)databaseWithPath:(NSString *)storePath
{
    return [[[self alloc] initWithPath:storePath] autorelease];
}

- (id)init
{
    return [self initWithPath:nil];
}

- (id)initWithURL:(NSURL *)storeURL
{
    return [self initWithPath:storeURL.absoluteString];
}

- (id)initWithPath:(NSString *)storePath
{
    self = [super init];
    if ( self != nil )
    {
        _localPath = [storePath retain];
        _statementsCache = [[NSCache alloc] init];
        _statementsCache.delegate = self;
        sqlitekit_verbose(@"The database has been initialized (storePath = %@).", storePath);
    }
    return self;
}

- (void)dealloc
{
    if ( _connectionHandle != NULL )
    {
        [self close];
    }

    [_localPath release];
    [_statementsCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSObject

+ (void)load
{
#ifdef SQLITEKIT_VERBOSE
    NSLog(@"> SQLite version %s [ ID %s ] ", sqlite3_libversion(), sqlite3_sourceid());
#endif
}

#pragma mark -
#pragma mark NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)object
{
    SQLPreparedStatement *preparedStatement = (SQLPreparedStatement *)object;
    NSAssert([preparedStatement isKindOfClass:[SQLPreparedStatement class]] == YES, @"Invalid kind of class.");

    sqlitekit_verbose(@"Will evict prepared statement: %s.", sqlite3_sql(preparedStatement.compiledStatement));
    // Finalizes the prepared statement before removing it from the cache.
    [preparedStatement finialize];
}

#pragma mark -
#pragma mark Public

- (BOOL)open
{
    return [self openWithFlags:0];
}

- (BOOL)openWithFlags:(int)flags
{
    if ( self.connectionHandle != NULL )
    {
        sqlitekit_warning(@"The database is already opened.");
        return NO;
    }

    const char *filename = [self.localPath fileSystemRepresentation];
    int openResult;

    if ( filename == NULL )
    {
        filename = ":memory:";
        sqlitekit_verbose(@"The database does not have a path, will be created in-memory.");
    }
#if SQLITE_VERSION_NUMBER >= 3005000
    if ( flags == 0 )
    {
        flags = (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE); // Default flags.
    }
    openResult = sqlite3_open_v2(filename, &_connectionHandle, flags, NULL);
#else
    if ( flags != 0 )
    {
        sqlitekit_warning(@"Cannot use the given flags because the version used of the SQLite library does not allow this. In order to use the flags, you should use a version equal or greater to 3.5.0.");
    }
    openResult = sqlite3_open(filename, &_databaseHandle);
#endif
    if ( openResult == SQLITE_OK )
    {
        sqlitekit_verbose(@"The database was opened successfully (flags = %i).", flags);
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while opening the database (filename = %s).", filename);
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot allocate memory to hold the sqlite3 object.");
    }
    else
    {
        sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
        /// @note We have to explicitly close the database even if the open failed.
        /// @see http://www.sqlite.org/c3ref/open.html
        [self close];
    }
    return NO;
}

- (BOOL)close
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot close a database that is not open.");
        return NO;
    }
    // We have to stop generating the database notifications.
    [self endGeneratingNotifications];
    // We have to remove all the prepared statements otherwise the close operation will fail.
    /// @note The prepared statement will be finalized in the delegate method of NSCache.
    [self.statementsCache removeAllObjects];

    int resultClose = sqlite3_close(self.connectionHandle);

    if ( resultClose == SQLITE_OK )
    {
        // NULL out the connection handle as soon as the close operation succeed, the pointer became obsolete.
        _connectionHandle = NULL;
        sqlitekit_verbose(@"The database was closed successfully.");
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while closing the database.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
    return NO;
}

#pragma mark -

- (BOOL)executeStatement:(NSString *)SQLStatement
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;

    query = [[[SQLQuery alloc] initWithStatement:SQLStatement] autorelease];
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeStatementWithArguments:(NSString *)SQLStatement, ...
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;
    va_list argumentsList;

    va_start(argumentsList, SQLStatement);
    query = [[[SQLQuery alloc] initWithStatement:SQLStatement arguments:nil orArgumentsList:argumentsList] autorelease];
    va_end(argumentsList);
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeStatement:(NSString *)SQLStatement withArguments:(NSArray *)arguments
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;

    query = [[[SQLQuery alloc] initWithStatement:SQLStatement] autorelease];
    query.arguments = arguments;
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeSQLFileAtPath:(NSString *)path
{
    /// @todo This is only a quick version. Should be rewritten to improves the performances, errors management, etc.
    NSParameterAssert(path);

    NSError *error = nil;
    NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    NSAssert(error == nil, [error localizedDescription]);

    NSRange searchRange = NSMakeRange(0, contentOfFile.length);
    NSRange eofRange = [contentOfFile rangeOfString:@";"];
    NSCharacterSet *whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    while ( eofRange.location !=  NSNotFound ) {
        NSRange lineRange = NSMakeRange(searchRange.location, NSMaxRange(eofRange) - searchRange.location);
        NSString *line = [[contentOfFile substringWithRange:lineRange] stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];

        [self executeStatement:line];
        searchRange.location = NSMaxRange(lineRange);
        searchRange.length -= lineRange.length;
        eofRange = [contentOfFile rangeOfString:@";" options:0 range:searchRange];
    }
    NSAssert(searchRange.length == 0, @"Syntax error");
    return YES;
}

- (BOOL)executeQuery:(SQLQuery *)query
{
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeQuery:(SQLQuery *)query thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block
{
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:block];
}

- (BOOL)executeQuery:(SQLQuery *)query withOptions:(SQLDatabaseExecutingOptions)options thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSInteger index, BOOL *stop))block
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot execute a query with a database that is not open.");
        return NO;
    }

    NSParameterAssert(query);
    sqlitekit_verbose(@"Execute new query (query = %@).", query);

    // PREPARE STATEMENT
    SQLPreparedStatement *statement = [[self.statementsCache objectForKey:query.SQLStatement] retain];
    BOOL shouldFinalizeStatement = YES;

    if ( statement == nil )
    {
        // If no cached statement has been found for this query, we create a new one.
        statement = [[SQLPreparedStatement alloc] initWithDatabase:self query:query];
        if ( statement == nil )
        {
            return NO;
        }
        if ( options & SQLDatabaseExecutingOptionCacheStatement )
        {
            shouldFinalizeStatement = NO;
            sqlitekit_verbose(@"Add the prepared statement in cache (query = %@).", query);
            [self.statementsCache setObject:statement forKey:query.SQLStatement];
        }
    }
    else
    {
        sqlitekit_verbose(@"Prepared statement retrieved from the cache (query = %@).", query);
        shouldFinalizeStatement = NO;
        [statement clearBindings];
        [statement bindArguments:query.arguments];
    }

    // STEP
    SQLRow *row = nil;
    BOOL isExecuting = YES;
    NSInteger index = 0;

    while ( isExecuting == YES )
    {
        switch ( sqlite3_step(statement.compiledStatement) )
        {
            case SQLITE_DONE:
            {
                if ( index == 0 && block != NULL )
                {
                    /// @note The flag stop is not used but we still have to provide a valid pointer, otherwise it might crash if the pointer is dereferenced.
                    BOOL stop = NO;

                    block(nil, NSNotFound, &stop);
                }
                isExecuting = NO;
                break;
            }
            case SQLITE_ROW:
            {
                if (block != NULL)
                {
                    BOOL stop = NO;

                    if ( row == nil )
                    {
                        row = [[SQLRow alloc] initWithDatabase:self statement:statement];
                    }
                    block(row, index, &stop);
                    if ( stop == YES )
                    {
                        BOOL executionResult = [statement finialize];

                        [row release];
                        [statement release];
                        return executionResult;
                    }
                    index++;
                }
                break;
            }
            default:
            {
                sqlitekit_verbose(@"A problem occurred while executing the prepared statement (query = %@).", query);
                sqlitekit_warning(@"%s.", sqlite3_errmsg(self.connectionHandle));
                isExecuting = NO;
                break;
            }
        }
    }
    [row release];

    // FINALIZE
    BOOL executionResult = ( shouldFinalizeStatement == YES ) ? [statement finialize] : [statement reset];

    [statement release];
    return executionResult;
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
                [output appendFormat:@"MEMORY: used = %@ [ max = % @]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
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
                [output appendFormat:@", overflow = %@ [ max = %@]", [self _humanReadableStringWithBytes:currentValue], [self _humanReadableStringWithBytes:maxValue]];
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
