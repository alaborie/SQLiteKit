/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@interface SQLStatement : NSObject {
@private
    sqlite3 *_handle;
    sqlite3_stmt *_statement;

@private
    NSUInteger _numberOfColumns;
    NSDictionary *_columnsName;
}

- (NSUInteger)numberOfColumns;
- (id)objectForColumnAtIndex:(NSUInteger)index;
- (NSDictionary *)columnsName;
- (id)objectForColumn:(NSString *)name;

- (NSArray *)allObjects;
- (NSDictionary *)allObjectsAndColumns;
- (NSDictionary *)allNonNullObjectsAndColumns;

- (int)intForColumnAtIndex:(NSUInteger)index;
- (int)intForColumn:(NSString *)name;

- (long long)longlongForColumnAtIndex:(NSUInteger)index;
- (long long)longlongForColumn:(NSString *)name;

- (double)doubleForColumnAtIndex:(NSUInteger)index;
- (double)doubleForColumn:(NSString *)name;

- (const char *)textForColumnAtIndex:(NSUInteger)index;
- (const char *)textForColumn:(NSString *)name;

- (int)blobLengthForColumnAtIndex:(NSUInteger)index;
- (int)blobLengthForColumn:(NSString *)name;
- (void *)blobForColumnAtIndex:(NSUInteger)index buffer:(void *)buffer length:(int *)length;
- (void *)blobForColumn:(NSString *)name buffer:(void *)buffer length:(int *)length;

@end
