-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Represent Tour Operators using this app
CREATE TABLE "tour_operators" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
    "nickname" TEXT UNIQUE,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT DEFAULT('United States'),
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "logo_url" TEXT NOT NULL, -- link to image file for company logo
    "website_url" TEXT NOT NULL,
    "date_joined" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY("id")
); 

-- Represent the Staff that work for a tour operator (beyond scope to work at multiple companies)
CREATE TABLE "staff" (
    "id" INTEGER,
    "company_id" INTEGER NOT NULL,
    "role" TEXT NOT NULL CHECK("role" IN ('owner', 'guide', 'office')),
    "admin" TEXT NOT NULL DEFAULT('False') CHECK ("admin" IN ('True', 'False')), -- using Python keywords for T/F expecting to build backend with FastAPI
    "payrate" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL CHECK(LENGTH("password")>8), -- Would be hashed in production
    "mobile" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "profile_img_url" TEXT, -- link to profile image
    "bio" TEXT,
    "date_added" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY("id"),
    FOREIGN KEY("company_id") REFERENCES "tour_operators"("id") 
); 

-- Represents start locations/addresses for tours.
CREATE TABLE "locations" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "address_1" TEXT,
    "address_2" TEXT,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT DEFAULT('United States'),
    PRIMARY KEY("id")
);

-- Set base tour types, to use as a template for specific tour instances on `events`
CREATE TABLE "tour_types" (
    "id" INTEGER,
    "company_id" INTEGER,
    "location_id" INTEGER,
    "name" TEXT NOT NULL,
    "short_description" TEXT NOT NULL,
    "long_description" TEXT,
    "image_url" TEXT,
    "standard_start_time" NUMERIC,
    "duration" NUMERIC NOT NULL,
    "capacity" INTEGER NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN ('walking', 'bus', 'indoor')),
    PRIMARY KEY("id"),
    FOREIGN KEY("company_id") REFERENCES "tour_operators"("id"), 
    FOREIGN KEY("location_id") REFERENCES "locations"("id") 
);

-- Join table linking tour_types with keywords
CREATE TABLE "tour_keywords" (
    "tour_id" INTEGER NOT NULL,
    "keyword_id" INTEGER NOT NULL, 
    FOREIGN KEY "tour_id" REFERENCES "tour_types"("id"),
    FOREGIN KEY "keyword_id" REFERENCES "keywords"("id")
);

-- Set keywords for tours for searching, i.e. arts, culture, walking, history, food, etc.
CREATE TABLE "keywords" (
    "id" INTEGER,
    "keyword" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- create ticket types for each tour operator, i.e. Student ticket $15
CREATE TABLE "ticket_types" (
    "id" INTEGER,
    "company_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("company_id") REFERENCES "tour_operators"("id")
);

-- Create instances of a tour on the schedule
CREATE TABLE "events" (
    "id" INTEGER,
    "tour_id" INTEGER NOT NULL,
    "date" NUMERIC NOT NULL,
    "attendees" INTEGER NOT NULL DEFAULT(0) CHECK("attendees" <= "capacity"), -- can't overbook tour without increasing capacity
    "capacity" INTEGER NOT NULL,
    "start_time" NUMERIC NOT NULL,
    "tour_guide_id" INTEGER, -- Nullable, because you can schedule a staff member after the tour is added to the calendar, would implement as a join table in later iteration to accomodate multiple guides for bigger tour groups
    "notes" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("tour_id") REFERENCES "tour_types"("id"),
    FOREIGN KEY("tour_guide_id") REFERENCES "staff"("id")
);

-- user profiles for the general tour booking tours
CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL CHECK(LENGTH("password")>8),
    "mobile" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "date_joined" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY("id")
);

-- a user makes a booking of multiple tickets for a specific event
CREATE TABLE "bookings" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "event_id" INTEGER NOT NULL,
    "note" TEXT,
    "time_booked" NUMERIC NOT NULL DEFAULT CURRENT_DATETIME,
    "payment" NUMERIC NOT NULL DEFAULT(0.00),
    -- "payment_timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("event_id") REFERENCES "events"("id")
);

