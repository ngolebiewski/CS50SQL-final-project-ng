-- Represent artist entities in this table

CREATE TABLE "artists" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL, -- use 'Unknown' if not known
    "last_name" TEXT NOT NULL, -- use 'Unknown' if not known
    "artist_name" TEXT, -- Optional, only some artists have an "artist_name", like 'Prince'
    "short_bio" TEXT NOT NULL CHECK(length(short_bio) <= 200),
    "long_bio" TEXT, -- Optional, too long for demos, really clouds up the view
    "image_url" TEXT, -- relative link to image URL. Would like to insert as BLOB in a later version.
    "birth_country" TEXT,
    "birth_year" INTEGER, -- leaving personally identifiable data optional, here and below.
    "death_year" INTEGER,
    PRIMARY KEY("id")
);

-- These are the units that art can be organized within.
-- Originally I had a `series` AND a `department` table, but decided to consolidate since the columns were identical
-- and added in the 'type' field to differentiate. 
CREATE TABLE "sections"(
    "id" INTEGER, 
    "name" TEXT UNIQUE,
    "description" TEXT NOT NULL CHECK(length(description) <= 100),
    "type" TEXT NOT NULL CHECK("type" IN('series', 'department')),
    PRIMARY KEY("id")
);

CREATE TABLE "mediums"(
    "id" INTEGER, 
    "name" TEXT UNIQUE,
    PRIMARY KEY("id")
);

CREATE TABLE "artworks_mediums"(
    "artwork_id" INTEGER NOT NULL,
    "medium_id" INTEGER NOT NULL,
    PRIMARY KEY("artwork_id", "medium_id")
    FOREIGN KEY("artwork_id") REFERENCES "artworks"("id"),
    FOREIGN KEY("medium_id") REFERENCES "mediums"("id")
);

-- The main record of this database, the ARTWORK! 🖼️
CREATE TABLE "artworks" (
    "id" INTEGER,
    "artist_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "size" TEXT NOT NULL,
     -- mediums of artwork via a join table
    "year" INTEGER,
    "image_url" TEXT,
    "descriptiom" TEXT,
    "department" INTEGER NOT NULL,
    "series" INTEGER NOT NULL,
    "date_added" CURRENT_TIMESTAMP,
    "price" DECIMAL,
    "sold" INTEGER NOT NULL DEFAULT(0) CHECK("sold" IN (0,1)), -- False/0 = not sold, True/1 = sold
    PRIMARY KEY("id"),
    FOREIGN KEY("artist") REFERENCES "artists"("id"),
    FOREIGN KEY("department") REFERENCES "section"("id"),
    FOREIGN KEY("series") REFERENCES "section"("id") -- references a different section id, can you do this?
);

CREATE TABLE "organizations" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT DEFAULT('United States'),
    "phone" TEXT,
    "email" TEXT NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN ('museum', 'gallery', 'non-profit', 'restaurant', 'business', 'other')),
    PRIMARY KEY("id")
);

-- persons (rather than the more correct 'people') which represents a person (hence, the plural)
CREATE TABLE "persons" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL, -- use 'Unknown' if not known
    "email" TEXT UNIQUE,
    "phone" INTEGER,
    "org" INTEGER,
    "type" TEXT NOT NULL DEFAULT('contact') CHECK("type" IN ('collector', 'friend', 'artist', 'client', 'collector', 'other')),
    PRIMARY KEY("id"),
    FOREIGN KEY("org") REFERENCES "organizations"("id")
);

-- A table which answers the question, who purchased the artwork?
CREATE TABLE "sold_artworks" (
    "id" INTEGER,
    "artwork_id" INTEGER NOT NULL,
    "person_id" INTEGER NOT NULL,
    "org_id" INTEGER,
    "price" DECIMAL,
    "date_sold" NUMERIC DATE, -- CHECK THIS.
    "timestamp" CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("artwork_id") REFERENCES "artworks"("id"),
    FOREIGN KEY("person_id") REFERENCES "persons"("id"),
    FOREIGN KEY("org_id") REFERENCES "organizations"("id")
);


