--------------------------------
--      OverWatch Database
--      Design project for
--      Danny Mulick
--      Marist College Database Design Fall 2016
--      Credit due to http://overwatch.gamepedia.com/Overwatch_Wiki for
--          information about heroes
--------------------------------

--drop statements to assist in the building of the db

drop table if exists abilities;
drop table if exists weapons;
drop table if exists heroesInMatches;
drop table if exists heroes;
drop table if exists teamsInMatches;
drop table if exists matches;
drop table if exists maps;
drop table if exists officials;
drop table if exists players;
drop table if exists teams;
drop table if exists people;


--create statements for the database's tables
create table people(
	pid           char(4)    primary key,
	fname         char(20)   not null,
	lname         char(20)   not null,
	email         Char(20)   not null,
	battleTag     char(20)   not null
);

create table teams(
	teamID        char(4)    not null primary key,
	teamName      char(30)   not null
);

create table players(
	playerID      char(4)    not null primary key references people(pid),
	hoursPlayed   int        not null,
	team          char(4)    not null references teams(teamID)
);

create table officials(
	officialID    char(4)    not null primary key references people(pid),
	regDate       date       not null
);

create table maps(
	mapID         char(4)    not null primary key,
	mapName       char(20)   not null,
	location      char(20)
);

create table matches(
	matchID       char(4)    not null primary key,
	officialID    char(4)    not null references officials(officialID),
	timeOfMatch   timestamp  not null,
	map           char(4)    not null references maps(mapID)  
);

create table teamsInMatches(
	teamID        char(4)    not null references teams(teamID),
	matchID       char(4)    not null references matches(matchID),
	primary key   (teamID, matchID)
);

--create statement for hero type, as referenced in heroes table
drop type if exists role;
create type role as enum ('Offense', 'Defense', 'Tank', 'Support');

create table heroes(
	heroID        char(4)    not null primary key,
	health        int        not null,
	shields       int        ,
	armor         int        ,
	nationality   char(20)   not null,
	-- role set needs to be made - Offense, Defense, Tank, Support
	role          role       not null,
	-- type is based off the possible subtypes of hero i.e. sniper, healer, builder.
	-- not all heroes can have a type
	heroType      char(10)    
);

create table heroesInMatches(
	matchID       char(4)    not null references matches(matchID),
	heroID        char(4)    not null references heroes(heroID),
	primary key   (matchID, heroID)
);

create table weapons(
	weaponID      char(4)    not null,
	heroID        char(4)    not null references heroes(heroID),
	primaryFire   char(40)   not null,
	secondaryFire char(40)   ,
	damage        int        ,
	DPS           int        ,
	heal          int        ,
	-- HPS is heal per second
	HPS           int        ,
	-- added heroId to primary key incase there is an instance of a hero
	--  receives a weapon from a previous hero
	primary key   (weaponID, heroID)
);

-- creating a new type for the type of ability, ultimate vs basic
drop type if exists abilType;
create type abilType as enum ('Basic', 'Ultimate');


create table abilities(
	abilityID     char(4)    not null,
	heroID        char(4)    not null references heroes(heroID),
	descr         char(50)   not null,
	target        char(15)   not null,
	cooldown      int        not null,
	abilType      abilType   not null,
	damage        int        ,
	DPS           int        ,
	heal          int        ,
	HPS           int        ,
	-- composite key made due to the possibility of two abilities maybe
	--    being given to multiple heroes
	primary key (abilityID, heroID)
);

