#drop trigger

drop trigger if exists ticket_number;

#TRIGGER

/*
------ Issue unique unguessable ticket-numbers ------ 
*/

delimiter //
create trigger ticketnumber
after insert on b_creditcard
for each row
begin 
	update b_passenger p
	set ticket = rand()*100000
	where p.re_id = new.re_id;
end;
// 
delimiter ;