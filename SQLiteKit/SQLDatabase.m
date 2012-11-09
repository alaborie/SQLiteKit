/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <dlfcn.h>
#import "SQLiteKitInternal.h"
#import "SQLStatement+Private.h"

/** \cond */
@interface SQLDatabase ()

@property (nonatomic, copy, readwrite) NSString *path;
@property (nonatomic, retain, readwrite) NSCache *statementsCache;

@end
/** \endcond */

@implementation SQLDatabase

#pragma mark -
#pragma mark Lifecycle

+ (id)database
{
    return [[self alloc] init];
}

+ (id)databaseWithURL:(NSURL *)url
{
    return [[self alloc] initWithURL:url];
}

+ (id)databaseWithPath:(NSString *)path
{
    return [[self alloc] initWithPath:path];
}

- (id)init
{
    return [self initWithPath:nil];
}

- (id)initWithURL:(NSURL *)url
{
    if (url.isFileURL == NO) {
        [NSException raise:NSInvalidArgumentException format:NSLocalizedString(@"SQLiteKit_InitWithNonFileURL", @"Exception raised when initializing a database with a non-file URL."), url];
    }
    return [self initWithPath:url.path];
}

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self != nil) {
        self.path = [path copy];
    }
    return self;
}

- (void)dealloc
{
    // This will release the handle and the cache.
    [self close];

    self.path = nil;
}

#pragma mark -
#pragma mark NSObject

+ (void)load {
    static const char *libName = "libsqlite3.dylib";
    void *libHandle = dlopen(libName, (RTLD_LAZY | RTLD_GLOBAL));

    if (libHandle == NULL) {
        [NSException raise:NSGenericException format:NSLocalizedString(@"SQLiteKit_LibraryFailedToOpen", @"Exception raised when the SQLite library failed to open."), libName];
    }

    /// \todo (alex) Add support of UTF-16.
    void *pointers[] = {
        /** Required */
        &__sqlite3_libversion_number, &__sqlite3_errmsg,
        &__sqlite3_open_v2, &__sqlite3_close,
        &__sqlite3_prepare_v2, &__sqlite3_bind_parameter_count, &__sqlite3_bind_blob, &__sqlite3_bind_int, &__sqlite3_bind_int64, &__sqlite3_bind_double, &__sqlite3_bind_null, &__sqlite3_bind_text, &__sqlite3_clear_bindings, &__sqlite3_reset, &__sqlite3_finalize,
        &__sqlite3_step,
        &__sqlite3_column_count, &__sqlite3_column_name, &__sqlite3_column_type, &__sqlite3_column_blob, &__sqlite3_column_bytes, &__sqlite3_column_int, &__sqlite3_column_int64, &__sqlite3_column_double, &__sqlite3_column_text
        /** Optional */
    };
    void *symbolNames[] = {
        /** Required */
        "sqlite3_libversion_number", "sqlite3_errmsg",
        "sqlite3_open_v2", "sqlite3_close",
        "sqlite3_prepare_v2", "sqlite3_bind_parameter_count", "sqlite3_bind_blob", "sqlite3_bind_int", "sqlite3_bind_int64", "sqlite3_bind_double", "sqlite3_bind_null", "sqlite3_bind_text", "sqlite3_clear_bindings", "sqlite3_reset", "sqlite3_finalize",
        "sqlite3_step",
        "sqlite3_column_count", "sqlite3_column_name", "sqlite3_column_type", "sqlite3_column_blob", "sqlite3_column_bytes", "sqlite3_column_int", "sqlite3_column_int64", "sqlite3_column_double", "sqlite3_column_text"
        /** Optional */
    };
    NSAssert(sizeof(pointers) / sizeof(void *) == sizeof(symbolNames) / sizeof(void *), @"The arrays 'pointers' and 'symbolNames' must have the same number of items.");
    NSUInteger numberOfItems = sizeof(symbolNames) / sizeof(void *);
    NSUInteger numberOfRequiredItems = numberOfItems; /// \note For now all functions are required.
    NSAssert(numberOfRequiredItems <= numberOfItems, @"The number of required items cannot be greater than the number of items.");

    for (NSUInteger index = 0; index < numberOfRequiredItems; index++) {
        void **symbol = pointers[index];

        *symbol = dlsym(libHandle, symbolNames[index]);
        if (*symbol== NULL) {
            /// \todo (alex) What about the functions available in a version and not in another one?
            [NSException raise:NSGenericException format:NSLocalizedString(@"SQLiteKit_RequiredSymbolNotFound", @"Exception raised when a required symbol has not been found."), symbolNames[index]];
        }
    }
    for (NSUInteger index = numberOfRequiredItems + 1; index < numberOfItems; index++) {
        pointers[index] = dlsym(libHandle, symbolNames[index]);
    }
}

