-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Represent Tour Operators using this app
CREATE TABLE "tour_operators" (
    "id" INTEGER,
    "name" TEXT UNIQUE NOT NULL,
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
    "company_role" TEXT NOT NULL CHECK("company_role" IN ('owner', 'guide', 'office')),
    "payrate" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL CHECK(LENGTH("password")>8),
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
    "type" TEXT NOT NULL CHECK("type" IN ('walking', 'bus', 'indoor'))
    PRIMARY KEY("id"),
    FOREIGN KEY("company_id") REFERENCES "tour_operators"("id") 
    FOREIGN KEY("location_id") REFERENCES "locations"("id") 
);

-- CREATE TABLE "tour_keywords" (

-- );

-- CREATE TABLE "keywords" (

-- );

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
    "notes" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("tour_id") REFERENCES "tour_types"("id")
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
    "user_id" INTEGER,
    "event_id" INTEGER,
    "time_booked" NUMERIC NOT NULL DEFAULT CURRENT_DATETIME,
    "payment" NUMERIC NOT NULL DEFAULT(0.00)
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("event_id") REFERENCES "events"("id")
);

-- a booking can have multiple tickets per event
CREATE TABLE "booking_tickets" (
    "booking_id" INTEGER,
    "ticket_type" TEXT NOT NULL,
    "ticket_amount" INTEGER NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT('not checked in') CHECK("status" IN('not checked-in', 'checked-in', 'cancelled'))
);

-- allow users to leave reviews on tours they attended, Limit to users that have attended a tour.
CREATE TABLE "reviews" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "tour_id" INTEGER NOT NULL,
    "review" TEXT NOT NULL, -- require text review in addition to stars
    "stars" INTEGER NOT NULL CHECK("stars" IN (1,2,3,4,5))
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("tour_id") REFERENCES "tour_types"("id")
);



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
DROP TABLE "booking_tickets"; DROP TABLE "bookings"; DROP TABLE "tour_types"; DROP TABLE "ticket_types"; DROP TABLE "users"; DROP TABLE "locations"; DROP TABLE "staff"; DROP TABLE "tour_operators";