SET GLOBAL log_bin_trust_function_creators = 1;

#drop functions

drop function if exists calculateFreeSeats;
drop function if exists calculatePrice;

#FUNCTIONS

delimiter //
create function calculateFreeSeats(flightnumber int)
returns int

begin
	declare paid_seats int;
    select count(ticket) into paid_seats from b_passenger
    where re_id in
			(select re_id from b_reservation where fl_id = flightnumber);
	return (40 - paid_seats);
end;
// 
delimiter ;

delimiter //
create function calculatePrice(flightnumber int)
returns double

begin
	declare routeprice double;
    declare weekfactor double;
	declare bookedpassenger int;
	declare profit_factor double;

	select price into routeprice from b_route
	where ro_id = (select ws_ro_id from b_weeklyschedule
					where ws_id = (select f_ws_id from b_flight
									where fl_id = flightnumber));    
	select pricingfactor into weekfactor from b_weekday
	where weekday = (select weekday from b_weeklyschedule
						where ws_id = (select f_ws_id from b_flight
										where fl_id = flightnumber));
	select count(*) into bookedpassenger from b_passenger
	where re_id in (select re_id from b_reservation where fl_id = flightnumber)
		and ticket is not null;
	select profitfactor into profit_factor from b_year
	where year = (select ws_year from b_weeklyschedule
					where ws_id = (select f_ws_id from b_flight
									where fl_id = flightnumber));
    return routeprice * weekfactor * profit_factor * ((bookedpassenger + 1)/40);
    #return profit_factor; For testing
end;
// 
delimiter ;