--------------------------------
--      Overwatch Database
--      Design project for
--      Danny Mulick
--      Marist College Database Design Fall 2016
--      Credit due to http://overwatch.gamepedia.com/Overwatch_Wiki for
--          information about heroes
--------------------------------

--drop statements to assist in the building of the db
drop view if exists MostPlayedHeroes;
drop View if exists MostPlayedMaps;
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
	teamNum       int        not null,
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
	teamNum       int        not null,
	playerID      char(4)    not null,
	primary key   (matchID, heroID, teamNum)
);


------------------------------------------------------------------------------------------------------------------------------
--
--Group of stored procedures that allow us to insert data more easily
--
----------------------------------------------------------------------------------------------------------------------------
-- stored procedure used to insert matches into their table
create or replace function insertMatch(char(4), char(4), timestamp, char(4), char(4), char(4)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _matchID       char(4)      :=$1;
   _officialID    char(4)      :=$2;
   _timeOfMatch   timestamp    :=$3;
   _map           char(4)      :=$4;
   _winner        char(4)      :=$5;
   _loser         char(4)      :=$6;
begin
   insert into matches (matchID, officialID, timeOfMatch, map, winner, loser)
   values (_matchID, _officialID, _timeOfMatch, _map, _winner, _loser);
end;
$$ 
language plpgsql;

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

-- stored procedure used to insert heroesintomatches into their table
create or replace function insertHeroesIntoMatches(char(4), char(4), int, char(4)) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _heroID       char(4)  :=$1;
   _matchID      char(4)  :=$2;
   _teamNum      int      :=$3;
   _playerID     char(4)  :=4;
begin
   insert into heroesInMatches (matchID, heroID, teamNum, playerID)
   values (_matchID, _heroID, _teamNum, _playerID);
end;
$$ 
language plpgsql;

-- stored procedure used to insert teamsintomatches into their table
create or replace function insertTeamsIntoMatches(char(4), char(4), int) returns void
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _teamID       char(4)  :=$1;
   _matchID      char(4)  :=$2;
   _teamNum      int      :=$3;
begin
   insert into teamsInMatches (teamID, matchID, teamNum)
   values (_teamID, _matchID, _teamNum);
end;
$$ 
language plpgsql;


------------------------------------------------------------------------------------------------------------------------------
--
-- Stored procedure to return the heroes that are in a match on one team
--
------------------------------------------------------------------------------------------------------------------------------
-- stored procedure used to that returns the total list of heroes that are listed in a match. Used during a trigger later in the program
create or replace function heroesInAMatch(char(4), int, refcursor) returns refcursor
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _matchID      char(4)    :=$1;
   _teamNum      int        :=$2;
   resultset     refcursor  :=$3;
begin
   open resultset for
	select heroID
	  from heroesInMatches as hIM
	 where _matchId = hIM.matchID and _teamNum = hIM.teamNum;
   return resultset;
end;
$$ 
language plpgsql;

-- Stored Proc to show the information of a team's players
create or replace function playersOnATeam(char(4), refcursor) returns refcursor
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _teamID      char(4)    :=$1;
   resultset    refcursor  :=$2;
begin
   open resultset for
	select people.*, teams.*, players.hoursPlayed 
	  from teams
	 inner join players on teams.teamID = players.team
	 inner join people  on players.playerID = people.pid
	 where teams.teamID = _teamID;
   return resultset;
end;
$$ 
language plpgsql;

/*select playersOnATeam('T002', 'results');
fetch all from results;
*/

-- Stored Proc to show the information of an official for a match
--	Say we need to get in touch with the official of a match to consult them or challenge the decision
create or replace function officialInfo(char(4), refcursor) returns refcursor
as 
$$
declare
-- use underscore sign notation to declare variables, helps to recycle names and
--   make easier to remember
   _matchID       char(4)    :=$1;
   resultset      refcursor  :=$2;
begin
   open resultset for
	select m.officialID, o.judgelevel, p.*
	  from matches m
	 inner join officials o on o.officialID = m.officialID
	 inner join people p    on p.pid        = m.officialID
	 where m.matchID = _matchID;
   return resultset;
end;
$$ 
language plpgsql;

select officialInfo('M007', 'results');
fetch all from results;

------------------------------------------------------------------------------------------------------------------------------
--
-- Trigger made to prevent there being more than one of the same hero on the same team during the same match
--
------------------------------------------------------------------------------------------------------------------------------
-- trigger to stop insert into heroesInMatches if that hero already exists on that team
CREATE OR REPLACE FUNCTION oneHero() 
RETURNS trigger AS 
$$
declare
	result char(100);
BEGIN
     if new.heroID in (select heroID from heroesInMatches as h
			where h.matchID = new.matchID and h.teamNum = new.teamNum)
     then
	raise exception 'Sorry, but your hero already exists in that match on that team. Please select another.';
	rollback;
     else
	return new;
     end if;
END;
$$
language plpgsql;

drop trigger if exists oneHero on heroesInMatches;
create trigger oneHero
   before insert 
   on heroesInMatches
   for each row
   execute procedure oneHero();

------------------------------------------------------------------------------------------------------------------------------
--
-- Queries that insert the data into all of our tables
--
------------------------------------------------------------------------------------------------------------------------------
--20 people
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
-- 5 teams
select * from insertTeam('T001', 'Team Liquid', '2015-07-06');
select * from insertTeam('T002', 'TSM',         '2015-07-06');
select * from insertTeam('T003', 'Fnatic',      '2015-07-06');
select * from insertTeam('T004', 'Cloud9',      '2015-08-11');
select * from insertTeam('T005', 'Dignitas',    '2015-11-23');
--3 officials
select * from insertOfficial('P007', 5);
select * from insertOfficial('P020', 2);
select * from insertOfficial('P012', 1);
-- 16 total players
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
--10 total matches
select * from insertMatch('M001','P007','2015-07-15 19:00:00','MP03','T001','T002');
select * from insertMatch('M002','P007','2015-07-15 19:00:00','MP04','T002','T003');
select * from insertMatch('M003','P012','2015-11-30 19:00:00','MP02','T001','T003');
select * from insertMatch('M004','P007','2015-12-01 19:00:00','MP02','T001','T002');
select * from insertMatch('M005','P007','2015-12-12 19:00:00','MP01','T003','T001');
select * from insertMatch('M006','P007','2015-12-20 19:00:00','MP09','T005','T001');
select * from insertMatch('M007','P020','2016-02-15 19:00:00','MP07','T003','T002');
select * from insertMatch('M008','P020','2016-02-20 19:00:00','MP01','T005','T003');
select * from insertMatch('M009','P020','2016-03-02 19:00:00','MP01','T005','T003');
select * from insertMatch('M010','P020','2016-03-03 19:00:00','MP12','T005','T003');
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

--one hero per player on each team in each game; 8 players by 10 games
select * from insertHeroesIntoMatches('H021', 'M001', 1, 'P010');
select * from insertHeroesIntoMatches('H001', 'M001', 1, 'P006');
select * from insertHeroesIntoMatches('H008', 'M001', 1, 'P004');
select * from insertHeroesIntoMatches('H017', 'M001', 1, 'P011');
select * from insertHeroesIntoMatches('H021', 'M001', 2, 'P003');
select * from insertHeroesIntoMatches('H018', 'M001', 2, 'P001');
select * from insertHeroesIntoMatches('H010', 'M001', 2, 'P008');
select * from insertHeroesIntoMatches('H009', 'M001', 2, 'P005');

select * from insertHeroesIntoMatches('H020', 'M002', 1, 'P003');
select * from insertHeroesIntoMatches('H016', 'M002', 1, 'P001');
select * from insertHeroesIntoMatches('H011', 'M002', 1, 'P008');
select * from insertHeroesIntoMatches('H007', 'M002', 1, 'P005');
select * from insertHeroesIntoMatches('H023', 'M002', 2, 'P015');
select * from insertHeroesIntoMatches('H014', 'M002', 2, 'P002');
select * from insertHeroesIntoMatches('H004', 'M002', 2, 'P009');
select * from insertHeroesIntoMatches('H003', 'M002', 2, 'P018');

select * from insertHeroesIntoMatches('H008', 'M003', 1, 'P010');
select * from insertHeroesIntoMatches('H006', 'M003', 1, 'P006');
select * from insertHeroesIntoMatches('H018', 'M003', 1, 'P004');
select * from insertHeroesIntoMatches('H002', 'M003', 1, 'P011');
select * from insertHeroesIntoMatches('H020', 'M003', 2, 'P015');
select * from insertHeroesIntoMatches('H021', 'M003', 2, 'P002');
select * from insertHeroesIntoMatches('H005', 'M003', 2, 'P009');
select * from insertHeroesIntoMatches('H015', 'M003', 2, 'P018');

select * from insertHeroesIntoMatches('H015', 'M004', 1, 'P010');
select * from insertHeroesIntoMatches('H010', 'M004', 1, 'P006');
select * from insertHeroesIntoMatches('H011', 'M004', 1, 'P004');
select * from insertHeroesIntoMatches('H012', 'M004', 1, 'P011');
select * from insertHeroesIntoMatches('H009', 'M004', 2, 'P003');
select * from insertHeroesIntoMatches('H013', 'M004', 2, 'P001');
select * from insertHeroesIntoMatches('H019', 'M004', 2, 'P008');
select * from insertHeroesIntoMatches('H002', 'M004', 2, 'P005');

select * from insertHeroesIntoMatches('H015', 'M005', 1, 'P015');
select * from insertHeroesIntoMatches('H016', 'M005', 1, 'P002');
select * from insertHeroesIntoMatches('H014', 'M005', 1, 'P009');
select * from insertHeroesIntoMatches('H018', 'M005', 1, 'P018');
select * from insertHeroesIntoMatches('H023', 'M005', 2, 'P010');
select * from insertHeroesIntoMatches('H006', 'M005', 2, 'P006');
select * from insertHeroesIntoMatches('H003', 'M005', 2, 'P004');
select * from insertHeroesIntoMatches('H016', 'M005', 2, 'P011');

select * from insertHeroesIntoMatches('H017', 'M006', 1, 'P019');
select * from insertHeroesIntoMatches('H021', 'M006', 1, 'P014');
select * from insertHeroesIntoMatches('H001', 'M006', 1, 'P017');
select * from insertHeroesIntoMatches('H010', 'M006', 1, 'P016');
select * from insertHeroesIntoMatches('H014', 'M006', 2, 'P010');
select * from insertHeroesIntoMatches('H007', 'M006', 2, 'P006');
select * from insertHeroesIntoMatches('H019', 'M006', 2, 'P004');
select * from insertHeroesIntoMatches('H004', 'M006', 2, 'P011');

select * from insertHeroesIntoMatches('H001', 'M007', 1, 'P015');
select * from insertHeroesIntoMatches('H023', 'M007', 1, 'P002');
select * from insertHeroesIntoMatches('H008', 'M007', 1, 'P009');
select * from insertHeroesIntoMatches('H006', 'M007', 1, 'P018');
select * from insertHeroesIntoMatches('H012', 'M007', 2, 'P003');
select * from insertHeroesIntoMatches('H005', 'M007', 2, 'P001');
select * from insertHeroesIntoMatches('H022', 'M007', 2, 'P008');
select * from insertHeroesIntoMatches('H011', 'M007', 2, 'P005');

select * from insertHeroesIntoMatches('H015', 'M008', 1, 'P015');
select * from insertHeroesIntoMatches('H021', 'M008', 1, 'P002');
select * from insertHeroesIntoMatches('H020', 'M008', 1, 'P009');
select * from insertHeroesIntoMatches('H013', 'M008', 1, 'P018');
select * from insertHeroesIntoMatches('H009', 'M008', 2, 'P019');
select * from insertHeroesIntoMatches('H016', 'M008', 2, 'P014');
select * from insertHeroesIntoMatches('H012', 'M008', 2, 'P017');
select * from insertHeroesIntoMatches('H003', 'M008', 2, 'P016');

select * from insertHeroesIntoMatches('H004', 'M009', 1, 'P019');
select * from insertHeroesIntoMatches('H012', 'M009', 1, 'P014');
select * from insertHeroesIntoMatches('H020', 'M009', 1, 'P017');
select * from insertHeroesIntoMatches('H011', 'M009', 1, 'P016');
select * from insertHeroesIntoMatches('H001', 'M009', 2, 'P015');
select * from insertHeroesIntoMatches('H010', 'M009', 2, 'P002');
select * from insertHeroesIntoMatches('H020', 'M009', 2, 'P009');
select * from insertHeroesIntoMatches('H014', 'M009', 2, 'P018');

select * from insertHeroesIntoMatches('H013', 'M010', 1, 'P019');
select * from insertHeroesIntoMatches('H018', 'M010', 1, 'P014');
select * from insertHeroesIntoMatches('H001', 'M010', 1, 'P017');
select * from insertHeroesIntoMatches('H011', 'M010', 1, 'P016');
select * from insertHeroesIntoMatches('H020', 'M010', 2, 'P015');
select * from insertHeroesIntoMatches('H015', 'M010', 2, 'P002');
select * from insertHeroesIntoMatches('H019', 'M010', 2, 'P009');
select * from insertHeroesIntoMatches('H007', 'M010', 2, 'P018');

select * from insertTeamsIntoMatches('T001', 'M001', 1);
select * from insertTeamsIntoMatches('T002', 'M001', 2);

select * from insertTeamsIntoMatches('T002', 'M002', 1);
select * from insertTeamsIntoMatches('T003', 'M002', 2);

select * from insertTeamsIntoMatches('T001', 'M003', 1);
select * from insertTeamsIntoMatches('T003', 'M003', 2);

select * from insertTeamsIntoMatches('T001', 'M004', 1);
select * from insertTeamsIntoMatches('T002', 'M004', 2);

select * from insertTeamsIntoMatches('T003', 'M005', 1);
select * from insertTeamsIntoMatches('T001', 'M005', 2);

select * from insertTeamsIntoMatches('T005', 'M006', 1);
select * from insertTeamsIntoMatches('T001', 'M006', 2);

select * from insertTeamsIntoMatches('T003', 'M007', 1);
select * from insertTeamsIntoMatches('T002', 'M007', 2);

select * from insertTeamsIntoMatches('T003', 'M008', 1);
select * from insertTeamsIntoMatches('T005', 'M008', 2);

select * from insertTeamsIntoMatches('T005', 'M009', 1);
select * from insertTeamsIntoMatches('T003', 'M009', 2);

select * from insertTeamsIntoMatches('T005', 'M010', 1);
select * from insertTeamsIntoMatches('T003', 'M010', 2);


select * from teamsInMatches;
select * from heroesInMatches;
select * from matches;
select * from officials;
select * from people;
select * from teams;
select * from players;
select * from maps;
select * from heroes;


------------------------------------------------------------------------------------------------------------------------------
--
-- Creation of views is listed below, more views to come
--
------------------------------------------------------------------------------------------------------------------------------
--view to show the most commonly played maps and their name/location
create view MostPlayedMaps
as
select mapid, mapname, location, count(*) from matches
 inner join maps on matches.map = maps.mapID
 group by mapID
 order by count desc;

-- select * from MostPlayedMaps;

--showing most played heroes
create view MostPlayedHeroes
as
select h1.heroID, h1.heroName, count(*) as totalMatches from matches as m
 inner join heroesInMatches        as h  on m.matchID = h.matchID
 inner join heroes                 as h1 on h.heroID = h1.heroID
 group by h1.heroID
 order by totalMatches desc;

--select * from MostPlayedHeroes;


----------------------------------------------------------------------------------------
--
--Roles and Security
--
----------------------------------------------------------------------------------------
drop   role   if exists admin;
drop   role   if exists Official;
drop   role   if exists teamManager;
create role   admin;
create role   Official;
create role   teamManager;

-- admin has rights to everything
grant select, insert, update, delete on people          to admin;
grant select, insert, update, delete on players         to admin;
grant select, insert, update, delete on officials       to admin;
grant select, insert, update, delete on teams           to admin;
grant select, insert, update, delete on maps            to admin;
grant select, insert, update, delete on matches         to admin;
grant select, insert, update, delete on teamsInMatches  to admin;
grant select, insert, update, delete on heroes          to admin;
grant select, insert, update, delete on heroesInMatches to admin;

--teamManager has rights to their own team and the table to show they are in that match i.e. signing up for the match
revoke all privileges on people          from teamManager;
revoke all privileges on matches         from teamManager;
revoke all privileges on officials       from teamManager;
revoke all privileges on heroes          from teamManager;
revoke all privileges on heroesInMatches from teamManager;
revoke all privileges on maps            from teamManager;

grant select, insert, update         on teams                    to teamManager;
grant select, update                 on players                  to teamManager;
grant select, insert, update         on teamsInMatches           to teamManager;

--official is able to call a match, and view info on other officials
revoke all privileges on people          from official;
revoke all privileges on players         from official;
revoke all privileges on teams           from official;
revoke all privileges on teamsInMatches  from official;
revoke all privileges on heroes          from official;
revoke all privileges on maps            from official;
revoke all privileges on heroesInMatches from official;

grant select, insert, update on matches  to   official;