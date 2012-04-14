/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLFunction.h"
#import "SQLFunction+Private.h"

static void sqlfunction_function(sqlite3_context *context, int numberOfArguments, sqlite3_value **values);
static void sqlfunction_step(sqlite3_context *context, int numberOfArguments, sqlite3_value **values);
static void sqlfunction_final(sqlite3_context *context);
static NSArray *sqlfunction_get_objc_values(int numberOfArguments, sqlite3_value **values);
static void sqlfunction_set_result(sqlite3_context *context, id returnValue);

void sqlfunction_function(sqlite3_context *context, int numberOfArguments, sqlite3_value **values)
{
    SQLFunction *function = (SQLFunction *)sqlite3_user_data(context);
    NSCAssert([function isKindOfClass:[SQLFunction class]], @"Invalid kind of class.");
    NSArray *arguments = sqlfunction_get_objc_values(numberOfArguments, values);
    id returnValue = function.block(function, arguments, function.context);

    sqlfunction_set_result(context, returnValue);
}

void sqlfunction_step(sqlite3_context *context, int numberOfArguments, sqlite3_value **values)
{
    SQLFunction *function = (SQLFunction *)sqlite3_user_data(context);
    NSCAssert([function isKindOfClass:[SQLFunction class]], @"Invalid kind of class.");
    NSArray *arguments = sqlfunction_get_objc_values(numberOfArguments, values);

    function.operation(function, arguments, function.context);
}

void sqlfunction_final(sqlite3_context *context)
{
    SQLFunction *function = (SQLFunction *)sqlite3_user_data(context);
    NSCAssert([function isKindOfClass:[SQLFunction class]], @"Invalid kind of class.");
    id returnValue = function.complete(function, function.context);

    sqlfunction_set_result(context, returnValue);
}

NSArray *sqlfunction_get_objc_values(int numberOfArguments, sqlite3_value **values)
{
    NSMutableArray *arguments = ( ( numberOfArguments > 0 ) ? [NSMutableArray arrayWithCapacity:numberOfArguments] : nil );

    for ( int index = 0; index < numberOfArguments; index++ )
    {
        switch ( sqlite3_value_numeric_type(values[index]) )
        {
            case SQLITE_INTEGER:
            {
                [arguments addObject:[NSNumber numberWithLongLong:sqlite3_value_int64(values[index])]];
                break;
            }
            case SQLITE_FLOAT:
            {
                [arguments addObject:[NSNumber numberWithDouble:sqlite3_value_double(values[index])]];
                break;
            }
            case SQLITE_BLOB:
            {
                int numberOfBytes = sqlite3_value_bytes(values[index]);
                void *bytes = malloc(numberOfBytes);

                if (bytes != NULL)
                {
                    memcpy(bytes, sqlite3_value_blob(values[index]), numberOfBytes);
                    [arguments addObject:[NSData dataWithBytesNoCopy:bytes length:numberOfBytes freeWhenDone:YES]];
                }
                else
                {
                    sqlitekit_cwarning(nil, @"Cannot allocate memory to hold the blob object (values[%i] = %p).", index, values[index]);
                    [arguments addObject:[NSNull null]];
                }
                break;
            }
            case SQLITE_NULL:
            {
                [arguments addObject:[NSNull null]];
                break;
            }
            case SQLITE3_TEXT:
            {
                [arguments addObject:[NSString stringWithUTF8String:(const char *)sqlite3_value_text(values[index])]];
                break;
            }
            default:
            {
                sqlitekit_cwarning(nil, @"Cannot find the type of the argument (values[%i] = %p).", index, values[index]);
            }
        }
    }
    return arguments;
}

void sqlfunction_set_result(sqlite3_context *context, id returnValue)
{
    if ( [returnValue isKindOfClass:[NSData class]] == YES )
    {
        NSData *data = (NSData *)returnValue;

        sqlite3_result_blob(context, data.bytes, (int)data.length, SQLITE_STATIC);
    }
    else if ( [returnValue isKindOfClass:[NSNumber class]] == YES )
    {
        NSNumber *number = (NSNumber *)returnValue;
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
                sqlite3_result_int(context, [number intValue]);
                break;
            }
            case 'q': // long long
            case 'Q': // unsigned long long
            {
                sqlite3_result_int64(context, [number longLongValue]);
                break;
            }
            case 'f': // float
            case 'd': // double
            {
                sqlite3_result_double(context, [number doubleValue]);
                break;
            }
            default:
            {
                sqlitekit_cwarning(nil, @"The encoded type for the specified NSNumber is invalid (returnValue = %@, type = %c).", returnValue, encodedType[0]);
                // Makes sure to have the same treatment than if it was a string.
                return sqlfunction_set_result(context, [returnValue description]);
            }
        }
    }
    else if ( [returnValue isKindOfClass:[NSDate class]] == YES )
    {
        NSDate *date = (NSDate *)returnValue;

        sqlite3_result_double(context, date.timeIntervalSince1970);
    }
    else if ( returnValue == nil || [returnValue isEqual:[NSNull null]] == YES )
    {
        sqlite3_result_null(context);
    }
    else
    {
        const char *cString = [[returnValue description] UTF8String];
        NSUInteger cStringLength = strlen(cString);

        sqlite3_result_text(context, cString, cStringLength, SQLITE_STATIC);
    }
}

////////////////////////////////////////////////////////////////////////////////

@implementation SQLFunction

@synthesize numberOfArguments = _numberOfArguments;
@synthesize context = _context;

@synthesize block = _block;
@synthesize operation = _operation;
@synthesize complete = _complete;

- (void (*)(sqlite3_context *, int, sqlite3_value **))function
{
    return ( self.block != nil ) ? &sqlfunction_function : NULL;
}

- (void (*)(sqlite3_context *, int, sqlite3_value **))step
{
    return ( self.operation != nil ) ? &sqlfunction_step : NULL;
}

- (void (*)(sqlite3_context *))final
{
    return ( self.complete != nil ) ? &sqlfunction_final : NULL;
}

#pragma mark -
#pragma mark Lifecycle

+ (id)functionWithNumberOfArguments:(NSUInteger)numberOfArguments block:(id (^)(SQLFunction *function, NSArray *arguments, id context))block
{
    return [[[self alloc] initWithNumberOfArguments:numberOfArguments block:block] autorelease];
}

- (id)init
{
    [self autorelease];
    return nil;
}

- (id)initWithNumberOfArguments:(NSUInteger)numberOfArguments block:(id (^)(SQLFunction *function, NSArray *arguments, id context))block
{
    self = [super init];
    if ( self != nil )
    {
        _numberOfArguments = numberOfArguments;
        _block = [block copy];
    }
    return self;
}

- (void)dealloc
{
    [_context release];
    [_block release];
    [_operation release];
    [_complete release];
    [super dealloc];
}

@end
