-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Add an artist to database

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