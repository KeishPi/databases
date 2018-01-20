
DROP TABLE IF EXISTS `is_in`;
DROP TABLE IF EXISTS `belong`;
DROP TABLE IF EXISTS `movies`;
DROP TABLE IF EXISTS `genres`;
DROP TABLE IF EXISTS `actors`;
DROP TABLE IF EXISTS `directors`;

-- Create a table called directors with the following properties:
-- dir_id - an auto incrementing integer which is the primary key
-- dir_fname - a varchar of maximum length 255, cannot be null
-- dir_lname - a varchar of maximum length 255, cannot be null
-- dir_gender - a varchar of maximum length 255, cannot be null
-- dir_dob - a date type

CREATE TABLE directors (
	dir_id INT(11) NOT NULL AUTO_INCREMENT,
	dir_fname VARCHAR(225) NOT NULL,
	dir_lname VARCHAR(225) NOT NULL,	
	dir_gender VARCHAR(225) NOT NULL,
	dir_dob DATE,
	PRIMARY KEY(dir_id)
)ENGINE=InnoDB;

-- Create a table called movies with the following properties:
-- movie_id - an auto incrementing integer which is the primary key
-- title - a varchar with a maximum length of 255 characters, cannot be null
-- release_year - an integer representing the release year of the movie (out of 5 stars), cannot be null
-- description - a date type 
-- rating - an integer, cannot be null
-- fk_dir_id - an integer which is a foreign key reference to the directors table
-- the combination of the title and year must be unique in this table???

