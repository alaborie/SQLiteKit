/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLPreparedStatement.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"

@interface SQLPreparedStatement ()

- (BOOL)_bindObject:(id)object atIndex:(int)index;

@end

@implementation SQLPreparedStatement

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
        if ( [self bindArguments:query.arguments] == NO )
        {
            [self autorelease];
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    if ( _compiledStatement != NULL )
    {
        [self finialize];
    }

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
        // NULL out the compiled statement as soon as the finalize operation succeed, the pointer became obsolete.
        _compiledStatement = NULL;
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while finalizing the prepared statement.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}

#pragma mark -

- (BOOL)clearBindings
{
    int resultClearBindings = sqlite3_clear_bindings(self.compiledStatement);

    if ( resultClearBindings == SQLITE_OK )
    {
        return YES;
    }
    sqlitekit_verbose(@"A problem occurred while clearing the bindings of the prepared statement.");
    sqlitekit_warning(@"%s.", sqlite3_errmsg(self.database.connectionHandle));
    return NO;
}

- (BOOL)bindArguments:(NSArray *)arguments
{
    int argumentsCount = sqlite3_bind_parameter_count(_compiledStatement);
    NSAssert([arguments count] == argumentsCount, @"The number of arguments doesn't match.");

    if ( argumentsCount > 0 )
    {
        int index = 0;

        while (index < argumentsCount)
        {
            if ( [self _bindObject:[arguments objectAtIndex:index] atIndex:++index] == NO )
            {
                return NO;
            }
        }
    }
    return YES;
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
        const char *cString = [[object description] UTF8String];
        NSUInteger cStringLength = strlen(cString);

        resultBind = sqlite3_bind_text(self.compiledStatement, index, cString, cStringLength, SQLITE_STATIC);
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
