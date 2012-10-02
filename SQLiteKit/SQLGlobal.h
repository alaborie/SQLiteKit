/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/NSString.h>
#import <Foundation/NSError.h>
#import <Foundation/NSException.h>

/**
 A string that contains the name of the error domain for all the errors related to SQLiteKit.
 */
extern NSString * const kSQLiteKitErrorDomain;

/**
 A string that contains the name of the environment variable used to enable the debug mode.
 */
extern NSString * const kSQLiteKitDebugEnvironmentKey;

void __sqlitekit_log(NSString *file, NSUInteger line, NSString *format, ...) __attribute__ ((format(__NSString__, 3, 4)));
void __sqlitekit_warning(NSString *file, NSUInteger line, NSString *format, ...) __attribute__ ((format(__NSString__, 3, 4)));
void __sqlitekit_error(NSString *file, NSUInteger line, NSString *format, ...) __attribute__ ((format(__NSString__, 3, 4)));
void __sqlitekit_nop(NSString *file, NSUInteger line, NSString *format, ...); // __attribute__ ((naked));

void (*__p_sqlitekit_log)(NSString *, NSUInteger, NSString *, ...);
void (*__p_sqlitekit_warning)(NSString *, NSUInteger, NSString *, ...);
void (*__p_sqlitekit_error)(NSString *, NSUInteger, NSString *, ...);

#define SQLITEKIT_VERBOSE false
#if SQLITEKIT_VERBOSE
# define sqlitekit_verbose(format, ...)     __p_sqlitekit_log([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)
# define sqlitekit_cverbose(format, ...)    __p_sqlitekit_log([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)
#else
# define sqlitekit_verbose(format, ...)
# define sqlitekit_cverbose(format, ...)
#endif

#define sqlitekit_log(format, ...)          __p_sqlitekit_log([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)
#define sqlitekit_clog(format, ...)         __p_sqlitekit_log([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)

#define sqlitekit_warning(format, ...)      __p_sqlitekit_warning([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)
#define sqlitekit_cwarning(format, ...)     __p_sqlitekit_warning([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)

#define sqlitekit_error(format, ...)        __p_sqlitekit_error([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)
#define sqlitekit_cerror(format, ...)       __p_sqlitekit_error([[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, format, ##__VA_ARGS__)

#define sqlitekit_create_error(error, errorDomain, errorCode, errorDescription)\
    if ( error != nil )\
    {\
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey];\
\
        *error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];\
    }

#define sqlitekit_create_error_cstring(error, errorDomain, errorCode, errorDescription)\
    if ( error != nil )\
    {\
        NSString *description = [NSString stringWithCString:errorDescription encoding:NSASCIIStringEncoding];\
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];\
\
        *error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];\
    }