CREATE TABLE movies (
	movie_id INT(11) NOT NULL AUTO_INCREMENT,
	title VARCHAR(225) NOT NULL,
	release_year INT(11) NOT NULL,
	description TEXT,
	rating INT(11) NOT NULL,
	fk_dir_id INT(11),
	PRIMARY KEY(movie_id),
	FOREIGN KEY(fk_dir_id) REFERENCES directors(dir_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	UNIQUE KEY(title, release_year)
) ENGINE=InnoDB;

-- Create a table called actors with the following properties:
-- actor_id - an auto incrementing integer which is the primary key
-- actor_fname - a varchar of maximum length 255, cannot be null
-- actor_lname - a varchar of maximum length 255, cannot be null
-- actor_gender - a varchar of maximum length 255, cannot be null
-- actor_dob - a date type

CREATE TABLE actors (
	actor_id INT(11) NOT NULL AUTO_INCREMENT,
	actor_fname VARCHAR(225) NOT NULL,
	actor_lname VARCHAR(225) NOT NULL,	
	actor_gender VARCHAR(225) NOT NULL,
	actor_dob DATE,
	PRIMARY KEY(actor_id)
) ENGINE=InnoDB;

-- Create a table called genres with the following properties:
-- genre_id- an auto incrementing integer which is the primary key
-- genre_type - a varchar of maximum length 255, cannot be null

CREATE TABLE genres (
	genre_type VARCHAR(225) NOT NULL,
	PRIMARY KEY(genre_type),
	UNIQUE KEY(genre_type)
) ENGINE=InnoDB;

-- Create a table called is_in with the following properties, this is a table representing a many-to-many relationship
-- between movies and actors:
-- mid - an integer which is a foreign key reference to movies
-- aid - an integer which is a foreign key reference to actors
-- char_name - a varchar of maximum length 255, cannot be null
-- The primary key is a combination of mid, aid, and char_name

CREATE TABLE is_in (
	mid INT(11) NOT NULL,
	aid INT(11) NOT NULL,
	char_name VARCHAR(225) NOT NULL,
	PRIMARY KEY(mid, aid, char_name),
	FOREIGN KEY(mid) REFERENCES movies(movie_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FOREIGN KEY(aid) REFERENCES actors(actor_id)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
) ENGINE=InnoDB;

-- Create a table called belong with the following properties, this is a table representing a many-to-many relationship
-- between movies and genres:
-- b_mid - an integer which is a foreign key reference to movies
-- gid - an integer which is a foreign key reference to genres
-- The primary key is a combination of b_mid and gid

CREATE TABLE belong (
	b_mid INT(11) NOT NULL,
	gid VARCHAR(225) NOT NULL,	
	PRIMARY KEY(b_mid, gid),
	FOREIGN KEY(b_mid) REFERENCES movies(movie_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FOREIGN KEY(gid) REFERENCES genres(genre_type)
	ON UPDATE CASCADE
	ON DELETE NO ACTION
) ENGINE=InnoDB;


-- insert the following into the directors table:

-- dir_fname: Chris
-- dir_lname: Columbus
-- dir_gender: Male
-- dir_dob: 9/10/1958
INSERT INTO directors(dir_fname, dir_lname, dir_gender, dir_dob) VALUES
	("Chris", "Columbus", "Male", "1958-09-10");

-- dir_fname: Spike
-- dir_lname: Jonze
-- dir_gender: Male
-- dir_dob: 10/22/1969
INSERT INTO directors(dir_fname, dir_lname, dir_gender, dir_dob) VALUES
	("Spike", "Jonze", "Male", "1969-10-22");
	
-- dir_fname: Gore
-- dir_lname: Verbinski
-- dir_gender: Male
-- dir_dob: 3/16/1964
INSERT INTO directors(dir_fname, dir_lname, dir_gender, dir_dob) VALUES
	("Gore", "Verbinski", "Male", "1964-03-16");
	
-- dir_fname: Sofia
-- dir_lname: Coppola
-- dir_gender: Female
-- dir_dob: 5/14/1971
INSERT INTO directors(dir_fname, dir_lname, dir_gender, dir_dob) VALUES
	("Sofia", "Coppola", "Female", "1971-05-14");
	
-- dir_fname: Martin
-- dir_lname: Campbell
-- dir_gender: Female
-- dir_dob: 5/14/1971
INSERT INTO directors(dir_fname, dir_lname, dir_gender, dir_dob) VALUES
	("Martin", "Campbell", "Male", "1943-10-24");
	
-- insert the following into the movies table:

-- title: Harry Potter and the Sorcerer's Stone
-- release_year: 2001
-- description: Adaptation of the first of J.K. Rowlings popular children's novels about Harry Potter
-- rating: 4
-- fk_dir_id - reference to dir_fname: Chris, dir_lname: Columbus
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("Harry Potter and the Sorcerer's Stone", 2001, 
	"Adaptation of the first of J.K. Rowlings popular children's novels about Harry Potter",
	4,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Chris" AND d.dir_lname = "Columbus"));
	
-- title: Harry Potter and the Chamber of Secrets
-- release_year: 2002
-- description: Adaptation of the second of J.K. Rowlings popular children's novels about Harry Potter
-- rating: 4
-- fk_dir_id - reference to dir_fname: Chris, dir_lname: Columbus
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("Harry Potter and the Chamber of Secrets", 2002, 
	"Adaptation of the second of J.K. Rowlings popular children's novels about Harry Potter",
	4,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Chris" AND d.dir_lname = "Columbus"));
	
-- title: Her
-- release_year: 2013
-- description: A man becomes fascinated with a new operating system which develops into an intuitive and unique entity.
-- rating: 5
-- fk_dir_id - reference to dir_fname: Spike, dir_lname: Jonze
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("Her", 2013, 
	"A man becomes fascinated with a new operating system which develops into an intuitive and unique entity",
	5,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Spike" AND d.dir_lname = "Jonze"));
	
-- title: Mouse Hunt
-- release_year: 1997
-- description: Two hapless brothers go to wild extremes to rid their house of a very shrewd mouse.
-- rating: 3
-- fk_dir_id - reference to dir_fname: Gore, dir_lname: Verbinski
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("Mouse Hunt", 1997, 
	"Two hapless brothers go to wild extremes to rid their house of a very shrewd mouse",
	3,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Gore" AND d.dir_lname = "Verbinski"));
	
-- title: Lost in Translation
-- release_year: 2003
-- description: Two hapless brothers go to wild extremes to rid their house of a very shrewd mouse.
-- rating: 5
-- fk_dir_id - reference to dir_fname: Sofia, dir_lname: Coppola
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("Lost in Translation", 2003, 
	"An aging actor Bob Harris, befriends college graduate Charlotte in a Toyko hotel",
	5,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Sofia" AND d.dir_lname = "Coppola"));
	
-- title: The Bling Ring
-- release_year: 2013
-- description: Two hapless brothers go to wild extremes to rid their house of a very shrewd mouse.
-- rating: 5
-- fk_dir_id - reference to dir_fname: Sofia, dir_lname: Coppola
INSERT INTO movies(title, release_year, description, rating, fk_dir_id) VALUES
	("The Bling Ring", 2003, 
	"Based on a real-world crime ring that preys on wealthy victims",
	3,
	(SELECT d.dir_id FROM directors d WHERE d.dir_fname = "Sofia" AND d.dir_lname = "Coppola"));
	
-- insert the following into the actors table:

-- actor_fname: Nathan
-- actor_lname: Lane
-- actor_gender: Male
-- actor_dob: 2/3/1956
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Nathan", "Lane", "Male", "1956-02-03");

-- actor_fname: Scarlett
-- actor_lname: Johansson
-- actor_gender: Female
-- actor_dob: 11/22/1984
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Scarlett", "Johansson", "Female", "1984-11-22");

-- actor_fname: Emma
-- actor_lname: Watson
-- actor_gender: Female
-- actor_dob: 4/15/1990
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Emma", "Watson", "Female", "1990-04-15");
	
-- actor_fname: Daniel 
-- actor_lname: Radcliffe
-- actor_gender: Male
-- actor_dob: 4/15/1990
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Daniel", "Radcliffe", "Male", "1989-07-23");
	
-- actor_fname: Bill
-- actor_lname: Murray
-- actor_gender: Male
-- actor_dob: 9/21/1950
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Bill", "Murray", "Male", "1950-09-21");
	
-- actor_fname: Matthew
-- actor_lname: Broderick
-- actor_gender: Male
-- actor_dob: 3/21/1962
INSERT INTO actors(actor_fname, actor_lname, actor_gender, actor_dob) VALUES
	("Matthew", "Broderick", "Male", "1962-03-21");



-- insert the following into the genres table 

-- genre_type - Drama
INSERT INTO genres(genre_type) VALUES
	("Drama");
	
-- genre_type - Romance
INSERT INTO genres(genre_type) VALUES
	("Romance");

-- genre_type - Adventure
INSERT INTO genres(genre_type) VALUES
	("Adventure");

-- genre_type - Fantasy
INSERT INTO genres(genre_type) VALUES
	("Fantasy");
	
-- genre_type - Family
INSERT INTO genres(genre_type) VALUES
	("Family");
	
-- genre_type - Comedy
INSERT INTO genres(genre_type) VALUES
	("Comedy");
	
-- genre_type - Animated
INSERT INTO genres(genre_type) VALUES
	("Animated");
	
-- insert the following is_in instances into the is_in table 
-- (you should use a subquery to set up foriegn key references, no hard coded numbers):

-- mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- aid - reference to actor_fname: Emma, actor_lname: Watson
-- char_name - Hermione Granger
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Sorcerer's Stone"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Emma" AND a.actor_lname = "Watson"),
	"Hermione Granger");

-- mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- aid - reference to actor_fname: Daniel, actor_lname: Radcliffe
-- char_name - Harry Potter
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Sorcerer's Stone"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Daniel" AND a.actor_lname = "Radcliffe"),
	"Harry Potter");
	
-- mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- aid - reference to actor_fname: Emma, actor_lname: Watson
-- char_name - Hermione Granger
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Chamber of Secrets"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Emma" AND a.actor_lname = "Watson"),
	"Hermione Granger");

-- mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- aid - reference to actor_fname: Daniel, actor_lname: Radcliffe
-- char_name - Harry Potter
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Chamber of Secrets"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Daniel" AND a.actor_lname = "Radcliffe"),
	"Harry Potter");
	
-- mid - reference to movie_title: Her
-- aid - reference to actor_fname: Scarlett, actor_lname: Johansson
-- char_name - Samantha
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Her"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Scarlett" AND a.actor_lname = "Johansson"),
	"Samantha");

