/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLGlobal.h"

NSString * const kSQLiteKitErrorDomain = @"SQLiteKitErrorDomain";

void __sqlitekit_log(NSString *file, NSUInteger line, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    if ( file != nil )
    {
        format = [format stringByAppendingFormat:@" [%@:%d]", file, line];
    }
    NSLogv([@"(SQLiteKit)" stringByAppendingFormat:@" %@", format], arguments);
    va_end(arguments);
}

void __sqlitekit_warning(NSString *file, NSUInteger line, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    if ( file != nil )
    {
        format = [format stringByAppendingFormat:@" [%@:%d]", file, line];
    }
    NSLogv([@"(SQLiteKit)" stringByAppendingFormat:@" Warning: %@", format], arguments);
    va_end(arguments);
}

void __sqlitekit_error(NSString *file, NSUInteger line, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    if ( file != nil )
    {
        format = [format stringByAppendingFormat:@" [%@:%d]", file, line];
    }
    NSLogv([@"(SQLiteKit)" stringByAppendingFormat:@" Error: %@", format], arguments);
    va_end(arguments);
}
