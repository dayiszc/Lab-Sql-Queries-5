use sakila;
alter table staff drop column picture;
insert into customer (store_id, first_name, last_name, email, address_id, `active` , create_date, last_update) 
values (1, 'TAMMY', 'SANDERS', 'tammysanders@example.com', 1, 1, current_timestamp, current_timestamp);
select customer_id from customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
select inventory_id, film_id from inventory where film_id = (select film_id from film where title = 'Academy Dinosaur');
select staff_id from staff where first_name = 'MIKE' and last_name = 'HILLYER';
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id) 
values (now(), 'actual_inventory_id', 'actual_customer_id', NULL, 'actual_staff_id'); -- ERROR
create table deleted_users as select customer_id, email, now() as deletion_date from customer where active = 0;
insert into deleted_users (customer_id, email, deletion_date) select customer_id, email, now() from customer where active = 0;
delete from customer where active = 0;-- error
