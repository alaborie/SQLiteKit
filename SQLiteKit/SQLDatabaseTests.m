/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLDatabaseTests.h"

@implementation SQLDatabaseTests

- (void)testFlow {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *userLibrariesURLs = [defaultManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    NSAssert(userLibrariesURLs.count > 0, @"Cannot find the user libraries URLs.");
    NSURL *databaseURL = [[userLibrariesURLs objectAtIndex:0] URLByAppendingPathComponent:@"hello.sqlite"];
    SQLDatabase *database = [SQLDatabase databaseWithURL:databaseURL];

    [database open];
    [database executeSQL:@"CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, lastname TEXT);"];
    [database executeSQLWithArguments:@"INSERT INTO users(firstname, lastname) values(?, ?);", @"Johnny", @"Appleseed", nil];
    [[database executeSQL:@"SELECT * FROM users;"] enumerateRowsValuesUsingBlock:^(NSArray *values, BOOL *stop) {
        NSLog(@"id = %@, firstname = %@, lastname = %@", [values objectAtIndex:0], [values objectAtIndex:1], [values objectAtIndex:2]);
    }];
    [database close];
}

@end
