/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <string.h>

#import "SQLFile.h"

buffer_t buffer_malloc(size_t size);
void buffer_free(buffer_t buffer);
const char buffer_append_char(buffer_t buffer, const char character);
const char *buffer_append_string(buffer_t buffer, const char *string, size_t stringLength);
char buffer_char_at_index(buffer_t buffer, unsigned int index);
char *buffer_to_string(buffer_t buffer);

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

buffer_t buffer_malloc(size_t dataSize)
{
    buffer_t newBuffer = malloc(sizeof(*newBuffer));

    if ( newBuffer == NULL )
    {
        perror("[SQLiteKit] (Parser) Error");
    }
    else
    {
        bzero(newBuffer, sizeof(*newBuffer));
        newBuffer->data = malloc(sizeof(*(newBuffer->data)) * dataSize);
        if ( newBuffer->data == NULL )
        {
            perror("[SQLiteKit] (Parser) Error");
            free(newBuffer);
            newBuffer = NULL;
        }
        else
        {
            newBuffer->size = dataSize;
        }
    }
    return newBuffer;
}

void buffer_free(buffer_t buffer)
{
    if ( buffer != NULL )
    {
        free(buffer->data);
        free(buffer);
    }
}

const char *buffer_append_string(buffer_t buffer, const char *string, size_t stringLength)
{
    if ( stringLength > 0 )
    {
        if ( stringLength > buffer->size - buffer->length )
        {
            buffer->data = realloc(buffer->data, sizeof(*(buffer->data)) * (buffer->size + stringLength + BUFFER_DEFAULT_REALLOC_PADDING));
            if ( buffer->data == NULL )
            {
                perror("[SQLiteKit] (Parser) Error");
                return NULL;
            }
            buffer->size += stringLength + BUFFER_DEFAULT_REALLOC_PADDING;
        }
        memcpy(&(buffer->data[buffer->length]), string, stringLength);
        buffer->length += stringLength;
    }
    return string;
}

const char buffer_append_char(buffer_t buffer, const char character)
{
    if ( 1 > buffer->size - buffer->length )
    {
        buffer->data = realloc(buffer->data, sizeof(*(buffer->data)) * (buffer->size + 1 + BUFFER_DEFAULT_REALLOC_PADDING));
        if ( buffer->data == NULL )
        {
            perror("[SQLiteKit] (Parser) Error");
            return -1;
        }
        buffer->size += 1 + BUFFER_DEFAULT_REALLOC_PADDING;
    }
    buffer->data[buffer->length] = character;
    buffer->length++;
    return character;
}

char buffer_char_at_index(buffer_t buffer, unsigned int index)
{
    NSCAssert(index < buffer->length, @"Index out of range (length = %lu).", buffer->length);
    return buffer->data[index];
}

