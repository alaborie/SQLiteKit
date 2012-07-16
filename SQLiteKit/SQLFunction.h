/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 @brief An object that represents a SQL function.
 */
@interface SQLFunction : NSObject
{
@private
    NSUInteger _numberOfArguments;
    id _context;

@private
    id (^_block)(SQLFunction *function, NSArray *arguments, id context);
    void (^_operation)(SQLFunction *function, NSArray *arguments, id context);
    id (^_complete)(SQLFunction *function, id context);
}

/**
 An integer that indicates the number of arguments required by the function.
 */
@property (nonatomic, readonly) NSUInteger numberOfArguments;

/**
 An optional object that is provided to the function when it is invoked.
 */
@property (nonatomic, retain, readwrite) id context;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new function that uses the specified block and that requires the indicated number of arguments.

 @param numberOfArguments An integer that indicates the number of arguments required by the function.
 @param block A block that contains the code of the function. Must not be nil! The block takes three arguments:
    - function The function object.
    - arguments An array that contains all the arguments of the function.
    - content An optional object.
 @return A new function or nil if an error occurs during its allocation or initialization.
 */
+ (id)functionWithNumberOfArguments:(NSUInteger)numberOfArguments block:(id (^)(SQLFunction *function, NSArray *arguments, id context))block __attribute__ ((nonnull(2)));

/**
 Initializes a new function that uses the specified block and that requires the indicated number of arguments.

 @param numberOfArguments An integer that indicates the number of arguments required by the function.
 @param block A block that contains the code of the function. Must not be nil! The block takes three arguments:
 - function The function object.
 - arguments An array that contains all the arguments of the function.
 - content An optional object.
 @return An initialized function or nil if an error occurs.
 */
- (id)initWithNumberOfArguments:(NSUInteger)numberOfArguments block:(id (^)(SQLFunction *function, NSArray *arguments, id context))block __attribute__ ((nonnull(2)));

@end
