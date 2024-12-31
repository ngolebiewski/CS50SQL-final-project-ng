-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Add artists to the database
INSERT INTO "artists" (
    "first_name", 
    "last_name", 
    "short_bio",
    -- "long_bio", 
    "image_url", 
    "birth_country",
    "birth_year",
    "death_year")
VALUES (
    'Pablo',
    'Picasso',
    'Pablo Ruiz Picasso was a Spanish painter, sculptor, printmaker, ceramicist, and theatre designer who spent most of his adult life in France.', -- https://en.wikipedia.org/wiki/Pablo_Picasso
    -- "Pablo Ruiz Picasso (25 October 1881 – 8 April 1973) was a Spanish painter, sculptor, printmaker, ceramicist, and theatre designer who spent most of his adult life in France. One of the most influential artists of the 20th century, he is known for co-founding the Cubist movement, the invention of constructed sculpture,[8][9] the co-invention of collage, and for the wide variety of styles that he helped develop and explore. Among his most famous works are the proto-Cubist Les Demoiselles d'Avignon (1907) and the anti-war painting Guernica (1937), a dramatic portrayal of the bombing of Guernica by German and Italian air forces during the Spanish Civil War.",
    '/images/picasso.png',
    'Spain',
    1881,
    1973
),
    ('Nick', 'Golebiewski', 'Nick Golebiewski is a visual artist and software engineer, with a studio in Brooklyn, NY, who paints images of New York City.', '/images/nick_golebiewski.jpg', 'United States',NULL,NULL)
;

-- add mediums
INSERT INTO "mediums" ("name")
VALUES ('watercolor'), ('oil paint'), ('canvas'), ('paper'), ('pencil');

-- add an artwork
INSERT INTO "artworks" ("artist_id", "title", "size", "year")
VALUES ((SELECT "id" FROM "artists" WHERE "last_name" = "Picasso"), 'The Old Guitarist', '122.9 cm × 82.6 cm', 1903),
    ((SELECT "id" FROM "artists" WHERE "last_name" = "Golebiewski"), 'Grand Street', '2 feet x 3 feet', 2013)        
;

-- add mediums to an artwork
INSERT INTO "artworks_mediums" ("artwork_id", "medium_id")
VALUES(
    (SELECT "id" FROM "artworks" WHERE "title" = 'The Old Guitarist'), 
    (SELECT "id" FROM "mediums" WHERE "name" = "oil paint")
    ),
    (
    (SELECT "id" FROM "artworks" WHERE "title" = 'The Old Guitarist'), 
    (SELECT "id" FROM "mediums" WHERE "name" = "canvas")
    );

-- add another medium, would like to find a more efficient way to add, as this is repetitious.
INSERT INTO "artworks_mediums" ("artwork_id", "medium_id")
VALUES(
    (SELECT "id" FROM "artworks" WHERE "title" = 'Grand Street'), 
    (SELECT "id" FROM "mediums" WHERE "name" = "watercolor")
    ),
    (
    (SELECT "id" FROM "artworks" WHERE "title" = 'Grand Street'), 
    (SELECT "id" FROM "mediums" WHERE "name" = "pencil")
    ),
    (
    (SELECT "id" FROM "artworks" WHERE "title" = 'Grand Street'), 
    (SELECT "id" FROM "mediums" WHERE "name" = "paper")
    )
;

-- update an artwork's image url
UPDATE "artworks"
SET "image_url" = '/images/old_guitarist.jpg'
WHERE "title" = 'The Old Guitarist';

-- update another artwork's image url
UPDATE "artworks"
SET "image_url" = '/images/grand-street-gouache.jpg'
WHERE "title" = 'Grand Street';

-- create a series called "Blue Period", info via https://en.wikipedia.org/wiki/Picasso%27s_Blue_Period
INSERT INTO "sections" ("name", "description", "type")
VALUES ("Blue Period", "The Blue Period (Spanish: Período Azul) comprises the works produced by Spanish painter Pablo Picasso between 1901 and 1904. During this time, Picasso painted essentially monochromatic paintings in shades of blue and blue-green, only occasionally warmed by other colors.", "series")
;

