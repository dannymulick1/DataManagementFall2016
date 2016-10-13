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

select c.name, sum(coalesce(o.totalUSD, 0)) as totalOrdered
  from customers c left outer join orders o on c.cid = o.cid
 group by c.name
 order by c.name asc;

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
select c.name as customerName, p.name as productName, a.name as agentName
  from orders o inner join customers c on o.cid = c.cid
		inner join agents a on o.aid = a.aid
		inner join products p on o.pid = p.pid
 where o.aid in (select aid
		   from agents
		  where city = 'New York')
 order by customerName asc;


 --question 6: write a query to check the accuracy of dollars in orders
 -- calc o.totalUSD from data in other tables and comparing to original
 -- data. Display all rows where the original is incorrect if any
select q.totalUSD, trueBill.actualBill
  from orders q inner join (select o.ordnum, (o.qty * p.priceUSD) as actualBill
			      from orders o inner join products p on o.pid = p.pid) trueBill on trueBill.ordnum = q.ordnum 
  where q.totalUSD != trueBill.actualBill


  --answer for question 7
  /*The difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN is
  that the left outer join takes the left table that is shown as the tree,
  or main table, and the right table as the branch, or the dependant.
  For a right outer join, the main table is the table that is listed
  to the right, and the branch is the one listed on the left.
  The tree table is used to ground the records, and the branch table
  is used to match up to the tree records. If no match can be found for
  a tree record, then the columns from the branch are filled with nulls.
  The only real difference between the left outer join and right outer
  join is the placement of the tables, because the tables can be switched
  from right to left join-wise and table placement-wise and have no
  effect. The report is only showing the set of rows and columns, they 
  have no inherent order, so the placement of the null columns doesn't
  matter between left or right.
  */