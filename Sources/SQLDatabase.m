//
//  SQLDatabase.m
//  SQLiteKit
//
//  Created by Laborie Alexandre on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabase.h"

@interface SQLDatabase ()

- (void)_bindStatement:(sqlite3_stmt *)preparedStatement withObject:(id)object atIndex:(int)index;

@end

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
    sqlite3_stmt *preparedStatement;
    int resultPrepare = sqlite3_prepare_v2(self.connectionHandle, [SQLQuery UTF8String], SQLQuery.length, &preparedStatement, NULL);

    if ( resultPrepare != SQLITE_OK )
    {
        sqlitekit_verbose(@"A problem occurred while compiling the prepared statement.");
        sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
        return NO;
    }

    // BIND PARAMETERS
    int argumentsCount = sqlite3_bind_parameter_count(preparedStatement);

    if ( argumentsCount > 0 )
    {
        va_list arguments;
        int index = 0;

        va_start(arguments, SQLQuery);
        while (index < argumentsCount)
        {
            index++; // First index starts at one.
            [self _bindStatement:preparedStatement withObject:va_arg(arguments, id) atIndex:index];
        }
        va_end(arguments);
    }

    // STEP
    BOOL isExecuting = YES;

    while ( isExecuting == YES )
    {
        switch ( sqlite3_step(preparedStatement) )
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
    int resultFinalize = sqlite3_finalize(preparedStatement);

    if ( resultFinalize == SQLITE_OK )
    {
        sqlitekit_verbose(@"The execution of the request was performed successfully.");
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while finalizing the prepared statement.");
    sqlitekit_warning(@"%s", sqlite3_errmsg(self.connectionHandle));
    return NO;
}

#pragma mark -
#pragma mark Private

- (void)_bindStatement:(sqlite3_stmt *)preparedStatement withObject:(id)object atIndex:(int)index
{
    NSParameterAssert(preparedStatement);
    NSParameterAssert(object);

    if ( [object isKindOfClass:[NSData class]] == YES )
    {
        NSData *data = (NSData *)object;

        sqlite3_bind_blob(preparedStatement, index, data.bytes, (int)data.length, SQLITE_STATIC);
    }
    else if ( [object isKindOfClass:[NSNumber class]] == YES )
    {
        NSNumber *number = (NSNumber *)object;
        const char *encodedType = [number objCType];
        NSCAssert(encodedType != NULL && strlen(encodedType) > 0, @"The encoded type returned is invalid (Must not null and have a length greater than zero).");

        /// @see http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        switch ( encodedType[0] )
        {
            case 'B': // C++ bool or a C99 _Bool
            case 'c': // char
            case 'i': // int
            case 's': // short
            case 'l': // long (l is treated as a 32-bit quantity on 64-bit programs.)
            case 'L': // unsigned long
            case 'C': // unsigned char
            case 'I': // unsigned integer
            case 'S': // unsigned short
            {
                sqlite3_bind_int(preparedStatement, index, [number intValue]);
                break;
            }
            case 'q': // long long
            case 'Q': // unsigned long long
            {
                sqlite3_bind_int64(preparedStatement, index, [number longLongValue]);
                break;
            }
            case 'f': // float
            case 'd': // double
            {
                sqlite3_bind_double(preparedStatement, index, [number doubleValue]);
                break;
            }
            default:
            {
                sqlitekit_warning(@"The encoded type for the specified NSNumber is invalid (type = %c).", encodedType[0]);
                // Makes sure to have the same treatment than if it was a string.

                [self _bindStatement:preparedStatement withObject:[number description] atIndex:index];
                break;
            }
        }
    }
    else if ( [object isKindOfClass:[NSDate class]] == YES )
    {
        NSDate *date = (NSDate *)object;

        sqlite3_bind_double(preparedStatement, index, date.timeIntervalSince1970);
    }
    else if ( object == nil || [object isEqual:[NSNull null]] == YES )
    {
        sqlite3_bind_null(preparedStatement, index);
    }
    else
    {
        NSString *stringValue = [object description];

        sqlite3_bind_text(preparedStatement, index, [stringValue UTF8String], [stringValue length], SQLITE_STATIC);
    }
}

@end
