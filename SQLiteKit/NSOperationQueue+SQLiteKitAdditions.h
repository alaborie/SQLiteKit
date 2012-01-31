//
//  SQLGlobal.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface NSOperationQueue (SQLiteKitAdditions)

/**
 Returns the operation queue that should be used to perform all operations related to the SQLite database.

 @return An operation queue that manages the SQLite database.
 @note If you have more than one database in your application, it's a good practice to use one queue per database.
 */
+ (id)databaseQueue;

@end
