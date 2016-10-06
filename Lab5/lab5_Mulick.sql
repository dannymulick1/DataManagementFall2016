-- Danny Mulick, Fall 2016 Database Management
-- The Joins Three-quel

--query 1 - Show the cities of agents 
-- booking an order for a customer whose id is 
-- 'c006'. Use joins this time; no subqueries.
select city 
  from orders inner join agents on orders.aid = agents.aid
 where orders.cid = 'c006'
 order by city asc;

 --question 2 - show ids of products ordered through any agent
 -- who makes at least one order for a customer in Kyoto, order by pid
 -- desc

select distinct p.pid
  from customers c inner join orders o on c.cid = o.cid and c.city = 'Kyoto' 
              left outer join orders p on p.aid = o.aid 
 order by p.pid ASC;
       
--question 3 - show the names of customers who have never placed an
-- order. Use a subquery
select customers.name
  from customers
 where cid not in (select cid
		     from orders
	          )
 order by customers.name ASC;

--question 4 - show the names of customers who have never placed
-- an order. Use an outer join
select customers.name
  from orders right outer join customers on orders.cid = customers.cid
  where orders.cid is NULL;

--question 5 - show the names of customers who placed at least one
-- order through an agent in their own city. Along with the agents names
--need to show customer name and agent name
select c.name as customerName, a.name as agentName
  from orders o inner join agents a on o.aid = a.aid
                inner join customers c on o.cid = c.cid
 where a.city = c.city
 order by c.name ASC;

--question 6 - show the names of customers and agents living in the 
-- same city, along with the name of the shared city, regardless
-- of whether or not the customer has ever placed an order with
-- that agent
select c.name as customerName, a.name as agentName, a.city as city
  from customers c inner join agents a on c.city = a.city
 where c.city = a.city
 order by c.name Asc;

--question 7 - show the name and city of the customers who live in
 -- the city that makes the fewest different kinds of products
select name, city
  from customers
  where city in (select city
                   from products
                  group by city
                  order by count(city) asc
                  limit 1)
 order by name ASC;