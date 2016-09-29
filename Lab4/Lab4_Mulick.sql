--Lab 4, coded by Danny Mulick in the Fall of 2016

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


/*
Danny Mulick
Lab 4
Database Management
Fall 2016

8. Tell me about check constraints: What are they? What are they good for? What’s the advantage of putting that sort of thing inside the database? Make up some examples of good uses of check constraints and some examples of bad uses of check constraints. Explain the differences in your examples and argue your case.
	A.	A check constraint is a limiter that can be placed either on individual column or a table as a whole, which stops the user from inputting values that are against the rules that the programmer sets.
	B.	The constraints are good for maintaining quality of data.
	C.	The advantage of placing a constraint inside your database is that it helps to filter out poor quality data, which in turn makes analyses and synthesis of information easier.
	D.	Good check constraints
		a.	Making sure numbers are integers (Whole numbers)
		b.	Making sure numbers are positive (greater than zero)
		c.	Making sure an input isn’t over a maximum length
	E.	Bad check constraints
		a.	Requiring a user to put hyphens in their phone number
		b.	The required data value is outside the provided set of values
	F.	Explain the differences in your examples and argue your case
		a.	Good constraints
			i.	Integers
				1.	Making sure your numbers are integers is a good constraint because it keeps your data consistent, and helps to reduce math errors from rounding.
			ii.	Positive
				1.	Ensuring that your numbers are positive helps with transactions, as you do not want someone removing a negative amount of money from an account.
			iii.	Max Length
				1.	This constraint helps to keep the size of your database down, as well as keeping the speed of logging in fast.
		b.	Bad constraints
			i.	Hyphens in a phone number
				1.	This is a bad constraint because it requires the user to input a certain format that doesn’t always make sense when read
			ii.	Required value out of range of values
				1.	This is a bad constraint because it is asking the user to input a value that they cannot input

*/
 