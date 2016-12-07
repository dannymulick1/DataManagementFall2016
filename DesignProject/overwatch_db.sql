--------------------------------
--      OverWatch Database
--      Design project for
--      Danny Mulick
--      Marist College Database Design Fall 2016
--      Credit due to http://overwatch.gamepedia.com/Overwatch_Wiki for
--          information about heroes
--------------------------------

--drop statements to assist in the building of the db

drop table if exists heroesInMatches;
drop table if exists heroes;
drop table if exists teamsInMatches;
drop table if exists matches;
drop table if exists maps;
drop table if exists officials;
drop table if exists players;
drop table if exists teams;
drop table if exists people;

--create statement for hero type, as referenced in heroes table

drop type if exists role cascade;
create type role as enum ('Offense', 'Defense', 'Tank', 'Support');

--create statements for the database's tables
create table people(
	pid           char(4)    primary key,
	fName         char(20)   not null,
	lName         char(20)   not null,
	email         Char(30)   not null,
	battleTag     char(20)   not null,
	regDate       date       not null
);

create table teams(
	teamID        char(4)    not null primary key,
	teamName      char(30)   not null,
	regDate       date       not null
);

create table players(
	playerID      char(4)    not null primary key references people(pid),
	hoursPlayed   int        not null,
	team          char(4)    not null references teams(teamID)
);

create table officials(
	officialID    char(4)    not null primary key references people(pid),
	judgeLevel    int        not null
);

