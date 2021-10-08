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