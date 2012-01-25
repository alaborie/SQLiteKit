//
//  SQLStatement.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2012 CouchSurfing International. All rights reserved.
//

#import "SQLStatement.h"
#import "SQLDatabase.h"

@implementation SQLStatement

@synthesize database = _database;
@synthesize preparedStatement = _preparedStatement;

#pragma mark -
#pragma mark Lifecycle

+ (id)statementWithDatabase:(SQLDatabase *)database query:(NSString *)SQLQuery
{
    return [[[[self class] alloc] initWithDatabase:database query:SQLQuery] autorelease];
}

- (id)initWithDatabase:(SQLDatabase *)database query:(NSString *)SQLQuery
{
    NSParameterAssert(database);
    NSParameterAssert(SQLQuery);

    self = [super init];
    if ( self != nil )
    {
        _database = [database retain];

        int resultPrepare = sqlite3_prepare_v2(database.connectionHandle, [SQLQuery UTF8String], SQLQuery.length, &_preparedStatement, NULL);

        if ( resultPrepare != SQLITE_OK )
        {
            sqlitekit_verbose(@"A problem occurred while compiling the prepared statement.");
            sqlitekit_warning(@"%s", sqlite3_errmsg(database.connectionHandle));
            [self autorelease];
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    /// @todo Check if statement is NULL, if not must be finalized.
    [_database release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public

- (void)bindObject:(id)object atIndex:(int)index
{
    NSParameterAssert(object);

    if ( [object isKindOfClass:[NSData class]] == YES )
    {
        NSData *data = (NSData *)object;

        sqlite3_bind_blob(self.preparedStatement, index, data.bytes, (int)data.length, SQLITE_STATIC);
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
                sqlite3_bind_int(self.preparedStatement, index, [number intValue]);
                break;
            }
            case 'q': // long long
            case 'Q': // unsigned long long
            {
                sqlite3_bind_int64(self.preparedStatement, index, [number longLongValue]);
                break;
            }
            case 'f': // float
            case 'd': // double
            {
                sqlite3_bind_double(self.preparedStatement, index, [number doubleValue]);
                break;
            }
            default:
            {
                sqlitekit_warning(@"The encoded type for the specified NSNumber is invalid (type = %c).", encodedType[0]);
                // Makes sure to have the same treatment than if it was a string.
                [self bindObject:[number description] atIndex:index];
                break;
            }
        }
    }
    else if ( [object isKindOfClass:[NSDate class]] == YES )
    {
        NSDate *date = (NSDate *)object;

        sqlite3_bind_double(self.preparedStatement, index, date.timeIntervalSince1970);
    }
    else if ( object == nil || [object isEqual:[NSNull null]] == YES )
    {
        sqlite3_bind_null(self.preparedStatement, index);
    }
    else
    {
        NSString *stringValue = [object description];

        sqlite3_bind_text(self.preparedStatement, index, [stringValue UTF8String], [stringValue length], SQLITE_STATIC);
    }
}

#pragma mark -

- (BOOL)reset
{
    int resultReset = sqlite3_reset(self.preparedStatement);

    if ( resultReset == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while resetting the prepared statement.");
    sqlitekit_warning(@"%s", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}


- (BOOL)finialize
{
    int resultFinalize = sqlite3_finalize(self.preparedStatement);

    if ( resultFinalize == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while finalizing the prepared statement.");
    sqlitekit_warning(@"%s", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}

@end
