#query for number 1
select ordnum, totalusd
from orders;

#query for number 2
select name, city
from agents
where name = 'Smith';

#query for number 3
select pid, name, priceusd
from products
where quantity > 201000;

#query for number 4
Select name, city
from customers
where city = 'Duluth';

#query for number 5
select name
from agents
where city != 'Dallas' 
  and city != 'Duluth';

#query for number 6
select *
from products
where (city != 'Dallas' or city != 'Duluth') and priceusd >= 1.00;

#query for number 7
select *
from orders
where mon = 'feb' or mon = 'mar';

#query for number 8
select *
from orders
where totalusd >= 600;

#query for number 9
select *
from orders
where cid = 'c005';