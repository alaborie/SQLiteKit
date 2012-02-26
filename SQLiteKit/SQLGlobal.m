/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLGlobal.h"

void __sqlitekit_log(id object, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    NSLogv([@"[SQLiteKit]" stringByAppendingFormat:@" (%p) %@", object, format], arguments);
    va_end(arguments);
}

void __sqlitekit_warning(id object, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    NSLogv([@"[SQLiteKit]" stringByAppendingFormat:@" (%p) Warning: %@", object, format], arguments);
    va_end(arguments);
}

void __sqlitekit_error(id object, NSString *format, ...)
{
    NSCParameterAssert(format);
    va_list arguments;

    va_start(arguments, format);
    NSLogv([@"[SQLiteKit]" stringByAppendingFormat:@" (%p) Error: %@", object, format], arguments);
    va_end(arguments);
}
