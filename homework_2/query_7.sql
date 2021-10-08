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