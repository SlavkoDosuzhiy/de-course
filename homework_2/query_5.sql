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