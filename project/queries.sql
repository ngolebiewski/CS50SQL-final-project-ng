-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--COMMON QUERIES--

-- Show all the tour companies in a given city
SELECT "name"
FROM "tour_operators"
WHERE "city" = 'New York';

-- Search on a tour company name, list a tour operators' staff and title, this data could be used for an 'about' page on a website
SELECT "first_name", "last_name", "role", "bio", "profile_img_url"
FROM "staff"
JOIN "tour_operators" ON "company_id" = "staff"
WHERE "tour_operators"."name" = 'Nicks NYC Walking Tours';

-- Populate a calendar with a company's upcoming tours for the next month
SELECT *
FROM "events" Y"
FROM "booking_tickets"
JOIN "bookings" ON "booking_tickets"."booking_id" = "bookings"."id"
JOIN "users" ON "bookings"."user_id" = "users"."id"
WHERE "bookings"."event_id" = 1
ORDER BY "users"."last_name ASC;

-- Search for all tours in a city on a given day

-- See attendees of a tour

-- current available tours by tour organization

-- Event query/view for tour guides
-- Query event id match name, date, id, tourco.
-- brings up view with:
    -- event name
    -- date
    -- time
    -- # attendees/max attendees
    -- bookings
        -- quick contact
        -- note
        -- people on booking
            -- check-in status
        
-- See reviews for companies.

-- Let an attendee leave a review on a tour.

-- a Guide asks, what are my upcoming tour dates, times and names?

-- a Tour Operator asks, show me tour earnings from the last month

-- an Attendee asks, when and where is my tour?


