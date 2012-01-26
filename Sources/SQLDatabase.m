//
//  SQLDatabase.m
//  SQLiteKit
//
//  Created by Laborie Alexandre on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabase.h"
#import "SQLQuery.h"
#import "SQLStatement.h"
#import "SQLRow.h"

@implementation SQLDatabase

@synthesize connectionHandle = _connectionHandle;
@synthesize localPath = _localPath;

#pragma mark -
#pragma mark Lifecycle

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
    if ( storeURL != nil && storeURL.isFileURL == NO )
    {
        sqlitekit_warning(@"The database must be initialized with an URL that is a local file.");
        [self autorelease];
        return nil;
    }
    return [self initWithPath:storeURL.absoluteString];
}

- (id)initWithPath:(NSString *)storePath
{
    self = [super init];
    if ( self != nil )
    {
        _localPath = [storePath retain];
        sqlitekit_verbose(@"The database has been initialized (storePath = %@).", storePath);
    }
    return self;
}

- (void)dealloc
{
    /// @todo Close the database if it's still opened.
    [_localPath release];
    [super dealloc];
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
    sqlitekit_verbose(@"A problem occurred while opening the database.");
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot allocate memory to hold the sqlite3 object.");
    }
    else
    {
        sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
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

    int resultClose = sqlite3_close(self.connectionHandle);

    if ( resultClose == SQLITE_OK )
    {
        _connectionHandle = NULL;
        sqlitekit_verbose(@"The database was closed successfully.");
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while closing the database.");
    sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
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

- (BOOL)executeWithStatementAndArguments:(NSString *)SQLStatement, ...
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;
    va_list argumentsList;

    va_start(argumentsList, SQLStatement);
    query = [[[SQLQuery alloc] initWithStatement:SQLStatement arguments:nil orArgumentsList:argumentsList] autorelease];
    va_end(argumentsList);
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments
{
    NSParameterAssert(SQLStatement);

    SQLQuery *query;

    query = [[[SQLQuery alloc] initWithStatement:SQLStatement] autorelease];
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeQuery:(SQLQuery *)query
{
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:NULL];
}

- (BOOL)executeQuery:(SQLQuery *)query thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSUInteger index, BOOL *stop))block
{
    return [self executeQuery:query withOptions:0 thenEnumerateRowsUsingBlock:block];
}

- (BOOL)executeQuery:(SQLQuery *)query withOptions:(int)options thenEnumerateRowsUsingBlock:(void (^)(SQLRow *row, NSUInteger index, BOOL *stop))block
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot execute a query with a database that is not open.");
        return NO;
    }

    NSParameterAssert(query);
    sqlitekit_verbose(@"Execute new query (query = %@).", query);

    // PREPARE STATEMENT
    SQLStatement *statement = [SQLStatement statementWithDatabase:self query:query];
    SQLRow *row = nil;

    if ( statement == nil )
    {
        return NO;
    }

    // STEP
    BOOL isExecuting = YES;
    NSUInteger index = 0;

    while ( isExecuting == YES )
    {
        switch ( sqlite3_step(statement.compiledStatement) )
        {
            case SQLITE_DONE:
            {
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
                        row = [SQLRow rowWithDatabase:self statement:statement];
                    }
                    block(row, index, &stop);
                    if ( stop == YES )
                    {
                        return [statement finialize];
                    }
                    index++;
                }
                break;
            }
            default:
            {
                sqlitekit_verbose(@"A problem occurred while executing the prepared statement (query = %@).", query);
                sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
                isExecuting = NO;
                break;
            }
        }
    }

    // FINALIZE
    return [statement finialize];
}

@end
