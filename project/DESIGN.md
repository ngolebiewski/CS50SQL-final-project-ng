# Design Document

By Nicholas Golebiewski

Video overview: <URL HERE>

## Scope

The database for I-AM-A-TOURIST-AND-I-WALK.NYC includes all the entities necessary for independent tour guide companies to schedule, book, manage, invoice and accept payments for walking tours -- and for participants to find, book, pay for and attend tours. The system will be queried for reminders, payments, and check-in status by guests, guides, and tour company office staff.

Included in the scope of this database is:

* Tour operators, including personally identifiable information (PII)
* Tour staff, including PII, admin access, and type.
* Tours, including default information for each tour type, type(public,private)per tour operator. Tours will reference the following tables.
    * Tickets, includes prices and types.
    * Locations, names and addresses for tours.
    * Resources, requirements for tours.
* Calendar, which includes dates, times and specific details like attendees.
* Guests, accounts for attendees of tours, including PII
* Payments, status and record of payments. No credit card information will be stored in this system, (i.e credit card payments via Stripe, Paypal)
* Cart, for selecting tours, number of attendees, etc. 
* Orders, fulfilled carts that have been purchased.
    * Orders will have a trigger that populates an...
* Attendees, connects guests to the tours on the calendar, tracks name(s), special requests, status. 
* Comments, ?
* Reviews, guests can leave reviews on specific tours.

Out of scope elements are:

* Out of scope is accepting payments and hashing passwords, both of which would be implemented through the application.
    * API interface encrypts and decrypts passwords.
    * Connecting to Stripe, Paypal, and VENMO's APIs as vehicle for charging credit cards and accepting payments.
* Various Admin and Auth levels of access would also be implemented at the application level, server issues JSON WEB TOKENS.
* Group visits and bookings, this database focuses on individual sales.
* Implementing a shopping cart for multiple tour purchases. This iteration supports single event sales.

## Functional Requirements

This database will support:

* Create Read Update Delete operations for guests, guides, and tour company staff.
* Tour Companies adding public tours to a schedule, adding staff to lead the tour, and accepting and managing reservations.
* Guides will be able to see a calendar of all their company's tours, what tours they are leading, and will be able to check in guests and see contact information.
* Guests will be able to search for tours, and make reservations. They will place the tour(s) in a cart, record their payment at checkout.
* The system will send out reminders to guides and attendees in advance of tours

* What should a user be able to do with your database?
* What's beyond the scope of what a user should be able to do with your database?

* In this version, the system will not support group organizations that are connected to individuals booking private tours.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?
* What attributes will those entities have?
* Why did you choose the types you did?
* Why did you choose the constraints you did?

#### Tour Operators

The `tour_operators` table includes:
    *

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
Some repetition: Staff and Users have similar fields, but I want to make sure that there is no overlap for security. Another issue is that an employee of a company would have to create a seperate attendee account to book a tour themselves.

* limitation. 1 guide per tour. In reality could be multiple guides per tour. 

* What might your database not be able to represent very well?

## Dev notes

* When using own machine, make the CLI output pretty with `.mode column` and `.headers on`