-- query for question 1: get cities of agents booking for customer with c006

select city
  from agents
 where aid in (select aid
		 from orders
                where cid = 'c006');

-- id of products where customer in kyoto, sort by pid high to low
select pid
  from products
  where pid in (select pid
                  from orders
                 where cid in (select cid
                                 from customers
                                where city = 'Kyoto')
                )
  order by pid desc;

-- get id and names of customers who did not order with agent a03
select cid, name
  from customers
  where cid in (select cid
                  from orders
                 where aid not in ('a03')
               );

 -- get id of customers who ordered both p01 and p07
select cid, name
  from customers
  where cid in (select cid
                  from orders
                 where pid = 'p01'
             intersect
                select cid
                  from orders
                 where pid = 'p07');



-- get ids of products not ordered by any customer who
-- ordered through a08 order by pid high to low

select pid
  from products
 where pid not in (select pid
                    from orders
                   where aid = 'a08')
 order by pid desc;


 -- get names, discounts and city for all customers who ordered
 -- through agents in dallas or ny

select name, discount, city
  from customers
 where cid in (select cid
                 from orders
                where aid in (select aid
                                from agents
                               where city in ('Dallas', 'New York')
                             )
               );

-- get all customers with same discount as those in dallas or london
select *
  from customers
 where discount in (select discount
                      from customers
                     where city in ('Dallas', 'London')
                    );



 