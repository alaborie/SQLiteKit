PRAGMA foreign_keys=OFF;

------------
-- MOVIES --
------------

-- TABLE movies
-- This table contains a lit of movies.
CREATE TABLE movies(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    rating INTEGER);

-- Insert some movies.
INSERT INTO "movies" VALUES(1,'The Shawshank Redemption',9.2);
INSERT INTO "movies" VALUES(2,'The Godfather',9.2);
INSERT INTO "movies" VALUES(3,'The Godfather: Part II',9);
INSERT INTO "movies" VALUES(4,'The Good, the Bad and the Ugly',8.9);
INSERT INTO "movies" VALUES(5,'Pulp Fiction',8.9);

------------
-- ACTORS --
------------

-- TABLE actors
-- This table contains a lit of actors.
CREATE TABLE actors(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT);

-- Insert some actors.
INSERT INTO "actors" VALUES(1,'Morgan Freeman');
INSERT INTO "actors" VALUES(2,'Tim Robbins');
INSERT INTO "actors" VALUES(3,'Marlon Brando');
INSERT INTO "actors" VALUES(4,'Al Pacino');
INSERT INTO "actors" VALUES(5,'Robert Duvall');
INSERT INTO "actors" VALUES(6,'Eli Wallach');
INSERT INTO "actors" VALUES(7,'Clint Eastwood');
INSERT INTO "actors" VALUES(8,'John Travolta');
INSERT INTO "actors" VALUES(9,'Samuel L. Jackson');

---------
-- ACT --
---------

-- TABLE act
-- This table makes the link between the actors and the movies.
CREATE TABLE act(movie_id INTEGER, actor_id INTEGER);
INSERT INTO "act" VALUES(1,1);
INSERT INTO "act" VALUES(1,2);
INSERT INTO "act" VALUES(2,3);
INSERT INTO "act" VALUES(2,4);
INSERT INTO "act" VALUES(3,4);
INSERT INTO "act" VALUES(3,5);
INSERT INTO "act" VALUES(4,6);
INSERT INTO "act" VALUES(4,7);
INSERT INTO "act" VALUES(5,8);
INSERT INTO "act" VALUES(5,9);
