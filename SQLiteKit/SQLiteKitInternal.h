/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

////////////////////////////////////////////////////////////////////////////////
/// \name Required function pointers

int (*__sqlite3_libversion_number)(void);
const char *(*__sqlite3_errmsg)(sqlite3 *);

int (*__sqlite3_open_v2)(const char *, sqlite3 **, int, const char *);
int (*__sqlite3_close)(sqlite3 *);

int (*__sqlite3_prepare_v2)(sqlite3 *, const char *, int, sqlite3_stmt **, const char **);
int (*__sqlite3_bind_parameter_count)(sqlite3_stmt *);
int (*__sqlite3_bind_blob)(sqlite3_stmt *, int, const void *, int, void (*)(void *));
int (*__sqlite3_bind_int)(sqlite3_stmt *, int, int);
int (*__sqlite3_bind_int64)(sqlite3_stmt *, int, sqlite3_int64);
int (*__sqlite3_bind_double)(sqlite3_stmt *, int, double);
int (*__sqlite3_bind_null)(sqlite3_stmt *, int);
int (*__sqlite3_bind_text)(sqlite3_stmt *, int, const char *, int, void (*)(void *));
int (*__sqlite3_clear_bindings)(sqlite3_stmt *);
int (*__sqlite3_reset)(sqlite3_stmt *);
int (*__sqlite3_finalize)(sqlite3_stmt *);

int (*__sqlite3_step)(sqlite3_stmt *);

int (*__sqlite3_column_count)(sqlite3_stmt *);
const char *(*__sqlite3_column_name)(sqlite3_stmt *, int);
int (*__sqlite3_column_type)(sqlite3_stmt *, int);
const void *(*__sqlite3_column_blob)(sqlite3_stmt *, int);
int (*__sqlite3_column_bytes)(sqlite3_stmt *, int);
int (*__sqlite3_column_int)(sqlite3_stmt *, int);
sqlite3_int64 (*__sqlite3_column_int64)(sqlite3_stmt *, int);
double (*__sqlite3_column_double)(sqlite3_stmt *, int);
const unsigned char *(*__sqlite3_column_text)(sqlite3_stmt *, int);

////////////////////////////////////////////////////////////////////////////////
/// \name Optional function pointers


////////////////////////////////////////////////////////////////////////////////
/// \name String Encoding

extern NSStringEncoding SQLiteKitStringEncoding;

////////////////////////////////////////////////////////////////////////////////
/// \name Convenient log defines

#define SQLITEKIT_LOG(format, ...) \
    NSLog([NSString stringWithFormat:@"%@ (%@:%u)", format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__], ##__VA_ARGS__)

#define SQLITEKIT_WARNING(format, ...) \
    NSLog([NSString stringWithFormat:@"Warning: %@ (%@:%u)", format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__], ##__VA_ARGS__)

#define SQLITEKIT_ERROR(error) \
    NSLog(@"Error: %@ (%@:%u)", error, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)
