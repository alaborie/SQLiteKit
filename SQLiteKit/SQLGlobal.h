/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/NSString.h>
#import <Foundation/NSError.h>

extern NSString * const kSQLiteKitErrorDomain;

void __sqlitekit_log(id object, NSString *format, ...);
void __sqlitekit_warning(id object, NSString *format, ...);
void __sqlitekit_error(id object, NSString *format, ...);

#ifdef SQLITEKIT_VERBOSE
# define sqlitekit_verbose(format, ...)  __sqlitekit_log(self, format, ##__VA_ARGS__)
# define sqlitekit_cverbose(object, format, ...)  __sqlitekit_log(object, format, ##__VA_ARGS__)
#else
# define sqlitekit_verbose(format, ...)
# define sqlitekit_cverbose(object, format, ...)
#endif
#define sqlitekit_log(format, ...)      __sqlitekit_log(self, format, ##__VA_ARGS__)
#define sqlitekit_clog(object, format, ...)      __sqlitekit_log(object, format, ##__VA_ARGS__)
#define sqlitekit_warning(format, ...)  __sqlitekit_warning(self, format, ##__VA_ARGS__)
#define sqlitekit_cwarning(object, format, ...)  __sqlitekit_warning(object, format, ##__VA_ARGS__)
#define sqlitekit_error(format, ...)    __sqlitekit_error(self, format, ##__VA_ARGS__)
#define sqlitekit_cerror(object, format, ...)    __sqlitekit_error(object, format, ##__VA_ARGS__)

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
