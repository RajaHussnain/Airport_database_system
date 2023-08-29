#drop procedures

drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;

delimiter //
create procedure addYear(in year int, in factor double)
begin
  insert into b_year(year, profitfactor)
  values (year, factor);
end;
//
delimiter ;

delimiter //
create procedure addDay(in year int, in day varchar(10), in factor double)
begin
  insert into b_weekday(year, weekday, pricingfactor)
  values (year, day, factor);
end;
//
delimiter ;

delimiter //
create procedure addDestination(in airport_code varchar(3),in name varchar(30),in country varchar(30))
begin
  insert into b_airport(ap_id, city, country)
  values (airport_code, name, country);
end;
//
delimiter ;

delimiter //
create procedure addRoute(
						in airport_code_dept varchar(3),
						in airport_code_dest varchar(3),
						in year int,
                        in routeprice double)
begin
  insert into b_route(depa_ap_id, dest_ap_id, year, price)
  values (airport_code_dept, airport_code_dest, year, routeprice);
end;
//
delimiter ;

delimiter //
create procedure addFlight(
					in departure_airport_code varchar(3),
                    in arrival_airport_code varchar(3),
                    in year int,
                    in day varchar(10),
                    in departure_time time)
begin
  declare m int;
  declare wsid int;
  declare c int default 1;

  select ro_id into m from b_route A
  where departure_airport_code = A.depa_ap_id 
	and arrival_airport_code = A.dest_ap_id
	and A.year = year;

  insert into b_weeklyschedule(departuretime, ws_ro_id, ws_year, weekday)
  values(departure_time, m, year, day);

  select ws_id into wsid from b_weeklyschedule A
  where A.departuretime = departure_time
	and A.ws_ro_id = m
    and A.ws_year = year
    and A.weekday = day;

  while c < 53 do 
  insert into b_flight(f_ws_id, week)
    value(wsid, c);
  set c = c + 1;
  end while;
end;
//
delimiter ;


# Testing
# A
#call addYear(2023, 1);
#select * from b_year;
# B
#call addDay(2023, 'Monday', 18.06);
#select * from b_weekday;
# C
#call addDestination('ARN', 'Stockholm', 'Sweden');
#call addDestination('CPH', 'Copenhagen', 'Denmark');
#select * from b_airport;
#call addRoute('ARN', 'CPH', 2023, 47500); #Error Fixed
#select * from b_route;
#call addFlight('ARN', 'CPH', 2023, 'Monday', '18:06:00');
#select * from b_weeklyschedule;