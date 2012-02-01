//
//  SQLStatement.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLStatement.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"

@interface SQLStatement ()

- (BOOL)_bindObject:(id)object atIndex:(int)index;

@end

@implementation SQLStatement

@synthesize database = _database;
@synthesize compiledStatement = _compiledStatement;

#pragma mark -
#pragma mark Lifecycle

+ (id)statementWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query
{
    return [[[[self class] alloc] initWithDatabase:database query:query] autorelease];
}

- (id)initWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query
{
    NSParameterAssert(database);
    NSParameterAssert(query);

    self = [super init];
    if ( self != nil )
    {
        _database = [database retain];

        int resultPrepare = sqlite3_prepare_v2(database.connectionHandle, [query.SQLStatement UTF8String], query.SQLStatement.length, &_compiledStatement, NULL);

        if ( resultPrepare != SQLITE_OK )
        {
            sqlitekit_verbose(@"A problem occurred while compiling the prepared statement.");
            sqlitekit_warning(@"%s.", sqlite3_errmsg(database.connectionHandle));
            [self autorelease];
            return nil;
        }

        int argumentsCount = sqlite3_bind_parameter_count(_compiledStatement);

        if ( argumentsCount > 0 )
        {
            int index = 0;

            while (index < argumentsCount)
            {
                if ( [self _bindObject:[query.arguments objectAtIndex:index] atIndex:++index] == NO )
                {
                    [self autorelease];
                    return nil;
                }
            }
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

- (BOOL)reset
{
    int resultReset = sqlite3_reset(self.compiledStatement);

    if ( resultReset == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while resetting the prepared statement.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}


- (BOOL)finialize
{
    int resultFinalize = sqlite3_finalize(self.compiledStatement);

    if ( resultFinalize == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while finalizing the prepared statement.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}

#pragma mark -
#pragma mark Private

- (BOOL)_bindObject:(id)object atIndex:(int)index
{
    NSParameterAssert(object);
    NSParameterAssert(self.compiledStatement);

    int resultBind;

    if ( [object isKindOfClass:[NSData class]] == YES )
    {
        NSData *data = (NSData *)object;

        resultBind = sqlite3_bind_blob(self.compiledStatement, index, data.bytes, (int)data.length, SQLITE_STATIC);
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
                resultBind = sqlite3_bind_int(self.compiledStatement, index, [number intValue]);
                break;
            }
            case 'q': // long long
            case 'Q': // unsigned long long
            {
                resultBind = sqlite3_bind_int64(self.compiledStatement, index, [number longLongValue]);
                break;
            }
            case 'f': // float
            case 'd': // double
            {
                resultBind = sqlite3_bind_double(self.compiledStatement, index, [number doubleValue]);
                break;
            }
            default:
            {
                sqlitekit_warning(@"The encoded type for the specified NSNumber is invalid (type = %c).", encodedType[0]);
                // Makes sure to have the same treatment than if it was a string.
                return [self _bindObject:object atIndex:index];
            }
        }
    }
    else if ( [object isKindOfClass:[NSDate class]] == YES )
    {
        NSDate *date = (NSDate *)object;

        resultBind = sqlite3_bind_double(self.compiledStatement, index, date.timeIntervalSince1970);
    }
    else if ( [object isEqual:[NSNull null]] == YES )
    {
        resultBind = sqlite3_bind_null(self.compiledStatement, index);
    }
    else
    {
        NSString *stringValue = [object description];

        resultBind = sqlite3_bind_text(self.compiledStatement, index, [stringValue UTF8String], [stringValue length], SQLITE_STATIC);
    }
    if ( resultBind == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while binding an object (index = %i, object = %@).", index, object);
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}

@end
