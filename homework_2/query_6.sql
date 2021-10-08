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