char *buffer_to_string(buffer_t buffer)
{
    if ( buffer->length > 0 )
    {
        char *copyString = malloc(sizeof(*copyString) * (buffer->length + 1));

        strncpy(copyString, buffer->data, buffer->length);
        copyString[buffer->length] = '\0';
        return copyString;
    }
    return NULL;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

bool parser_is_separator_char(char c);
bool parser_read_next_chunk(FILE *stream, buffer_t streamBuffer);
unsigned int parser_get_next_request(FILE *stream, buffer_t streamBuffer, buffer_t lineBuffer, unsigned int startingIndex);

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

bool parser_is_separator_char(char c)
{
    return c == ' ' || c == '\t' || c == '\n';
}

bool parser_read_next_chunk(FILE *stream, buffer_t streamBuffer)
{
    streamBuffer->length = fread(streamBuffer->data, sizeof(*(streamBuffer->data)), streamBuffer->size, stream);
    if ( streamBuffer->length == 0 )
    {
        return false;
    }
    return true;
}

unsigned int parser_get_next_request(FILE *stream, buffer_t streamBuffer, buffer_t lineBuffer, unsigned int startingIndex)
{
    NSCParameterAssert(stream);
    NSCParameterAssert(streamBuffer);
    NSCParameterAssert(lineBuffer);

    unsigned int index = startingIndex;
    unsigned int semicolonExpected = 1;

    char currentChar = 0;
    char previousChar = 0;

    char inhibitor = 0;
    bool shouldInhibitNextChar = false;
    bool shouldCopy = true;
    bool hasValidBeginPrefix = false;
    bool shouldCheckForBeginPrefix = false;

    while ( true )
    {
        // Head, primary checks before processing.
        previousChar = currentChar;
        // Can we read another char?
        if ( index >= streamBuffer->length )
        {
            if ( parser_read_next_chunk(stream, streamBuffer) == false )
            {
                return 0;
            }
            index = 0;
        }
        if ( shouldInhibitNextChar == true )
        {
            index++;
            continue;
        }
        currentChar = buffer_char_at_index(streamBuffer, index);

        switch ( currentChar )
        {
            case '*':
            {
                if ( inhibitor == 0 && previousChar == '/' )
                {
                    lineBuffer->length--;
                    inhibitor = currentChar;
                    shouldCopy = false;
                }
                break;
            }
            case '/':
            {
                if ( inhibitor == '*' && previousChar == '*' )
                {
                    inhibitor = 0;
                    shouldCopy = true;
                    index++;
                    continue;
                }
                break;
            }
            case '-':
            {
                if ( inhibitor == 0 && previousChar == '-' )
                {
                    lineBuffer->length--;
                    inhibitor = '\n';
                    shouldCopy = false;
                }
                break;
            }
            case '\n':
            {
                if ( inhibitor == currentChar )
                {
                    inhibitor = 0;
                    shouldCopy = true;
                }
            }
            case '\t':
            case '\r':
            {
                if ( hasValidBeginPrefix == true )
                {
                    semicolonExpected = 2;
                }
                index++;
                continue;
            }
            case ' ':
            {
                if ( hasValidBeginPrefix == true )
                {
                    semicolonExpected = 2;
                }
                if ( lineBuffer->length == 0 || lineBuffer->data[lineBuffer->length - 1] == ' ' )
                {
                    index++;
                    continue;
                }
                break;
            }
            case '"':
            case '\'':
            {
                if ( inhibitor == 0 )
                {
                    inhibitor = currentChar;
                }
                else if ( inhibitor == currentChar )
                {
                    inhibitor = 0;
                }
                break;
            }
            case '\\':
            {
                shouldInhibitNextChar = true;
                break;
            }
            case ';':
            {
                if ( inhibitor == 0 )
                {
                    semicolonExpected--;
                    if ( semicolonExpected == 0 )
                    {
                        if ( lineBuffer->length > 0 && lineBuffer->data[lineBuffer->length - 1] == ' ' )
                        {
                            lineBuffer->length--;
                        }
                    }
                }
                break;
            }
            case 'n':
            case 'N':
            {
                shouldCheckForBeginPrefix = true;
                break;
            }
        }

        // Tail, final treatment.
        if ( shouldCopy == true )
        {
            buffer_append_char(lineBuffer, currentChar);
        }
        hasValidBeginPrefix = false;
        if ( shouldCheckForBeginPrefix == true )
        {
            shouldCheckForBeginPrefix = false;
            if ( inhibitor == 0 && lineBuffer->length > 5 )
            {
                BOOL hasWordPrefix = ( strncasecmp(&lineBuffer->data[lineBuffer->length - 5], "begin", 5) == 0 );
                BOOL hasSeparatorBeforePrefix = parser_is_separator_char(lineBuffer->data[lineBuffer->length - 6]);

                hasValidBeginPrefix = hasWordPrefix && hasSeparatorBeforePrefix;
            }
        }
        if ( semicolonExpected == 0 )
        {
            break;
        }
        index++;
    }
    return ++index;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@interface SQLFile ()

@property (nonatomic, readonly) FILE *stream;
@property (nonatomic, readonly) buffer_t streamBuffer;
@property (nonatomic, readonly) buffer_t lineBuffer;
@property (nonatomic, assign, readwrite) NSUInteger streamBufferStartingIndex;

@end

@implementation SQLFile

@synthesize path = _path;
@synthesize stream = _stream;
@synthesize streamBuffer = _streamBuffer;
@synthesize lineBuffer = _lineBuffer;
@synthesize streamBufferStartingIndex = _streamBufferStartingIndex;

#pragma mark -
#pragma mark Lifecycle

+ (id)fileWithFileURL:(NSURL *)fileURL
{
    return [[[self alloc] initWithFileURL:fileURL] autorelease];
}

+ (id)fileWithFilePath:(NSString *)filePath
{
    return [[[self alloc] initWithFilePath:filePath] autorelease];
}

- (id)initWithFileURL:(NSURL *)fileURL
{
    if ( fileURL.isFileURL == NO )
    {
        return nil;
    }
    return [self initWithFilePath:fileURL.path];
}

- (id)initWithFilePath:(NSString *)filePath
{
    NSParameterAssert(filePath);

    self = [super init];
    if ( self != nil )
    {
        _path = [filePath retain];
    }
    return self;
}

- (void)dealloc
{
    if ( self.stream != NULL )
    {
        if ( fclose(self.stream) != 0 )
        {
            perror("[SQLiteKit] (Parser) Error");
        }
    }

    [_path release];
    buffer_free(_streamBuffer);
    buffer_free(_lineBuffer);
    [super dealloc];
}

#pragma mark -
#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])objectsBuffer count:(NSUInteger)length
{
    // If it's the beginning of the iteration.
    if ( state->state == 0 )
    {
        NSAssert(self.stream == NULL, @"The stream should be equal to NULL.");
        _stream = fopen(self.path.UTF8String, "r");
        if ( _stream == NULL )
        {
            perror("[SQLiteKit] (Parser) Error");
            return 0;
        }
        if ( _streamBuffer == NULL )
        {
            _streamBuffer = buffer_malloc(BUFFER_DEFAULT_STREAM_SIZE);
            if ( _streamBuffer == NULL )
            {
                return 0;
            }
        }
        if ( _lineBuffer == NULL )
        {
            _lineBuffer = buffer_malloc(BUFFER_DEFAULT_LINE_SIZE);
            if ( _lineBuffer == NULL )
            {
                return 0;
            }
        }
        // We are not tracking mutation but we have to set the mutation pointer to a valid address.
        state->mutationsPtr = &state->extra[0];
    }
    if ( self.stream == NULL )
    {
        return 0;
    }

    NSUInteger numberOfNewObject = 0;

    // Sets the items pointer to the given C array.
    state->itemsPtr = objectsBuffer;
    while ( (self.streamBuffer->length > 0 || feof(self.stream) == 0) && numberOfNewObject < length )
    {
        self.streamBufferStartingIndex = parser_get_next_request(self.stream, self.streamBuffer, self.lineBuffer, self.streamBufferStartingIndex);
        if ( self.lineBuffer->length  > 0 )
        {
            objectsBuffer[numberOfNewObject] = [[[NSString alloc] initWithBytes:self.lineBuffer->data length:self.lineBuffer->length encoding:NSUTF8StringEncoding] autorelease];
            self.lineBuffer->length = 0;
            state->state++;
            numberOfNewObject++;
        }
    }
    if ( feof(self.stream) != 0 )
    {
        if ( fclose(self.stream) != 0 )
        {
            perror("[SQLiteKit] (Parser) Error");
        }
        _stream = NULL;
        self.streamBuffer->length = 0;
    }
    return numberOfNewObject;
}

#pragma mark -
#pragma mark Public

- (void)enumerateRequestsUsingBlock:(void (^)(NSString *request, NSUInteger index, BOOL *stop))block
{
    NSParameterAssert(block);

    NSFastEnumerationState state = { 0 };
    id objectBuffer[OBJECT_BUFFER_DEFAULT_SIZE];
    BOOL stop = NO;
    NSUInteger numberOfItems = [self countByEnumeratingWithState:&state objects:objectBuffer count:OBJECT_BUFFER_DEFAULT_SIZE];

    while (numberOfItems != 0)
    {
        for ( NSUInteger index = 0; index < numberOfItems; index++ )
        {
            block(state.itemsPtr[index], index, &stop);
            if ( stop == YES )
            {
                return;
            }
        }
        numberOfItems = [self countByEnumeratingWithState:&state objects:objectBuffer count:OBJECT_BUFFER_DEFAULT_SIZE];
    }
}

@end