-- mid - reference to movie_title: Mouse Hunt
-- aid - reference to actor_fname: Nathan, actor_lname: Lane
-- char_name - Ernie Smuntz
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Mouse Hunt"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Nathan" AND a.actor_lname = "Lane"),
	"Ernie Smuntz");
	
-- mid - reference to movie_title: Lost in Translation
-- aid - reference to actor_fname: Scarlett, actor_lname: Johansson
-- char_name - Charlotte
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Lost in Translation"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Scarlett" AND a.actor_lname = "Johansson"),
	"Charlotte");	
	
-- mid - reference to movie_title: Lost in Translation
-- aid - reference to actor_fname: Bill, actor_lname: Murray
-- char_name - Bob Harris
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Lost in Translation"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Bill" AND a.actor_lname = "Murray"),
	"Bob Harris");	
	
-- mid - reference to movie_title: The Bling Ring
-- aid - reference to actor_fname: Emma, actor_lname: Watson
-- char_name - Hermione Granger
INSERT INTO is_in(mid, aid, char_name) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "The Bling Ring"),
	(SELECT a.actor_id FROM actors a WHERE a.actor_fname = "Emma" AND a.actor_lname = "Watson"),
	"Nicki");

	
-- insert the following is_in instances into the belong table 
-- (you should use a subquery to set up foriegn key references, no hard coded numbers):

