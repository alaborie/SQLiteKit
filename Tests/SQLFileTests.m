/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLFileTests.h"

#import "SenTestCase+SQLiteKitAdditions.h"

@implementation SQLFileTests

#pragma mark -
#pragma mark Tests

- (void)testShortFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_short"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
    numberOfRequests = 0;
    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"3) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
}

- (void)testShortBadFormatFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_short_bad_format"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
}

- (void)testShortCommentFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_short_comment"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 4u, @"The number of requests must be equal to 4.");
}

- (void)testShortNoSeparatorFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_short_no_separator"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 1u, @"The number of requests must be equal to 1.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 1u, @"The number of requests must be equal to 1.");
}

- (void)testEmptyFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_empty"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 0u, @"The number of requests must be equal to 0.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 0u, @"The number of requests must be equal to 0.");
}

- (void)testTravelFile
{
    NSString *filePath = [self pathForSQLResource:@"dump_travel"];
    SQLFile *file = [SQLFile fileWithFilePath:filePath];
    __block NSUInteger numberOfRequests = 0;

    for ( NSString *line in file )
    {
        sqlitekit_verbose(@"1) #%d %@", numberOfRequests, line);
        numberOfRequests++;
    }
    STAssertEquals(numberOfRequests, 188u, @"The number of requests must be equal to 188.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"2) #%d %@", numberOfRequests, request);
        numberOfRequests++;
    }];
    STAssertEquals(numberOfRequests, 188u, @"The number of requests must be equal to 188.");
    numberOfRequests = 0;
    [file enumerateRequestsUsingBlock:^(NSString *request, NSUInteger index, BOOL *stop) {
        sqlitekit_verbose(@"3) #%d %@", numberOfRequests, request);
        numberOfRequests++;
        if ( numberOfRequests == 142 )
        {
            *stop = YES;
        }
    }];
    STAssertEquals(numberOfRequests, 142u, @"The number of requests must be equal to 142.");
}

@end
