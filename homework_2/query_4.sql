select
	title
from public.film f
	left join public.inventory i on f.film_id = i.film_id
where i.inventory_id is null;