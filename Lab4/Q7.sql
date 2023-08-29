#drop view

drop view if exists allFlights;

#Create view allFlights
/*
------ Create view to see all flights ------ 
*/

create view allFlights(
						departure_city_name,
                        destination_city_name,
						departure_time,
						departure_day,
						departure_week,
						departure_year,
						nr_of_free_seats,
						current_price_per_seat) as
select 
	A1.city,
    A2.city,
	W.departuretime,
	W.weekday,
	F.week,
	W.ws_year,
	calculateFreeSeats(F.fl_id),
	calculatePrice(F.fl_id)
from b_weeklyschedule W, b_flight F, b_route R, b_airport A1, b_airport A2
where W.ws_ro_id = F.f_ws_id
	and W.ws_ro_id = R.ro_id
	and R.depa_ap_id = A1.ap_id
	and R.dest_ap_id = A2.ap_id
order by ws_year, week asc;
