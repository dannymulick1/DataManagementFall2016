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
	map           char(4)    not null references maps(mapID),
	winner        char(4)    not null references teams(teamID),
	loser         char(4)    not null references teams(teamID)
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
	lName         char(20)   ,
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
	weaponName    char(20)   ,
	primaryFire   char(150)   not null,
	secondaryFire char(150)   ,
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
create or replace function insertHero(char(4), char(15), char(15), char(20), int, int, int, char(20), role, char(10)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _heroID      char(4)   := $1;
   _heroName    char(15)  := $2;
   _FName       char(15)  := $3;
   _LName       char(20)  := $4;
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

-- stored proc for inputting weapons
create or replace function insertWeapon(char(4), char(4), char(20), char(150), char(150), int, int, int, int) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _weaponID             char(4)    :=$1;
   _heroID               char(4)    :=$2;
   _weaponName           char(20)   :=$3;
   _primaryFire          char(150)   :=$4;
   _secondaryFire        char(150)   :=$5;
   _damage               int        :=$6;
   _DPS                  int        :=$7;
   _heal                 int        :=$8;
   _HPS                  int        :=$9;
begin
   insert into weapons (weaponID, heroID, weaponName, primaryFire, secondaryFire, damage, DPS, heal, HPS)
   values (_weaponID, _heroID, _weaponName, _primaryFire, _secondaryFire, _damage, _DPS, _heal, _HPS);
end;
$$ 
language plpgsql;


--a lot of weapons

select * from insertWeapon('W001','H001','Shuriken',            'Genji looses three deadly throwing stars in quick succession.',                                                                'Alternatively, he can throw three shuriken in a wider spread.',                     28,  84,  0, 0);
select * from insertWeapon('W002','H002','Peacekeeper',         'McCree fires off a round from his trusty six-shooter.',                                                                        'McCree can fan the Peacekeeper’s hammer to swiftly unload the entire cylinder.',    70,  35,  0, 0);
select * from insertWeapon('W003','H003','Rocket Launcher',     'Pharah’s primary weapon launches rockets that deal significant damage in a wide blast radius.',                                '',                                                                                  120, 110, 0, 0);
select * from insertWeapon('W004','H004','Hellfire Shotguns',   'Reaper tears enemies apart with twin shotguns.',                                                                               '',                                                                                  140, 280, 0, 0);
select * from insertWeapon('W005','H005','Heavy Pulse Rifle',   'Soldier: 76’s rifle remains particularly steady while unloading fully-automatic pulse fire.',                                  '',                                                                                  20,  200, 0, 0);
select * from insertWeapon('W006','H006','Machine Pistol',      'Sombra’s fully-automatic machine pistol fires in a short-range spread.',                                                       '',                                                                                  8,   160, 0, 0);
select * from insertWeapon('W007','H007','Pulse Pistols',       'Tracer rapid-fires both of her pistols.',                                                                                      '',                                                                                  12,  240, 0, 0);
select * from insertWeapon('W008','H008','Configuration:Recon', 'In Recon mode, Bastion is fully mobile, outfitted with a submachine gun that fires steady bursts of bullets at medium range.', '',                                                                                  20,  160, 0, 0);
select * from insertWeapon('W009','H009','Storm Bow',           'Hanzo nocks and fires an arrow at his target.', '', , , , );
select * from insertWeapon('W010','H0','','', '', , , , );
select * from insertWeapon('W011','H0','','', '', , , , );
select * from insertWeapon('W012','H0','','', '', , , , );
select * from insertWeapon('W013','H0','','', '', , , , );
select * from insertWeapon('W014','H0','','', '', , , , );
select * from insertWeapon('W015','H0','','', '', , , , );
select * from insertWeapon('W016','H0','','', '', , , , );
select * from insertWeapon('W017','H0','','', '', , , , );
select * from insertWeapon('W018','H0','','', '', , , , );
select * from insertWeapon('W019','H0','','', '', , , , );
select * from insertWeapon('W020','H0','','', '', , , , );
select * from insertWeapon('W021','H0','','', '', , , , );
select * from insertWeapon('W022','H0','','', '', , , , );
select * from insertWeapon('W023','H0','','', '', , , , );
select * from insertWeapon('W024','H0','','', '', , , , );
select * from insertWeapon('W025','H0','','', '', , , , );
select * from insertWeapon('W026','H0','','', '', , , , );
select * from insertWeapon('W027','H0','','', '', , , , );
select * from insertWeapon('W028','H0','','', '', , , , );

select * from weapons;

-- 23 heroes total
select * from insertHero('H001', 'Genji',        'Genji',            'Shimada',             200, 0,   0,   'Japanese',   'Offense', '');
select * from insertHero('H002', 'McCree',       'Jesse',            'Mecree',              200, 0,   0,   'American',   'Offense', '');
select * from insertHero('H003', 'Pharah',       'Fareeha',          'Amari',               200, 0,   0,   'Egyptian',   'Offense', '');
select * from insertHero('H004', 'Reaper',       'Gabriel',          'Reyes',               250, 0,   0,   'American',   'Offense', '');
select * from insertHero('H005', 'Soldier: 76',  'Jack',             'Morrison',            200, 0,   0,   'American',   'Offense', '');
select * from insertHero('H006', 'Sombra',       '',                 '',                    200, 0,   0,   'Mexican',    'Offense', '');
select * from insertHero('H007', 'Tracer',       'Lena',             'Oxford',              150, 0,   0,   'English',    'Offense', '');
select * from insertHero('H008', 'Bastion',      'Siege Automaton',  'E54',                 200, 0,   100, 'Omnic',      'Defense', '');
select * from insertHero('H009', 'Hanzo',        'Hanzo',            'Shimada',             200, 0,   0,   'Japanese',   'Defense', 'Sniper');
select * from insertHero('H010', 'Junkrat',      'Jamison',          'Fawkes',              200, 0,   0,   'Australian', 'Defense', '');
select * from insertHero('H011', 'Mei',          'Mei-Ling',         'Zhou',                250, 0,   0,   'Chinese',    'Defense', '');
select * from insertHero('H012', 'Torbjörn',     'Torbjörn',         'Lindholm',            200, 0,   0,   'Swedish',    'Defense', 'Builder');
select * from insertHero('H013', 'Widowmaker',   'Amélie',           'Lacroix',             200, 0,   0,   'French',     'Defense', 'Sniper');
select * from insertHero('H014', 'D.Va',         'Hana',             'Song',                150, 0,   400, 'Korean',     'Tank',    '');
select * from insertHero('H015', 'Reinhardt',    'Reinhardt',        'Wilhelm',             300, 0,   200, 'German',     'Tank',    '');
select * from insertHero('H016', 'Roadhog',      'Mako',             'Rutledge',            600, 0,   0,   'Australian', 'Tank',    '');
select * from insertHero('H017', 'Winston',      'Winston',          '',                    400, 0,   100, 'Lunarian',   'Tank',    '');
select * from insertHero('H018', 'Zarya',        'Aleksandra',       'Zaryanova',           200, 200, 0,   'Russian',    'Tank',    '');
select * from insertHero('H019', 'Ana',          'Ana',              'Amari',               200, 0,   0,   'Egyptian',   'Support', 'Sniper');
select * from insertHero('H020', 'Lucio',        'Lucio',            'Correia dos Santos',  200, 0,   0,   'Brazilian',  'Support', 'Healer');
select * from insertHero('H021', 'Mercy',        'Angela',           'Ziegler',             200, 0,   0,   'Swiss',      'Support', 'Healer');
select * from insertHero('H022', 'Symmetra',     'Satya',            'Vaswani',             100, 100, 0,   'Indian',     'Support', 'Builder');
select * from insertHero('H023', 'Zenyatta',     'Tekhartha',        'Zenyatta',            50,  150, 0,   'Omnic',      'Support', 'Healer');









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