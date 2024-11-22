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
FROM "events" 
JOIN "tour_types" ON "events"."tour_id" = "tour_types"."id"
JOIN "tour_operators" ON "tour_operators"."id" = "tour_types"."company_id"
JOIN "locations" ON "tour_types"."location_id" = "locations"."id"
WHERE "events"."date" >= date() <= date('now','+1 month','-1 day'), --Selects today's date through one month from now, Reference -> https://sqlite.org/lang_datefunc.html 
AND "tour_operators"."id" = (
    SELECT "id" FROM "tour_operators" WHERE "name" = 'Nicks NYC Walking Tours'
    )
;




-- See attendees of a tour

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


