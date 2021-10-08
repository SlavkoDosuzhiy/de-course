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