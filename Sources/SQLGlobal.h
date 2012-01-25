//
//  SQLGlobal.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

void __sqlitekit_log(id object, NSString *format, ...);
void __sqlitekit_warning(id object, NSString *format, ...);
void __sqlitekit_error(id object, NSString *format, ...);

#define sqlitekit_verbose(format, ...)  __sqlitekit_log(self, format, ##__VA_ARGS__)
#define sqlitekit_log(format, ...)      __sqlitekit_log(self, format, ##__VA_ARGS__)
#define sqlitekit_warning(format, ...)  __sqlitekit_warning(self, format, ##__VA_ARGS__)
#define sqlitekit_error(format, ...)    __sqlitekit_error(self, format, ##__VA_ARGS__)

