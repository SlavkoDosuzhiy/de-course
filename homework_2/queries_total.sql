-- 1:
select 
	c."name" as category, 
	COUNT(f.film_id) as nmbr
from public.category c
	join public.film_category fc on c.category_id = fc.category_id 
	join public.film f on fc.film_id = f.film_id
group by c."name"
order by nmbr desc;

-- 2:
select 
	concat(last_name, ' ', first_name) as actor_name, 
	COUNT(r.rental_id) as rent_nmbr
from public.actor a
	join public.film_actor fa on a.actor_id = fa.actor_id
	join public.inventory i on fa.film_id = i.film_id 
	join public.rental r on i.inventory_id = r.inventory_id
group by actor_name
order by rent_nmbr desc 
limit 10;

--3:
select
	c."name" as category,
	SUM(p.amount) as spent
from public.category c
	join public.film_category fc on c.category_id = fc.category_id 
	join public.inventory i on fc.film_id = i.film_id 
	join public.rental r on i.inventory_id = r.inventory_id
	join public.payment p on r.rental_id = p.rental_id 
group by category
order by spent desc 
limit 1;

-- 4:
select 
	title
from public.film f
	left join public.inventory i on f.film_id = i.film_id 
where i.inventory_id is null;

-- 5:
select
	actor_name,
	category_name,
	nmbr,
	rank_
from (
	select 
		c."name" as category_name,
		concat(last_name, ' ', first_name) as actor_name,
		COUNT(distinct fc.film_id) as nmbr,
		DENSE_RANK() over (partition by c."name" order by COUNT(distinct fc.film_id) desc) as rank_
	from public.actor a
		join public.film_actor fa on a.actor_id = fa.actor_id
		join film_category fc on fa.film_id = fc.film_id
		join category c on fc.category_id = c.category_id 
	group by actor_name, category_name
) t
where 
	lower(category_name) = 'children'
	and rank_ <= 3
order by nmbr DESC;

-- 6:
select 
	city,
	customer_type, 
	COUNT(distinct customer_id) as nmbr
from (
select
    c.city, 
	c2.customer_id,
	case when c2.active = 1 then 'Active'
	else 'Inactive' end as customer_type
from public.city c 
	join public.address a on c.city_id = a.city_id
	join public.customer c2 on a.address_id = c2.address_id 
) t
group by city, customer_type
order by customer_type desc, nmbr DESC;

--7:
with base as (
select 
	c."name" as category_name,
	c3.city,
	round(cast(extract(epoch from return_date - rental_date) / 3600 as numeric), 2) as hours
from public.category c 
	join public.film_category fc on c.category_id = fc.category_id
	join public.inventory i on fc.film_id = i.film_id
	join public.rental r on i.inventory_id = r.inventory_id
	join public.customer c2 on r.customer_id = c2.customer_id 
	join public.address a on c2.address_id = a.address_id 
	join public.city c3 on a.city_id = c3.city_id
)
select category_name, city, hours  from base
where 
	(lower(city) like 'a%' or lower(city) like '%-%') 
	and hours is not null 
order by hours desc;
