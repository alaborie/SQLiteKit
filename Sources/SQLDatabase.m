//
//  SQLDatabase.m
//  SQLiteKit
//
//  Created by Laborie Alexandre on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabase.h"
#import "SQLStatement.h"

@implementation SQLDatabase

@synthesize connectionHandle = _connectionHandle;
@synthesize localPath = _localPath;

#pragma mark -
#pragma mark Lifecycle

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

- (BOOL)executeQuery:(NSString *)SQLQuery, ...
{
    if ( self.connectionHandle == NULL )
    {
        sqlitekit_warning(@"Cannot execute a query with a database that is not open.");
        return NO;
    }

    NSParameterAssert(SQLQuery);
    sqlitekit_verbose(@"Execute new query (query = %@).", SQLQuery);

    // PREPARE STATEMENT
    SQLStatement *statement = [SQLStatement statementWithDatabase:self query:SQLQuery];

    if ( statement == nil )
    {
        return NO;
    }

    // BIND PARAMETERS
    int argumentsCount = sqlite3_bind_parameter_count(statement.preparedStatement);

    if ( argumentsCount > 0 )
    {
        va_list arguments;
        int index = 0;

        va_start(arguments, SQLQuery);
        while (index < argumentsCount)
        {
            index++; // First index starts at one.
            [statement bindObject:va_arg(arguments, id) atIndex:index];
        }
        va_end(arguments);
    }

    // STEP
    BOOL isExecuting = YES;

    while ( isExecuting == YES )
    {
        switch ( sqlite3_step(statement.preparedStatement) )
        {
            case SQLITE_DONE:
            {
                isExecuting = NO;
                break;
            }
            case SQLITE_ROW:
            {
                sqlitekit_verbose(@"A new row of data is ready for processing.");
                break;
            }
            default:
            {
                isExecuting = NO;
                sqlitekit_verbose(@"A problem occurred while executing the prepared statement (query = %@).", SQLQuery);
                sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
                break;
            }
        }
    }

    // FINALIZE
    return [statement finialize];
}

@end
