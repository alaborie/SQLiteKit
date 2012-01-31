//
//  SQLGlobal.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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
