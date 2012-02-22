//
//  SQLDatabaseTests.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/24/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLDatabaseTests.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"
#import "SQLRow.h"

@implementation SQLDatabaseTests

- (void)testLifeCycle
{
    SQLDatabase *database = [[SQLDatabase alloc] init];

    [database open];
    [database close];
    [database release];
}

- (void)testLifeCycleAdvanced
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"foo.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [[SQLDatabase alloc] initWithPath:databaseLocalPath];
    /// @todo Check the return values to make sure that the operations have succeed.

    STAssertTrue([database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX)], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS user (ID INTEGER PRIMARY KEY AUTOINCREMENT, full_name TEXT);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Steinbeck", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Dumas", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ernest Hemingway", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jack Kerouac", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Victor Hugo", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Boris Vian", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Romain Gary", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Hermann Hesse", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Paulo Coelho", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jean Jacques Rousseau", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Joseph Conrad", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Czeslaw Milosz", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Bernard Shaw", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Wallace Stevens", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Rumi", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"W.G. Sebald", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Hayden", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henry Miller", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Heinlein", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Lorine Niedecker", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Eliot", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"David Mamet", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Derek Walcott", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Isak Dinesen", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Maryse Conde", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Joyce Cary", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Frank O'Hara", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gabriel Garcia Marquez", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Carson McCullers", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Flann O'Brien", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Julio Cortazar", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Saul Bellow", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jonathan Swift", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ezra Pound", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Philip K. Dick", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Percy Shelley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Agee", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Stanley Elkin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Walter Benjamin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Harold Pinter", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Berryman", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Baldwin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Tu Fu", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jorge Luis Borges", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Malcolm Lowry", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Willa Cather", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Edgar Allan Poe", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henrik Ibsen", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"W.H. Auden", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Thomas Pynchon", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Emily Brontë/Charlotte Brontë", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Flannery O'Connor", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Leo Tolstoy", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Tennessee Williams", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Nathaniel Hawthorne", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"T.S. Eliot", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Sophocles", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Johann Wolfgang von Goethe", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Toni Morrison", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Olson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Eugene O'Neill", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gustave Flaubert", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ivan Turgenev", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Baudelaire", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Lowell", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Mark Twain", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Creeley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Iris Murdoch", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Arthur Rimbaud", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Mary Shelley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Virgil", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Emily Dickinson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Walt Whitman", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"D.H. Lawrence", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Carlos Williams", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Samuel Coleridge", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henry James", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Keats", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Wordsworth", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ovid", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Blake", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Dr. Johnson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Lord Byron", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Orwell", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Stendhal", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Euripides", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Miguel Cervantes", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Laurence Sterne", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Herman Melville", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Butler Yeats", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Homer", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Dickens", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Ashbery", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Virginia Woolf", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Geoffrey Chaucer", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Dante", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Fyodor Doestoyevsky", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Marcel Proust", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Anton Chekhov", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Vladimir Nabokov", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Samuel Beckett", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Milton", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gertrude Stein", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Joyce", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Shakespeare", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Franz Kafka", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Faulkner", nil]), @"Execute statement failed (database = %@).", database);

    SQLQuery *queryAllUsers = [SQLQuery queryWithStatement:@"SELECT * FROM user;"];

    STAssertTrue([database executeQuery:queryAllUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"%@", row);
    }], @"Execute query failed (database = %@, query = %@).", database, queryAllUsers);

    SQLQuery *queryCountUsers = [SQLQuery queryWithStatement:@"SELECT count(ID) AS `number of users` FROM user;"];

    STAssertTrue([database executeQuery:queryCountUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"%@", row);
    }], @"Execute query failed (database = %@, query = %@).", database, queryCountUsers);

    SQLQuery *queryBorisVian = [SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user WHERE full_name = ?;", @"Boris Vian", nil];

    STAssertTrue([database executeQuery:queryBorisVian thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryBorisVian);

    SQLQuery *queryLike = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE full_name LIKE 'J%';"];

    STAssertTrue([database executeQuery:queryLike thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);

    SQLQuery *queryNoResult = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE full_name = 'Alain Damasio';"];

    STAssertTrue([database executeQuery:queryNoResult thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSAssert(row == nil, @"This request should have return no result.");
        NSAssert(index == NSNotFound, @"This request should have return no result.");
        NSAssert(stop == NULL, @"This request should have return no result.");
    }], @"Execute query failed (database = %@, query = %@).", database, queryNoResult);

    SQLQuery *queryCached = [SQLQuery queryWithStatement:@"SELECT * FROM user where full_name LIKE ?;" arguments:[NSArray arrayWithObject:@"W%"]];

    STAssertTrue([database executeQuery:queryCached withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);
    queryCached.arguments = [NSArray arrayWithObject:@"S%"];
    STAssertTrue([database executeQuery:queryCached withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);

    [database printRuntimeStatusWithResetFlag:NO];
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
    [database release];
}

- (void)testExecuteFile
{
    NSError *error = nil;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie-db.sql"];
    NSString *databaseDump = @"\
    PRAGMA foreign_keys=OFF;\
    BEGIN TRANSACTION;\
    CREATE TABLE movies(ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, rating INTEGER);\
    INSERT INTO movies VALUES(1,'The Shawshank Redemption',9.2);\
    INSERT INTO movies VALUES(2,'The Godfather',9.2);\
    INSERT INTO movies VALUES(3,'The Godfather: Part II',9);\
    INSERT INTO movies VALUES(4,'The Good, the Bad and the Ugly',8.9);\
    INSERT INTO movies VALUES(5,'Pulp Fiction',8.9);\
    CREATE TABLE actors(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);\
    INSERT INTO actors VALUES(1,'Morgan Freeman');\
    INSERT INTO actors VALUES(2,'Tim Robbins');\
    INSERT INTO actors VALUES(3,'Marlon Brando');\
    INSERT INTO actors VALUES(4,'Al Pacino');\
    INSERT INTO actors VALUES(5,'Robert Duvall');\
    INSERT INTO actors VALUES(6,'Eli Wallach');\
    INSERT INTO actors VALUES(7,'Clint Eastwood');\
    INSERT INTO actors VALUES(8,'John Travolta');\
    INSERT INTO actors VALUES(9,'Samuel L. Jackson');\
    CREATE TABLE act(movie_ID INTEGER, actor_ID INTEGER);\
    INSERT INTO act VALUES(1,1);\
    INSERT INTO act VALUES(1,2);\
    INSERT INTO act VALUES(2,3);\
    INSERT INTO act VALUES(2,4);\
    INSERT INTO act VALUES(3,4);\
    INSERT INTO act VALUES(3,5);\
    INSERT INTO act VALUES(4,6);\
    INSERT INTO act VALUES(4,7);\
    INSERT INTO act VALUES(5,8);\
    INSERT INTO act VALUES(5,9);\
    DELETE FROM sqlite_sequence;\
    INSERT INTO sqlite_sequence VALUES('movies',5);\
    INSERT INTO sqlite_sequence VALUES('actors',9);\
    COMMIT;";

    [databaseDump writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:&error];
    STAssertNil(error, [error localizedDescription]);

    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *movieDatabase = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([movieDatabase open], @"Open operation failed (database = %@).", movieDatabase);
    STAssertTrue([movieDatabase executeSQLFileAtPath:filePath], @"Execute SQL file failed (database = %@, filePath = %@).", movieDatabase, filePath);
    STAssertTrue([movieDatabase close], @"Close operation failed (database = %@).", movieDatabase);
}

- (void)testObservation
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"observation.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithURL:[NSURL URLWithString:databaseLocalPath]];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    id notificationObserver = nil;
    __block NSInteger notificationCount = 0;
    NSInteger notificationExpectedCount = 9;

    [database beginGeneratingUpdateNotificationsIntoCenter:defaultCenter];
    notificationObserver = [defaultCenter addObserverForName:@"main.country#insert" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received an insertion notification (notification = %@)", note);
        notificationCount++;
    }];
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS country(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, area INTEGER);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Russia", [NSNumber numberWithInteger:17098242], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Canada", [NSNumber numberWithInteger:9984670], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"China", [NSNumber numberWithInteger:9596961], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"United States", [NSNumber numberWithInteger:9522055], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Brazil", [NSNumber numberWithInteger:851487], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Australia", [NSNumber numberWithInteger:7692024], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"India", [NSNumber numberWithInteger:3166414], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Argentina", [NSNumber numberWithInteger:2780400], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Kazakhstan", [NSNumber numberWithInteger:2724900], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(notificationCount == notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:@"main.country#insert" object:nil queue:nil usingBlock:^(NSNotification *note) {
        STAssertTrue(false, @"This method should not been called, the observer has been removed!");
    }];
    [defaultCenter removeObserver:notificationObserver];
    STAssertTrue(([database executeWithStatementAndArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Algeria", [NSNumber numberWithInteger:2381741], nil]), @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:@"main.country#delete" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received a deletion notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 3;
    STAssertTrue([database executeStatement:@"DELETE FROM country WHERE name LIKE 'A%';"], @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:@"main.country#update" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received an update notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 1;
    STAssertTrue([database executeStatement:@"UPDATE country SET area = 8514877 where name = 'Brazil';"], @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:notificationObserver];
    [database close];
}

@end