-- a booking can have multiple tickets per event
CREATE TABLE "booking_tickets" (
    "booking_id" INTEGER NOT NULL,
    "ticket_type" TEXT NOT NULL,
    "ticket_amount" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT('not checked in') CHECK("status" IN('not checked-in', 'checked-in', 'cancelled')),
    FOREIGN KEY("booking_id") REFERENCES "bookings"."id"
);

-- allow users to leave reviews on tours they attended, Limit to users that have attended a tour.
CREATE TABLE "reviews" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "tour_id" INTEGER NOT NULL,
    "company_id" INTEGER NOT NULL,
    "review" TEXT NOT NULL, -- require text review in addition to stars
    "stars" INTEGER NOT NULL CHECK("stars" IN (1,2,3,4,5)),
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("tour_id") REFERENCES "tour_types"("id"),
    FOREIGN KEY("company_id") REFERENCES "tour_operators"("id")
);

-- allows employees of the tour app tech company to manage the system.
CREATE TABLE "db_admins" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL CHECK(LENGTH("password")>8),
    "email" TEXT NOT NULL,
    "admin_level" TEXT NOT NULL CHECK("admin_level" IN ('superadmin', 'admin', 'analyst')),
    PRIMARY KEY("id")
);

-- Query to use the below views:
    -- Top 10 tours
    -- Top 10 tour companies
    -- what is the rating of a tour
    -- what is a company's #1 tour?

-- Show aggregate reviews for tour operators, sorted by average rating, sorted best at the top
CREATE VIEW "review_summary" AS
SELECT "tour_operators"."name", ROUND(AVG("stars"), 1) AS "average rating", COUNT("stars") AS "number reviews"
FROM "tour_operators"
JOIN "reviews" ON "tour_operators"."id" = "reviews"."company_id"
GROUP BY "tour_operators"."id" -- OR "reviews"."company_id" are they interchangable?
ORDER BY "average rating" DESC, "tour_operators"."name" ASC;

-- Show highest reviewed tours, sorted by average rating, sorted best at the top
CREATE VIEW "tour_review_summary" AS
SELECT "tour_types"."name", "tour_operators"."name", ROUND(AVG("stars"), 1) AS "average rating", COUNT("stars") AS "number reviews"
FROM "tour_operators"
JOIN "reviews" ON "tour_operators"."id" = "reviews"."company_id"
JOIN "tour_types" ON "reviews"."company_id" = "tour_types"."company_id"
GROUP BY "tour_types"."name"
ORDER BY "average rating" DESC, "tour_types"."name" ASC, "tour_operators"."name" ASC;

-- Create an event view, since each event is in multiple tables
CREATE VIEW "tour_view"  AS
SELECT "events"."id", "events"."name", "staff"."first_name"
FROM "events" 
JOIN "tour_types" ON "events"."tour_id" = "tour_types"."id"
JOIN "tour_operators" ON "tour_operators"."id" = "tour_types"."company_id"
JOIN "locations" ON "tour_types"."location_id" = "locations"."id"
JOIN "keywords" 
JOIN "staff" ON "events"."tour_guide_id" = "staff"."id"
;


-- CREATE VIEW "attendees" AS 

-- CREATE VIEW
-- Attendees by event 

-- trigger or view?
-- CREATE TABLE "attendees"(

-- );

-- CREATE TABLE "cart" (
--     "id" INTEGER,
--     "user_id" INTEGER,
--     "in_use" INTEGER CHECK(IN(0,1)), -- boolean true =1, false = 1 to see if closed out
--     "paid" INTEGER CHECK(IN(0,1)),
--     "amount" INTEGER,
--     PRIMARY KEY("id"),
-- )

-- CREATE TABLE "cart_items" (
--     "cart_id"
--     "schedule_id"
--     "number_tickets"
--     "names additional guests"
--     ""
-- )

-- run following commands to drop all tables -------------------------------------
-- DROP VIEW "review_summary"; DROP TABLE "db_admins"; DROP TABLE "events"; DROP TABLE "booking_tickets"; DROP TABLE "bookings"; DROP TABLE "tour_types"; DROP TABLE "ticket_types"; DROP TABLE "users"; DROP TABLE "locations"; DROP TABLE "staff"; DROP TABLE "tour_operators";