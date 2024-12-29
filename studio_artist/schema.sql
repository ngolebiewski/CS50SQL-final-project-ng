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
-- Originally I had a `series` AND a `department` table, 
-- but decided to consolidate since the columns were identical
-- and added in the 'type' field to differentiate. 
CREATE TABLE "section"(
    "id" INTEGER, 
    "name" TEXT UNIQUE,
    "description" TEXT NOT NULL CHECK(length(description) <= 100),
    "type" TEXT NOT NULL CHECK("type" IN('series', 'department')),
    PRIMARY KEY("id")
);

CREATE TABLE "artworks" (
    "id" INTEGER,
    "artist" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "size" TEXT NOT NULL,
    "year" INTEGER,
    "image_url" TEXT,
    "department" INTEGER NOT NULL,
    "series" INTEGER NOT NULL,
    "date_added" CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("artist") REFERENCES "artists"("id"),
    FOREIGN KEY("department") REFERENCES "section"("id"),
    FOREIGN KEY("series") REFERENCES "section"("id")
);



