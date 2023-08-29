# drop all table in order

drop table if exists b_contactinfo;				#contactinfo
drop table if exists b_passenger;				#passenger
drop table if exists b_creditcard;				#payment
drop table if exists b_reservation;				#reservation
drop table if exists b_flight;					#flight
drop table if exists b_weeklyschedule;			#weeklyschedule
drop table if exists b_weekday;					#weekdays
drop table if exists b_route;					#routes
drop table if exists b_airport;					#airport
drop table if exists b_year;					#profitfactor

create table b_airport(
  ap_id varchar(3),
  country varchar(30),
  city varchar(30),

  constraint pk_id
    primary key (ap_id)
);

create table b_route(
  ro_id integer auto_increment,
  depa_ap_id varchar(3),
  dest_ap_id varchar(3),
  year integer,
  price double,

  constraint pk_id
    primary key (ro_id),

  constraint fk_depa_ap_id
    foreign key (depa_ap_id) references b_airport(ap_id),

  constraint fk_dest_ap_id
    foreign key (dest_ap_id) references b_airport(ap_id)
);

create table b_weekday(
  weekday varchar(10),
  pricingfactor double,
  year integer,

  constraint pk_id
    primary key (weekday, year)
);

create table b_weeklyschedule(
  ws_id integer auto_increment,
  ws_ro_id integer,
  ws_year integer,
  weekday varchar(10),
  departuretime time,

  constraint pk_id
    primary key (ws_id),

  constraint fk_weekday
    foreign key (weekday, ws_year) references b_weekday(weekday, year),

  constraint fk_ro_id1
    foreign key (ws_ro_id) references b_route(ro_id)
);

create table b_flight(
  fl_id integer auto_increment,
  f_ws_id integer,
  week integer,
  
  constraint pk_id
    primary key (fl_id),

  constraint fk_ws_id
    foreign key (f_ws_id) references b_weeklyschedule(ws_id)
);

create table b_reservation(
  re_id integer auto_increment,
  fl_id integer, 
  no_passengers integer,

  constraint pk_re_id
    primary key (re_id),

  constraint fk_fl_id
    foreign key (fl_id) references b_flight(fl_id)
);

create table b_passenger(
  passport integer,
  name varchar(30),
  re_id integer,
  ticket integer,

  constraint pk_passport
    primary key (passport, re_id),

  constraint fk_re_id
    foreign key (re_id) references b_reservation(re_id)
);

create table b_contactinfo( 
  re_id integer,
  passport integer, 
  phone bigint,
  email varchar(30),

  constraint pk_passport2
    primary key (passport, re_id),

  constraint fk_passport
    foreign key (passport) references b_passenger(passport),

  constraint fk_re_id1
    foreign key (re_id) references b_reservation(re_id)
);

create table b_creditcard(
  creditcard bigint,
  name varchar(40),
  amount integer,
  re_id integer,

  constraint pk_re_id
    primary key (re_id),

  constraint fk_re_id2
    foreign key (re_id) references b_reservation(re_id)
);

create table b_year(
  year integer,
  profitfactor double,

  constraint pk_year
    primary key (year)
);