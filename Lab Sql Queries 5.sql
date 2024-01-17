use sakila;
-- 1.Drop column picture from staff 
alter table staff drop column picture;

-- 2. Update new hired person to help Jon
insert into customer (store_id, first_name, last_name, email, address_id, `active` , create_date, last_update) 
values (1, 'TAMMY', 'SANDERS', 'tammysanders@example.com', 1, 1, current_timestamp, current_timestamp);

-- 3. Add rental fro movie Academy Dinosaur by Charlotte Hunter from Mike Hillyer at store 1
select customer_id from customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

-- 4. Academy Dinosaur film_id and rental duration
select * from sakila.film where title like '%Academy Dinosaur%';

-- 5. Inventory_id for the film_id
select inventory_id, film_id from inventory where film_id = (select film_id from film where title = 'Academy Dinosaur');

-- Checking Mike Hillyer Staff_id
select * from sakila.staff
where first_name = 'Mike';
select date_add(current_timestamp(), interval 6 day);
select max(rental_id) from sakila.rental;
insert into sakila.rental values
(16049 + 1, current_date(), 4, 130, date_add(current_timestamp(), interval 6 day), 1, current_timestamp());
select * from sakila.rental
where rental_id = (select max(rental_id) from sakila.rental);

-- Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. 
-- Follow these steps:
	-- Check if there are any non-active users
	-- Create a table backup table as suggested
	-- Insert the non active users in the table backup table
	-- Delete the non active users from the table customer

select * from sakila.customer
where active = 0;

select count(*) as 'Number of non-active' from sakila.customer
where active = 0;

describe sakila.customer;

create table deleted_users (
  `customer_id` int UNIQUE NOT NULL,
  `email` char(50) DEFAULT NULL,
  `create_date` datetime,
  CONSTRAINT PRIMARY KEY (customer_id) 
);

select * from sakila.deleted_users;

-- -> Inserting the non active users in the table backup table

-- Listing the users to delete first
select customer_id, email, create_date from sakila.customer
where active = 0; 

-- Inserting those users into the deleted_users table
insert into sakila.deleted_users(customer_id, email, create_date)
	select customer_id, email, create_date from sakila.customer
	where active = 0;  
    
select * from sakila.deleted_users;

-- -> Deleting the non active users from the table customer
set sql_safe_updates = 0;

-- Due to the foreign key constraint we need to delete the payments and rentals for this deleted_users
delete from sakila.payment
where customer_id in (select customer_id from sakila.deleted_users);

delete from sakila.rental
where customer_id in (select customer_id from sakila.deleted_users);

-- Now we can delete from the customer table
delete from sakila.customer
where active = 0;

select count(*) as 'Number of non-active' from sakila.customer
where active = 0;