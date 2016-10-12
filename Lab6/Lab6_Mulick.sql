--Danny Mulick, Lab 6, Data Mann

--question 1: display name and city of customers who live in any city
-- that makes the most different kinds of products
-- (there are two that make the most. Return name and city from either)
--select name, city of customers who in most product city
select name, city
  from customers c
 where c.city in (select distinct o.city
		    from products o inner join (select city,
                                                       count(city)
					          from products 
                                                 group by city) p on o.city = p.city
                   where p.count = (select MAX(p.count) as maximum
                    from (select city,
                                 count(city)
                            from products 
                           group by city) p));

--question 2: display names of products where priceUSD is below average
-- priceUSD, sort by alphabet desc
select p.name
  from products p
 where priceUSD < (select AVG(priceUSD) as average
                     from products)
 order by name desc;


--question 3: display the customer name, pid ordered, and total for all
-- orders, sorted by total from low to high
select c.name, o.pid, o.totalUSD
  from orders o inner join customers c on o.cid = c.cid
 order by totalUSD ASC;

--question 4: display all customer names (sort asc) and their total
-- ordered, nothing more. Use Coalesce to avoid NULLs

--i. Select *, coalesce(name, 'who knows?')
--  from customers;
--does total ordered mean total across all orders, or total for that order?

--question 5: display the names of all customers who bought products
-- from agents based in NY along with the names of products they ordered,
-- and the names of the agents who sold to them

--find agents in NY
	-- take their names
-- find orders from those agents
	-- find product ordered
		-- take product name
	-- find customers
		--take customer name