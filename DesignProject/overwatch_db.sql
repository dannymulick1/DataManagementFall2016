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


-- creating a new type for the type of ability, ultimate vs basic
drop type if exists abilType;
create type abilType as enum ('Basic', 'Ultimate');

--create statement for hero type, as referenced in heroes table
drop type if exists role cascade;
create type role as enum ('Offense', 'Defense', 'Tank', 'Support');

--create statements for the database's tables
create table people(
	pid           char(4)    primary key,
	fName         char(20)   not null,
	lName         char(20)   not null,
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

create table heroes(
	heroID        char(4)    not null primary key,
	heroName      char(15)   not null,
	fName         char(15)   ,
	lName         char(15)   ,
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


-- stored procedure used to insert heroes into their table
create or replace function insertHero(char(4), char(15), char(15), char(15), int, int, int, char(20), role, char(10)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _heroID      char(4)   := $1;
   _heroName    char(15)  := $2;
   _FName       char(15)  := $3;
   _LName       char(15)  := $4;
   _health      int       := $5;
   _shields     int       := $6;
   _armor       int       := $7;
   _nationality char(20)  := $8;
   _role        role      := $9;
   _heroType    char(10)  := $10;
begin
   insert into heroes (heroId, heroName, fName, lName, health, shields, armor, nationality, role, heroType)
   values (_heroID, _heroName, _fName, _lName, _health, _shields, _armor, _nationality, _role, _heroType);
end;
$$ 
language plpgsql;

-- 23 heroes total
select * from insertHero('H001', 'Genji',        'Genji',   'Shamada',  200, 0, 0, 'Japanese', 'Offense', '');
select * from insertHero('H002', 'McCree',       'Jesse',   'Mecree',   200, 0, 0, 'American', 'Offense', '');
select * from insertHero('H003', 'Pharah',       'Fareeha', 'Amari',    200, 0, 0, 'Egyptian', 'Offense', '');
select * from insertHero('H004', 'Reaper',       'Gabriel', 'Reyes',    250, 0, 0, 'American', 'Offense', '');
select * from insertHero('H005', 'Soldier: 76',  'Jack',    'Morrison', 200, 0, 0, 'American', 'Offense', '');
select * from insertHero('H006', 'Sombra',       '',        '',         200, 0, 0, 'Mexican',  'Offense', '');
select * from insertHero('H007', 'Tracer',       'Lena',    'Oxford', , , , '', 'Offense', '');
select * from insertHero('H008', '', '', '', , , , '', '', '');
select * from insertHero('H009', '', '', '', , , , '', '', '');
select * from insertHero('H010', '', '', '', , , , '', '', '');
select * from insertHero('H011', '', '', '', , , , '', '', '');
select * from insertHero('H012', '', '', '', , , , '', '', '');
select * from insertHero('H013', '', '', '', , , , '', '', '');
select * from insertHero('H014', '', '', '', , , , '', '', '');
select * from insertHero('H015', '', '', '', , , , '', '', '');
select * from insertHero('H016', '', '', '', , , , '', '', '');
select * from insertHero('H017', '', '', '', , , , '', '', '');
select * from insertHero('H018', '', '', '', , , , '', '', '');
select * from insertHero('H019', '', '', '', , , , '', '', '');
select * from insertHero('H020', '', '', '', , , , '', '', '');
select * from insertHero('H021', '', '', '', , , , '', '', '');
select * from insertHero('H022', '', '', '', , , , '', '', '');
select * from insertHero('H023', '', '', '', , , , '', '', '');


select * from heroes;
/*
Model for functions
create or replace function (int, REFCURSOR) returns refcursor 
as 
$$
declare
   inputCourse int       := $1;
     resultset REFCURSOR := $2;
begin
   open resultset for 
      select prereqnum
        from prerequisites
       where courseNum = inputCourse;
   return resultset;
end;
$$ 
language plpgsql;
*/