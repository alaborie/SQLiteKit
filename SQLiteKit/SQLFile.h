/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <stdio.h>

#define BUFFER_DEFAULT_STREAM_SIZE 256
#define BUFFER_DEFAULT_LINE_SIZE 256
#define BUFFER_DEFAULT_REALLOC_PADDING 128

#define OBJECT_BUFFER_DEFAULT_SIZE 16

struct buffer
{
    char *data;
    size_t size;
    size_t length;
};
typedef struct buffer *buffer_t;

/**
 @brief An object that represent a file containing SQL statements.
 @todo The implementation of the parser is ugly. Should be redone later.
 */
@interface SQLFile : NSObject <NSFastEnumeration>
{
@private
    NSString *_path;
    FILE *_stream;
    buffer_t _streamBuffer;
    buffer_t _lineBuffer;
    NSUInteger _streamBufferStartingIndex;
}

/**
 A string that contains the path of the receiver.
 */
@property (nonatomic, readonly) NSString *path;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new file located at the specified URL.

 @param fileURL The URL to located the file. This must be a file URL. Must not be nil!
 @return A new file or nil if an error occurs during its allocation or initialization.
 */
+ (id)fileWithFileURL:(NSURL *)fileURL __attribute__ ((nonnull(1)));

/**
 Creates a new file located at the specified path.

 @param path The path to locate the file. Must not be nil!
 @return A new file or nil if an error occurs during its allocation or initialization.
 */
+ (id)fileWithFilePath:(NSString *)filePath __attribute__ ((nonnull(1)));

/**
 Initializes a file located at the specified URL.

 @param fileURL The URL to located the file. This must be a file URL. Must not be nil!
 @return A new file or nil if an error occurs.
 */
- (id)initWithFileURL:(NSURL *)fileURL __attribute__ ((nonnull(1)));

/**
 Initializes a file located at the specified path.

 @param path The path to locate the file. Must not be nil!
 @return A new file or nil if an error occurs.
 @note Designated initializer.
 */
- (id)initWithFilePath:(NSString *)filePath __attribute__ ((nonnull(1)));

#pragma mark -
/// @name Enumeration

/**
 Enumerates all the requests contains in the receiver.

 @param block A block that will be called for each request. The parameters are:
    - request A string that contains the request.
    - index An integer that indicates the index of the request in the file.
    - stop A pointer to a BOOL that if set to YES will stop further processing of the result.
 */
- (void)enumerateRequestsUsingBlock:(void (^)(NSString *request, NSUInteger index, BOOL *stop))block __attribute__ ((nonnull(1)));

@end