create table maps(
	mapID         char(4)    not null primary key,
	mapName       char(30)   not null,
	location      char(30)
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


-- stored procedure used to insert people into their table
create or replace function insertPerson(char(4), char(20), char(20), char(30), char(20), date) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _pid       char(4)      :=$1;
   _fName     char(20)     :=$2;
   _lName     char(20)     :=$3;
   _email     char(30)     :=$4;
   _battleTag char(20)     :=$5;
   _regDate   date         :=$6;
begin
   insert into people (pid, fName, lName, email, battleTag, regDate)
   values (_pid, _fName, _lName, _email, _battleTag, _regDate);
end;
$$ 
language plpgsql;

select * from insertPerson('P001', 'Mark',      'Hanson',    'mhanson@gmail.com',       'Handson#6364',    '2015-07-06');
select * from insertPerson('P002', 'John',      'Jacobs',    'jj332@gmail.com',         'JayJay#9909',     '2015-07-06');
select * from insertPerson('P003', 'Paul',      'Saunders',  'pauls4@gmail.com',        'pjsalt32#1115',   '2015-07-06');
select * from insertPerson('P004', 'Juli',      'Peters',    'jpeters@gmail.com',       'majorPete#4412',  '2015-07-06');
select * from insertPerson('P005', 'Anna',      'Black',     'blacka@aol.com',          'superNero#6522',  '2015-07-06');
select * from insertPerson('P006', 'Christian', 'Noel',      'noels@gmail.com',         'neverNoel#7776',  '2015-07-06');
select * from insertPerson('P007', 'Alan',      'Labouseur', 'alan@labouseur.com',      'alan#1337',       '2015-07-06');
select * from insertPerson('P008', 'Thomas',    'Famularo',  'tom.fam@marist.edu',      'nPPredator#1100', '2015-07-06');
select * from insertPerson('P009', 'Jack',      'Wilson',    'wileyj@gmail.com',        'KcajWils#1213',   '2015-08-09');
select * from insertPerson('P010', 'Alex',      'Burns',     'burner@aol.com',          'Burny#4445',      '2015-08-10');
select * from insertPerson('P011', 'Lauren',    'Rannet',    'Laurannet@gmail.com',     'Rannit#7472',     '2015-08-16');
select * from insertPerson('P012', 'Peter',     'Parker',    'petep@gmail.com',         'Spooder#3332',    '2015-11-20');
select * from insertPerson('P013', 'Dennis',    'Murray',    'djm@marist.edu',          'DJMaster#4123',   '2015-12-26');
select * from insertPerson('P014', 'Daniel',    'Zhang',     'daniel.zhang@marist.edu', 'zhanged#0012',    '2016-12-30');
select * from insertPerson('P015', 'Gary',      'Amaz',      'amaz@battle.net',         'amaz7#1544',      '2016-01-06');
select * from insertPerson('P016', 'Max',       'Levitt',    'maxlev@gmail.com',        'maxlevel#1412',   '2016-01-08');
select * from insertPerson('P017', 'Carly',     'Rae',       'raecee@gmail.com',        'raycee#7784',     '2016-01-08');
select * from insertPerson('P018', 'Nick',      'Soun',      'nick.soun1@marist.edu',   'souns#9016',      '2016-01-15');
select * from insertPerson('P019', 'Tony',      'Redson',    'redTon@gmail.com',        'redz#2232',       '2016-01-30');
select * from insertPerson('P020', 'Mark',      'Shlep',     'mark.shlep@ualbany.edu',  'shlepper#8745',   '2016-02-09');

-- stored procedure used to insert officials into their table
create or replace function insertOfficial(char(4), int) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _officialID  char(4)   :=$1;
   _judgeLevel  int  :=$2;
begin
   insert into officials (officialID, judgeLevel)
   values (_officialID, _judgeLevel);
end;
$$ 
language plpgsql;

select * from insertOfficial('P007', 5);
select * from insertOfficial('P020', 2);
select * from insertOfficial('P012', 1);


-- stored procedure used to insert teams into their table
create or replace function insertTeam(char(4), char(30), date) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _teamID   char(4)   :=$1;
   _teamName char(30)  :=$2;
   _regDate  date      :=$3;
begin
   insert into teams (teamID, teamName, regDate)
   values (_teamID, _teamName, _regDate);
end;
$$ 
language plpgsql;

select * from insertTeam('T001', 'Team Liquid', '2015-07-06');
select * from insertTeam('T002', 'TSM',         '2015-07-06');
select * from insertTeam('T003', 'Fnatic',      '2015-07-06');
select * from insertTeam('T004', 'Cloud9',      '2015-08-11');
select * from insertTeam('T005', 'Dignitas',    '2015-11-23');

-- stored procedure used to insert players into their table
create or replace function insertPlayer(char(4), int, char(4)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _playerID    char(4)    :=$1;
   _hoursPlayed int        :=$2;
   _team        char(4)    :=$3;
begin
   insert into players (playerID, hoursPlayed, team)
   values (_playerID, _hoursPlayed, _team);
end;
$$ 
language plpgsql;

select * from insertPlayer('P008', 20, 'T002');
select * from insertPlayer('P006', 10, 'T001');
select * from insertPlayer('P001', 10, 'T002');
select * from insertPlayer('P002', 16, 'T003');
select * from insertPlayer('P003', 8, 'T002');
select * from insertPlayer('P005', 7, 'T002');
select * from insertPlayer('P004', 4, 'T001');
select * from insertPlayer('P011', 19, 'T001');
select * from insertPlayer('P015', 22, 'T003');
select * from insertPlayer('P009', 27, 'T003');
select * from insertPlayer('P010', 5, 'T001');
select * from insertPlayer('P018', 16, 'T003');
select * from insertPlayer('P019', 40, 'T005');
select * from insertPlayer('P014', 60, 'T005');
select * from insertPlayer('P017', 45, 'T005');
select * from insertPlayer('P016', 32, 'T005');

-- stored procedure used to insert maps into their table
create or replace function insertMap(char(4), char(30), char(30)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _mapID         char(4)   :=$1;
   _mapName       char(30)  :=$2;
   _location      char(30)  :=$3;
begin
   insert into maps (mapID, mapName, location)
   values (_mapID, _mapName, _location);
end;
$$ 
language plpgsql;

-- 14 total maps currently
select * from insertMap('MP01', 'Hanamura',              'Japan');
select * from insertMap('MP02', 'Temple of Anubis',      'Egypt');
select * from insertMap('MP03', 'Volskaya Industries',   'Russia');
select * from insertMap('MP04', 'Dorado',                'Mexico');
select * from insertMap('MP05', 'Watchpoint: Gibraltar', 'Gibraltar');
select * from insertMap('MP06', 'Route 66',              'United States');
select * from insertMap('MP07', 'Kings Row',             'England');
select * from insertMap('MP08', 'Numbani',               'Western coast of Africa');
select * from insertMap('MP09', 'Hollywood',             'Los Angeles, United States');
select * from insertMap('MP10', 'Eichenwalde',           'Stuttgart, Germany');
select * from insertMap('MP11', 'Nepal',                 'Nepal');
select * from insertMap('MP12', 'Lijang Tower',          'China');
select * from insertMap('MP13', 'Ilios',                 'Greece');
select * from insertMap('MP14', 'Ecopoint: Antarctica',  'Antarctica');



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


select * from teamsInMatches;
select * from heroesInMatches;
select * from matches;

select * from officials;
select * from people;
select * from teams;
select * from players order by playerID asc;
select * from maps;
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