/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <sqlite3.h>

@class SQLDatabase;
@class SQLQuery;

@interface SQLPreparedStatement : NSObject
{
@private
    SQLDatabase *_database;
    sqlite3_stmt *_compiledStatement;
}

@property (nonatomic, readonly) SQLDatabase *database;
@property (nonatomic, readonly) sqlite3_stmt *compiledStatement;

+ (id)statementWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

/**
 @param database Must not be nil!
 @param query Must not be nil!
 */
- (id)initWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

#pragma mark -

/**
 @return YES if the statement was reset successfully. Returns NO if an error occured.
 */
- (BOOL)reset;

/**
 @return YES if the statement was finalized successfully. Returns NO if an error occured.
 */
- (BOOL)finialize;

#pragma mark -

/**
 @return YES if the bindings were cleared successfully. Returns NO if an error occured.
 */
- (BOOL)clearBindings;

/**
 @return YES if the arguments were bound successfully. Returns NO if an error occurred.
 */
- (BOOL)bindArguments:(NSArray *)arguments;

@end
