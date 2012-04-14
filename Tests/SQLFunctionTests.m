/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <CommonCrypto/CommonDigest.h>

#import "SQLFunctionTests.h"

@implementation SQLFunctionTests

- (void)testFunction
{
    SQLDatabase *database = [SQLDatabase database];
    NSError *error = nil;

    // Creates a function that capitalized a string.
    id (^capitalizedBlock)(SQLFunction *, NSArray *, id) = nil;
    SQLFunction *capitalizedFunction = nil;

    capitalizedBlock = ^(SQLFunction *function, NSArray *arguments, id context) {
        NSCAssert(arguments.count == 1, @"Invalid number of arguments.");
        NSString *string = [arguments objectAtIndex:0];
        NSCAssert([string isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");

        return [string capitalizedString];
    };
    capitalizedFunction = [SQLFunction functionWithNumberOfArguments:1 block:capitalizedBlock];

    STAssertFalse([database addFunction:capitalizedFunction withName:@"noname" encoding:SQLITE_UTF8 context:nil error:&error], @"Add function should have failed (database = %@, error = %@).", database, error);
    STAssertFalse([database removeFunction:capitalizedFunction withName:@"noname" encoding:SQLITE_UTF8 error:&error], @"Remove function should have failed (database = %@, error = %@).", database, error);
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database removeFunction:capitalizedFunction withName:@"noname" encoding:SQLITE_UTF8 error:&error], @"Remove function failed (database = %@, error = %@).", database, error);
    STAssertTrue([database addFunction:capitalizedFunction withName:@"capitalized" encoding:SQLITE_UTF8 context:nil error:&error], @"Add function failed (database = %@, error = %@).", database, error);

    SQLQuery *capitalizedQuery = [SQLQuery queryWithStatement:@"SELECT capitalized('hello world!') AS sentence;"];

    STAssertTrue([database executeQuery:capitalizedQuery error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        STAssertTrue([[row objectForColumn:@"sentence"] isEqualToString:@"Hello World!"] == YES, @"Function returned an invalid result.");
    }], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database removeFunction:capitalizedFunction withName:@"capitalized" encoding:SQLITE_UTF8 error:&error], @"Remove function failed (database = %@, error = %@).", database, error);
    STAssertFalse([database executeQuery:capitalizedQuery error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        STAssertTrue(NO, @"This block should be executed.");
    }], @"Execute statement should have failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testFunctionSHA1
{
    SQLDatabase *database = [SQLDatabase database];
    SQLFunction *sha1Function = nil;
    NSError *error = nil;

    sha1Function = [SQLFunction functionWithNumberOfArguments:1 block:^(SQLFunction *function, NSArray *arguments, id context) {
        NSCAssert(arguments.count == 1, @"Invalid number of arguments.");
        NSString *string = [arguments objectAtIndex:0];
        NSCAssert([string isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];

        if ( CC_SHA1(stringBytes.bytes, stringBytes.length, digest) )
        {
            NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

            for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            {
                [output appendFormat:@"%02x", digest[i]];
            }
            return output;
        }
        return nil;
    }];

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database addFunction:sha1Function withName:@"sha1" encoding:SQLITE_UTF8 context:nil error:&error], @"Add function failed (database = %@, error = %@).", database, error);

    SQLQuery *sha1Query = [SQLQuery queryWithStatement:@"SELECT sha1('hello world!') AS hash;"];

    STAssertTrue([database executeQuery:sha1Query error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"hash = %@", [row objectForColumn:@"hash"]);
        STAssertTrue([[row objectForColumn:@"hash"] isEqualToString:@"430ce34d020724ed75a196dfc2ad67c77772d169"] == YES, @"Function returned an invalid result.");
    }], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database removeFunction:sha1Function withName:@"sha1" encoding:SQLITE_UTF8 error:&error], @"Remove function failed (database = %@, error = %@).", database, error);

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

@end