-- create another series called "Chinatown"
INSERT INTO "sections" ("name", "description", "type")
VALUES ("Chinatown", "Golebiewski's Chinatown series explores the vibrant neighborhood of NYC in watercolor and gouache, active 2012-present.", "series")
;

-- delete a section if you make a typo!
DELETE FROM "sections" WHERE "name" = 'Chinetown'

-- create a set of departments, which are big umbrellas for artworks.
INSERT INTO "sections" ("name", "description", "type")
VALUES ("Painting", "All forms of painting, including oil, gouache, watercolor, etc.", "department"),
        ("Film", "Video, super 8 film, 16mm, 35mm, and all other moving images", "department"),
        ("Drawing-a-Day", "A daily drawing project", "department")
;

-- update ALL artwork's record to include its department
UPDATE "artworks" 
SET "department" = (SELECT "id" FROM "sections" WHERE "name" = 'Painting');

-- update an artwork's record to include its series.
UPDATE "artworks"
SET "series" = (SELECT "id" FROM "sections" WHERE "name" = 'Blue Period')
WHERE "title" = "The Old Guitarist";

-- again...
UPDATE "artworks"
SET "series" = (SELECT "id" FROM "sections" WHERE "name" = "Chinatown")
WHERE "title" = "Grand Street";

-- Search all artworks by artist's last name.
SELECT * FROM "artworks"
WHERE "artist_id" = (SELECT "id" FROM "artists" WHERE "last_name" = "Picasso");

-- Show all human readable artworks by artist's name from the art_list view.
SELECT * FROM "art_list"
WHERE "name" = "Pablo Picasso";

-- List the mediums used by a specific artwork by its title
SELECT "mediums"."name" AS "medium", "title" 
FROM "mediums"
JOIN "artworks_mediums" ON "mediums"."id" = "artworks_mediums"."medium_id"
JOIN "artworks" ON "artworks_mediums"."artwork_id" = "artworks"."id"
WHERE "artworks_mediums"."artwork_id" = (SELECT "id" FROM "artworks" WHERE "title" = 'The Old Guitarist');

-- List the mediums used by a specific artwork and group together into a list -- note, made this into a view
SELECT GROUP_CONCAT("mediums"."name") AS "mediums", "title", "artworks"."id"
FROM "mediums"
JOIN "artworks_mediums" ON "mediums"."id" = "artworks_mediums"."medium_id"
JOIN "artworks" ON "artworks_mediums"."artwork_id" = "artworks"."id"
WHERE "artworks_mediums"."artwork_id" = (SELECT "id" FROM "artworks" WHERE "title" = 'The Old Guitarist')
GROUP BY "title";

-- SELECT "title", "mediums" FROM "artworks"
-- WHERE "artworks"."id" = 1
-- JOIN "mediums" on 


-- Find artwork by title, list basic info and artist name
SELECT "title", "size", "year", "first_name", "last_name"
FROM "artworks"
JOIN "artists" on "artists"."id" = "artworks"."artist_id"
WHERE "title" LIKE "%old%"
ORDER BY "title" ASC;

-- How many artworks do each artist have?
SELECT first_name || ' ' || last_name AS "name", COUNT ("title") as "number artworks"
FROM "artists"
JOIN "artworks" ON "artists"."id" = "artworks"."artist_id"
GROUP BY "artist_id"
ORDER BY "last_name";



-- Find all artworks in a series
-- List all series by an artist
-- Find all artworks within a specific department in a section.
-- Create a Sale and update artwoirk records with Triggers sold to True
-- Search artworks by a keyword in descriptions using LIKE
-- Find all artworks missing an image
-- list all artists
-- list all dead artists
-- Find all artworks that have 'watercolor' as a medium.