-- b_mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- gid - reference to genre_type: Fantasy
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Sorcerer's Stone"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Fantasy"));
	
-- b_mid - reference to movie_title: Harry Potter and the Sorcerer's Stone
-- gid - reference to genre_type: Adventure
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Sorcerer's Stone"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Adventure"));
	
-- b_mid - reference to movie_title: Harry Potter and the Chamber of Secrets
-- gid - reference to genre_type: Fantasy
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Chamber of Secrets"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Fantasy"));
	
-- b_mid - reference to movie_title: Harry Potter and the Chamber of Secrets
-- gid - reference to genre_type: Adventure
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Harry Potter and the Chamber of Secrets"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Adventure"));
	
-- b_mid - reference to movie_title: Mouse Hunt
-- gid - reference to genre_type: Comedy
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Mouse Hunt"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Comedy"));
	
-- b_mid - reference to movie_title: Mouse Hunt
-- gid - reference to genre_type: Family
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Mouse Hunt"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Family"));
	
-- b_mid - reference to movie_title: Her
-- gid - reference to genre_type: Drama
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Her"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Drama"));
	
-- b_mid - reference to movie_title: Her
-- gid - reference to genre_type: Romance
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Her"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Romance"));

-- b_mid - reference to movie_title: Lost in Translation
-- gid - reference to genre_type: Romance
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Lost in Translation"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Romance"));
	
-- b_mid - reference to movie_title: Lost in Translation
-- gid - reference to genre_type: Drama
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Lost in Translation"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Drama"));
	
-- b_mid - reference to movie_title: Lost in Translation
-- gid - reference to genre_type: Drama
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "Lost in Translation"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Comedy"));

-- b_mid - reference to movie_title: Lost in Translation
-- gid - reference to genre_type: Drama
INSERT INTO belong(b_mid, gid) VALUES (
	(SELECT m.movie_id FROM movies m WHERE m.title = "The Bling Ring"),
	(SELECT g.genre_type FROM genres g WHERE g.genre_type = "Drama"));