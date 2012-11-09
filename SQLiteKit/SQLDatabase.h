/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@class SQLEnumerator;

/**
 \brief A class that represents a SQLite database.
 */
@interface SQLDatabase : NSObject <NSCacheDelegate> {
@private
    sqlite3 *_handle;
    struct {
        unsigned int isOpen:1;
        unsigned int isReadOnly:1;
    } _state;
}

/**
 A string that indicates the path to locate the database file.
 */
@property (nonatomic, copy, readonly) NSString *path;

#pragma mark -

+ (id)database;
+ (id)databaseWithURL:(NSURL *)url;
+ (id)databaseWithPath:(NSString *)path;

- (id)initWithURL:(NSURL *)url;
- (id)initWithPath:(NSString *)path;

#pragma mark -

- (void)open;
- (void)openWithFlags:(NSInteger)flags;
- (void)close;

#pragma mark -

- (SQLEnumerator *)executeSQL:(NSString *)sql;
- (SQLEnumerator *)executeSQLWithArguments:(NSString *)sql, ...;
- (SQLEnumerator *)executeSQL:(NSString *)sql arguments:(NSArray *)arguments;

- (void)executeSQLFile:(NSString *)path;

@end
