/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLStatement.h"

@interface SQLStatement (Private)

+ (id)statementWithSQL:(NSString *)sql database:(sqlite3 *)handle __attribute__ ((nonnull(1, 2)));
- (id)initWithSQL:(NSString *)sql  database:(sqlite3 *)handle __attribute__ ((nonnull(1, 2)));

#pragma mark -

- (void)bindObjects:(NSArray *)objects;
- (void)bindData:(NSData *)data atIndex:(NSNumber *)index;
- (void)bindNumber:(NSNumber *)number atIndex:(NSNumber *)index;
- (void)bindDate:(NSDate *)date atIndex:(NSNumber *)index;
- (void)bindNull:(NSNull *)null atIndex:(NSNumber *)index;
- (void)bindObject:(id)object atIndex:(NSNumber *)index;
- (void)clearBindings;

#pragma mark -

- (BOOL)step;

#pragma mark -

- (void)reset;
- (void)terminate;

@end