#pragma mark -
#pragma mark NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)object
{
    NSAssert([object isKindOfClass:[SQLStatement class]] == YES, @"Invalid kind of class.");
    // Terminates the statement before it is removed from the cache.
    [(SQLStatement *)object terminate];
}

#pragma mark -
#pragma mark Public

- (void)open {
    [self openWithFlags:0];
}

- (void)openWithFlags:(NSInteger)flags
{
    // If the database is already open, we have nothing to do.
    if (_state.isOpen == 1) {
        return;
    }

    const char *filename = [self.path fileSystemRepresentation];

    // If no path is specified, we open the database in memory.
    if (filename == NULL) {
        filename = ":memory:";
    }
    // If no flags are specified, we use the default flags.
    if (flags == 0) {
        flags = (SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_COMPLETEUNTILFIRSTUSERAUTHENTICATION);
    }
    if (__sqlite3_open_v2(filename, &_handle, flags, NULL) != SQLITE_OK) {
        // If the open operation failed and the handle is NULL then the allocation operation failed.
        if (_handle == NULL) {
            [NSException raise:NSMallocException format:NSLocalizedString(@"SQLiteKit_MemoryAllocationFailed", @"Error returned when an operation failed because some memory could not be allocated.")];
        }
        else {
            // Closes explicitly the database even if the open operation has failed (see http://www.sqlite.org/c3ref/open.html). We don't use the close method, because the state is invalid.
            __sqlite3_close(_handle);
            _handle = NULL;
            [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
        }
    }
    _state.isOpen = 1;
    _state.isReadOnly = (flags & SQLITE_OPEN_READONLY) ? 1 : 0;
    self.statementsCache = [[NSCache alloc] init];
    self.statementsCache.delegate = self;
}

- (void)close
{
    if (_state.isOpen == 0) {
        return;
    }

    [self.statementsCache removeAllObjects];
    self.statementsCache.delegate = nil;
    self.statementsCache = nil;
    if (__sqlite3_close(_handle) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
    _handle = NULL;
}

#pragma mark -

- (SQLEnumerator *)executeSQL:(NSString *)sql {
    return [self executeSQL:sql arguments:nil];
}

- (SQLEnumerator *)executeSQLWithArguments:(NSString *)sql, ... {
    va_list argumentsList;

    va_start(argumentsList, sql);

    NSMutableArray *arguments = [NSMutableArray array];
    id argument = va_arg(argumentsList, id);

    while (argument != nil) {
        [arguments addObject:argument];
        argument = va_arg(argumentsList, id);
    }
    va_end(argumentsList);
    return [self executeSQL:sql arguments:((arguments.count > 0) ? arguments : nil)];
}

- (SQLEnumerator *)executeSQL:(NSString *)sql arguments:(NSArray *)arguments {
    /// \todo Check if the DB is open.
    NSParameterAssert(sql);
    SQLStatement *statement = [self.statementsCache objectForKey:sql];

    if (statement != nil) {
        [statement clearBindings];
    }
    else {
        statement = [SQLStatement statementWithSQL:sql database:_handle];
        [self.statementsCache setObject:statement forKey:sql];
    }
    [statement bindObjects:arguments];
    return [SQLEnumerator enumeratorForStatement:statement];
}

- (void)executeSQLFile:(NSString *)path {

}

@end
