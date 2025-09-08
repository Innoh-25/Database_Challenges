-- =============================================
-- MOVIE DATABASE SETUP AND QUERIES
-- =============================================

-- 1. CREATE DATABASE AND TABLES
-- ==============================

-- Create the database
CREATE DATABASE MovieDB;
USE MovieDB;

-- Create Actors table with ActorName
CREATE TABLE Actors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ActorName VARCHAR(100) NOT NULL,
    age INT
);

-- Create Movies table with ReleaseYear
CREATE TABLE Movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    ReleaseYear INT
);

-- Create junction table for many-to-many relationship
CREATE TABLE Movie_Actors (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES Actors(id) ON DELETE CASCADE
);

-- 2. INSERT SAMPLE DATA
-- =====================

-- Insert sample actors
INSERT INTO Actors (ActorName, age) VALUES
('Tom Hanks', 67),
('Meryl Streep', 74),
('Leonardo DiCaprio', 49),
('Scarlett Johansson', 39),
('Robert Downey Jr.', 58);

-- Insert sample movies
INSERT INTO Movies (title, ReleaseYear) VALUES
('Forrest Gump', 1994),
('The Devil Wears Prada', 2006),
('Titanic', 1997),
('Avengers: Endgame', 2019),
('The Shawshank Redemption', 1994);

-- Link actors to movies
INSERT INTO Movie_Actors (movie_id, actor_id) VALUES
(1, 1),  -- Tom Hanks in Forrest Gump
(2, 2),  -- Meryl Streep in The Devil Wears Prada
(3, 3),  -- Leonardo DiCaprio in Titanic
(4, 4),  -- Scarlett Johansson in Avengers: Endgame
(4, 5),  -- Robert Downey Jr. in Avengers: Endgame
(1, 2);  -- Meryl Streep also in Forrest Gump

-- 3. QUERY EXAMPLES
-- =================

-- Query 1: Get all actors with their details
-- Purpose: Display complete list of all actors in database
SELECT id, ActorName, age FROM Actors;

-- Query 2: Get all movies with titles and release years
-- Purpose: Show all movies in the collection
SELECT id, title, ReleaseYear FROM Movies;

-- Query 3: Find actors in a specific movie
-- Purpose: Show cast members for 'Avengers: Endgame'
SELECT a.ActorName, a.age 
FROM Actors a
JOIN Movie_Actors ma ON a.id = ma.actor_id
JOIN Movies m ON m.id = ma.movie_id
WHERE m.title = 'Avengers: Endgame';

-- Query 4: Find movies by a specific actor
-- Purpose: Show all movies featuring Meryl Streep
SELECT m.title, m.ReleaseYear 
FROM Movies m
JOIN Movie_Actors ma ON m.id = ma.movie_id
JOIN Actors a ON a.id = ma.actor_id
WHERE a.ActorName = 'Meryl Streep';

-- Query 5: Find movies from a specific year
-- Purpose: Show all movies released in 1994
SELECT title, ReleaseYear FROM Movies WHERE ReleaseYear = 1994;

-- Query 6: Find actors younger than a certain age
-- Purpose: Show actors under 50 years old
SELECT ActorName, age FROM Actors WHERE age < 50;

-- Query 7: Count movies per actor
-- Purpose: Show how many movies each actor has appeared in
SELECT a.ActorName, COUNT(ma.movie_id) as movie_count
FROM Actors a
LEFT JOIN Movie_Actors ma ON a.id = ma.actor_id
GROUP BY a.id, a.ActorName
ORDER BY movie_count DESC;

-- Query 8: Find the oldest actor
-- Purpose: Identify the most senior actor in the database
SELECT ActorName, age FROM Actors ORDER BY age DESC LIMIT 1;

-- Query 9: Find movies released in the 21st century
-- Purpose: Show modern movies (year 2000 and later)
SELECT title, ReleaseYear FROM Movies WHERE ReleaseYear >= 2000 ORDER BY ReleaseYear;

-- Query 10: Get complete movie details with cast
-- Purpose: Show each movie with its full cast list
SELECT m.title, m.ReleaseYear, GROUP_CONCAT(a.ActorName SEPARATOR ', ') as cast
FROM Movies m
JOIN Movie_Actors ma ON m.id = ma.movie_id
JOIN Actors a ON a.id = ma.actor_id
GROUP BY m.id, m.title, m.ReleaseYear;

-- Query 11: Verify database setup
-- Purpose: Confirm all tables were created successfully
SHOW TABLES;

-- Query 12: Check database is selected
-- Purpose: Verify we're working in the correct database
SELECT DATABASE();

-- 4. ADDITIONAL USEFUL QUERIES
-- ============================

-- Query 13: Find movies with multiple actors
-- Purpose: Show movies that have more than 1 actor in our database
SELECT m.title, COUNT(ma.actor_id) as actor_count
FROM Movies m
JOIN Movie_Actors ma ON m.id = ma.movie_id
GROUP BY m.id, m.title
HAVING actor_count > 1;

-- Query 14: Find average age of actors
-- Purpose: Calculate the average age of all actors
SELECT ROUND(AVG(age), 1) as average_age FROM Actors;

-- Query 15: Find movies by release decade
-- Purpose: Group movies by the decade they were released
SELECT 
    CONCAT(FLOOR(ReleaseYear/10)*10, 's') as decade,
    COUNT(*) as movie_count,
    GROUP_CONCAT(title SEPARATOR ', ') as movies
FROM Movies
GROUP BY FLOOR(ReleaseYear/10)
ORDER BY decade;

-- Query 16: Find actors who appear in multiple movies
-- Purpose: Show actors with roles in more than one film
SELECT a.ActorName, COUNT(ma.movie_id) as movie_count
FROM Actors a
JOIN Movie_Actors ma ON a.id = ma.actor_id
GROUP BY a.id, a.ActorName
HAVING movie_count > 1
ORDER BY movie_count DESC;

-- Query 17: Find the most recent movie
-- Purpose: Show the newest movie in the collection
SELECT title, ReleaseYear 
FROM Movies 
ORDER BY ReleaseYear DESC 
LIMIT 1;
