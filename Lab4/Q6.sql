#drop procedures

drop procedure if exists addReservation;
drop procedure if exists addPassenger;
drop procedure if exists addContact;
drop procedure if exists addPayment;

#create reservation on flight
/*
------ Create a reservation on a specific flight ------ 
*/
delimiter //
create procedure addReservation(
								in departure_airport_code varchar(3),
                                in arrival_airport_code varchar(3),
                                in year int,
                                in week int,
                                in day varchar(10),
                                in time time,
                                in number_of_passengers int,
                                out output_reservation_nr int)
begin
  declare fno int;
  declare resno int;
  set fno = NULL;
  
  select fl_id into fno from b_flight A
  where A.week = week
  and A.f_ws_id in (select ws_id from b_weeklyschedule B
					where B.ws_year = year 
						and B.weekday = day 
						and B.departuretime = time
                        and B.ws_ro_id in (select ro_id from b_route C
											where C.depa_ap_id = departure_airport_code
												and C.dest_ap_id = arrival_airport_code));
    if(fno IS NULL)
		then select 'There exist no flight for the given route, date and time' as 'message';
	
    elseif ( number_of_passengers > (calculateFreeSeats(fno)))
		then select 'Flight is fully booked.' as 'Message';
	
    else
		insert into b_reservation(fl_id, no_passengers)
        values (fno, number_of_passengers);
        
        select max(re_id) into resno from b_reservation
        where fno = fl_id and no_passengers = number_of_passengers;
        
        set output_reservation_nr = resno;
    end if;
end;
// 
delimiter ;

#Create Add passenger to a reservation
/*
------ Add passenger to a reservation ------ 
*/
delimiter //

create procedure addPassenger(
								in reservation_nr int, 
                                in passport_number int,
                                in name varchar(30))
begin
	declare nopassenger int;
    declare bookedpassenger int;
    declare ifpaid int;
    set ifpaid = NULL;
    set nopassenger = NULL;
    
    select no_passengers into nopassenger from b_reservation where re_id = reservation_nr;
    select count(re_id) into bookedpassenger from b_passenger where re_id = reservation_nr;
    select count(re_id) into ifpaid from b_creditcard where re_id = reservation_nr;
    
    if(nopassenger IS NULL)
		then select 'The given reservation number does not exist';
	elseif (ifpaid = 1)
		then select 'The booking has already been payed and no futher passengers can be added' as 'message';
	elseif (nopassenger < bookedpassenger)
		then select 'Reservation has reachead maximum number of passengers.' as 'Message';
	else
		insert b_passenger(re_id, name, passport)
        values (reservation_nr, name, passport_number);
	end if;
end;
// 
delimiter ;

#Create Add contact
/*
------ Add contact ------ 
*/
delimiter //
create procedure addContact(
							in reservation_nr int,
                            in passport_number int,
                            in email varchar(30),
                            in phone bigint)
begin
	declare reservationValid int;
    declare passengerValid int;
    set reservationValid = NULL;
    set passengerValid = NULL;

	select count(*) into reservationValid from b_passenger where reservation_nr = re_id;
	select count(*) into passengerValid from b_passenger where passport_number = passport;

	if(reservationValid = 0)
		then select 'The given reservation number does not exist' as 'message';
	elseif(passengerValid = 0)
		then select 'The person is not a passenger of the reservation' as 'message';
	else
		insert into b_contactinfo(re_id, passport, phone, email)
		values (reservation_nr, passport_number, phone, email);
	end if;
end;
// 
delimiter ;

#Create Add a payment
/*
------ Add a payment ------ 
*/
delimiter //
create procedure addPayment(
							in reservation_nr int,
                            in cardholder_name varchar(30),
                            in credit_card_number bigint)
begin
	declare cost double;
    declare flightid int;
    declare contact int;
    declare no_of_passengers int;
    
    select fl_id into flightid from b_reservation where re_id = reservation_nr;
    
    set cost = calculatePrice(flightid);
    
    set flightid = NULL;
    set contact = NULL;
    
    select fl_id into flightid from b_reservation where reservation_nr = re_id;
    select count(*) into contact from b_contactinfo where reservation_nr = re_id;
    
    select no_passengers into no_of_passengers from b_reservation where reservation_nr = re_id;
    
    if(flightid IS NULL)
		then select 'The given reservation number does not exist' as 'message';
	elseif (contact <> 1)
		then select 'The reservation has no contact yet' as 'message';
	elseif ( no_of_passengers > (calculateFreeSeats(flightid)))
		then select 'Flight is fully booked, payment declined.' as 'Message';
	else
		insert into b_creditcard(creditcard, name, amount, re_id)
        values(credit_card_number, cardholder_name, cost, reservation_nr);
	end if;
end;
// 
delimiter ;