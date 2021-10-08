select
	c."name" as category,
	COUNT(f.film_id) as nmbr
from public.category c
	join public.film_category fc on c.category_id = fc.category_id
	join public.film f on fc.film_id = f.film_id
group by c."name"
order by nmbr desc;