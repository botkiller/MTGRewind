drop table if exists tid;
drop table if exists mid;
drop table if exists dpid;
drop table if exists stageground;
drop table if exists subdecks;

create temporary table tid (tournamentid int);
create temporary table mid (tournamentid int, matchid int);
create temporary table dpid (tournamentid int, matchid int, deckid int, playerid int);
create temporary table stageground (tournamentid int, matchid int, roundnumber int, top8 varchar(25), archetype_id int, player_id int, format_id int, color_id int, deckname VARCHAR(50));
create temporary table subdecks (matchid int, decka int, deckb int);


insert into tid
select
	tournament.id
from tournament
where 1 = 1
and datediff(now(), startdate) <= 365
and finished = 1
and organiser not in ('SCV','BOM','CT','TCG','CA')
and format != 'limited'
and visible = 1
order by startdate desc;

#matches
insert into mid
select
	t.tournamentid,
	m.id
from matches m
join tid t
	on t.tournamentid = m.tournamentid
where 1 = 1
and m.format != 'limited'
and m.roundname NOT LIKE '%B%';

#decks
insert into dpid
select
	mid.tournamentid, m.id, d.id, p.id
from mid
join matches m
	on m.id = mid.matchid
join decks d
	on d.id = m.deckida
join players p
	on p.id = m.playerida
where d.name != 'team unified standard';

insert into dpid
select
	mid.tournamentid, m.id, d.id, p.id
from mid
join matches m
	on m.id = mid.matchid
join decks d
	on d.id = m.deckidb
join players p
	on p.id = m.playeridb
where d.name != 'team unified standard';


insert into coverage.coverage_player
	(first_name, last_name)
select DISTINCT
	SUBSTRING_INDEX(p.name,' ',1),
	SUBSTRING_INDEX(p.name,' ',-1)
from dpid base
join mtgcoverage_archive.players p
	on base.playerid = p.id
where 1 = 1;

INSERT INTO coverage.coverage_format_type (name)
VALUES  ('Constructed'),
        ('Limited'),
        ('Mixed');

INSERT INTO coverage.coverage_format (name, format_type_id)
VALUES  ('Standard',(select id from coverage.coverage_format_type where name = 'constructed')),
        ('Modern',(select id from coverage.coverage_format_type where name = 'constructed')),
        ('Legacy',(select id from coverage.coverage_format_type where name = 'constructed')),
        ('Mixed',(select id from coverage.coverage_format_type where name = 'mixed'));

insert into coverage.coverage_archetype
	(name)

select DISTINCT
	case
		when d.name like '%devotion%' then 'Devotion'
		when d.name like '%control%' then 'Control'
		when d.name like '%slivers%' then 'Slivers'
		when d.name like '%monsters%' then 'Monsters'
		when d.name like '%aggro%' then 'Aggro'
		when d.name like '%midrange%' then 'Midrange'
		when d.name like '%delver%' then 'Delver'
		when d.name like '%sneak and show%' then 'Sneak and Show'
		when d.name like '%punishing%' then 'Punishing Fire'
		when d.name like '%walkers%' then 'Super Friends'
		when d.name like '%burn%' then 'Burn'
		when d.name like '%tron%' then 'Tron'
		when d.name like '%affinity%' then 'Affinity'
		when d.name like '%twin%' then 'Twin'
		when d.name like '%loam%' then 'Loam'
		when d.name like '%pod%' then 'Pod'
		when d.name like '%infect%' then 'Infect'
		when d.name like '%leylines%' then 'Leylines'
		when d.name like '%miracles%' then 'Miracles'
		when d.name like '%rabble%' then 'Aggro'
		when d.name like '%constellation%' then 'Constellation'
		when d.name like '%generator%' then 'Generator Servant'
		when d.name like '%brave%' then 'Aggro'
		when d.name like '%shardless%' then 'Shardless'
		when d.name like '%high tide%' then 'High Tide'
		when d.name like '%artifacts%' then 'Artifacts'
		when d.name like '%mud%' then 'Metalworker'
		when d.name like '%death and taxes%' then 'Death and Taxes'
		when d.name like '%stoneblade%' then 'Stoneblade'
		when d.name like '%tokens%' then 'Tokens'
		when d.name like '%elves%' then 'Elves'
		when d.name like '%chord%' then 'Chord'
		when d.name like '%omnitell%' then 'Omni-Tell'
		when d.name like '%omni-tell%' then 'Omni-Tell'
		when d.name like '%planeswalkers%' then 'Super Friends'
		when d.name like '%ascendancy%' then 'Ascendancy'
		when d.name like '%ascendency%' then 'Ascendancy'
		when d.name like '%whip%' then 'Whip'
		when d.name like '%sligh%' then 'Aggro'
		when d.name like '%merfolk%' then 'Merfolk'
		when d.name like '%tendrils%' then 'Ad Nauseum'
		when d.name like '%deathblade%' then 'Deathblade'
		when d.name like '%storm%' then 'Storm'
		when d.name like '%lands%' then 'Lands'
		when d.name like '%painter%' then 'Painter'
		when d.name like '%riddle of lightning%' then 'Riddle'
		when d.name like '%heroic%' then 'Heroic'
		when d.name like '%nic fit%' then 'Veteran Explorer'
		when d.name like '%delves%' then 'Delver'
		when d.name like '%sultai delve%' then 'Delver'
		when d.name = 'jund' then 'Midrange'
		when d.name = 'junk' then 'Midrange'
		when d.name = 'abzan' then 'Midrange'
		when d.name = 'wilt-leaf abzan' then 'Midrange'
		when d.name = 'rock' then 'Midrange'
		when d.name like '%maze''s%' then 'Maze''s End'
		when d.name like '%stockpile%' then 'Stockpile'
		when d.name like '%dragons%' then 'Dragons'
		when d.name like '%megamorph%' then 'Megamorph'
		when d.name like '% morph%' then 'Morph'
		when d.name like '%reanimator%' then 'Reanimator'
		when d.name like '%maverick%' then 'Zenith'
		when d.name = 'sultai' then 'Control'
		when d.name = 'bant' then 'Aggro'
		when d.name like '%dredge%' then 'Dredge'
		when d.name like '%12-post%' then 'Cloudpost'
		when d.name like '%cloudpost%' then 'Cloudpost'
		when d.name like '%moggcatcher%' then 'Goblins'
		when d.name like '%token%' then 'Tokens'
		when d.name like '%Oops All%' then 'All Spells'
		when d.name like '%boggle%' then 'Hexproof'
		when d.name like '%scapeshift%' then 'Scapeshift'
		when d.name like '%through the breach%' then 'Breach'
		when d.name like '%mono-red cruise%' then 'Aggro'
		when d.name like '%amulet bloom%' then 'Amulet Bloom'
		when d.name like '%soulflayer%' then 'Soulflayer'
		when d.name like '%chromanti-flayer%' then 'Soulflayer'
		when d.name like '%prison%' then 'Prison'
		when d.name like '%pirson%' then 'Prison'
		when d.name like '%ramp%' then 'Ramp'
		when d.name like '%tinfins%' then 'Reanimator'
		when d.name like '%tin fins%' then 'Reanimator'
		when d.name like '%frankenstein%' then 'Reanimator'
		when d.name like '%manifest%' then 'Manifest'
		when d.name like '%gifts%' then 'Gifts'
		when d.name like '%living end%' then 'Living End'
		when d.name like '%temur moon%' then 'Moon'
		when d.name like '%deathcloud%' then 'Deathcloud'
		when d.name like '%weenie%' then 'Aggro'
		when d.name like '%Atarka Abzan%' then 'Midrange'
		when d.name like '%atarka red%' then 'Aggro'
		when d.name like '%collected company%' then 'Collected Company'
		when d.name like '% rock%' then 'Midrange'
		when d.name like '%Aluren%' then 'Aluren'
		when d.name like '%ojutai bant%' then 'Midrange'
		when d.name like '%rg bees%' then 'Midrange'
		when d.name like '%4-color soul%' then 'Soul of Theros'
		when d.name like '%goblins%' then 'Goblins'
		when d.name like '%Thopter Foundry%' then 'Thopter Sword'
		when d.name like '%cloud vine%' then 'Cloud Vine'
		when d.name like '%faeries%' then 'Faeries'
		when d.name like '%Zoo%' then 'Zoo'
		when d.name like '%amulet of vigor%' then 'Amulet Bloom'
		when d.name like '%amulet combo%' then 'Amulet Bloom'
		when d.name like '%shackles%' then 'Schackles'
		when d.name like '%Martyr of Sands%' then 'Sands'
		when d.name like '%food chain%' then 'Food Chain'
		when d.name like '%minotaurs%' then 'Minotaurs'
		when d.name like '%soldiers%' then 'Soldiers'
		when d.name like '%humans%' then 'Humans'
		when d.name like '%hatebears%' then 'Hatebears'
	end as translated_deck_archetype
from dpid base
join mtgcoverage_archive.decks d
	on d.id = base.deckid;



INSERT INTO coverage.coverage_event_type (name)
VALUES  ('Grand Prix'),
        ('Pro Tour'),
        ('Star City Games Open Series'),
        ('World Championship'),
        ('Star City Games Invitational'),
        ('World Magic Cup'),
        ('Magic Online Championship'),
        ('Super Sunday Series'),
        ('Star City Games Players Championship');


INSERT INTO coverage.coverage_color (name,is_white,is_blue,is_black,is_red,is_green)
VALUES  ('Mono-White',1,0,0,0,0),
        ('Mono-Blue',0,1,0,0,0),
        ('Mono-Black',0,0,1,0,0),
        ('Mono-Red',0,0,0,1,0),
        ('Mono-Green',0,0,0,0,1),
        ('Selesnya',1,0,0,0,1),
        ('Orzhov',1,0,1,0,0),
        ('Boros',1,0,0,1,0),
        ('Azorius',1,1,0,0,0),
        ('Dimir',0,1,1,0,0),
        ('Rakdos',0,0,1,1,0),
        ('Golgari',0,0,1,0,1),
        ('Izzet',0,1,0,1,0),
        ('Simic',0,1,0,0,1),
        ('Gruul',0,0,0,1,1),
        ('Naya',1,0,0,1,1),
        ('Esper',1,1,1,0,0),
        ('Grixis',0,1,1,1,0),
        ('Jund',0,0,1,1,1),
        ('Bant',1,1,0,0,1),
        ('Abzan',1,0,1,0,1),
        ('Temur',0,1,0,1,1),
        ('Jeskai',1,1,0,1,0),
        ('Mardu',1,0,1,1,0),
        ('Sultai',0,1,1,0,1),
        ('Four Color',0,1,1,1,1),
        ('Four Color',1,0,1,1,1),
        ('Four Color',1,1,0,1,1),
        ('Four Color',1,1,1,0,1),
        ('Four Color',1,1,1,1,0),
        ('Five Color',1,1,1,1,1),
        ('Colorless',0,0,0,0,0);


insert stageground
	(tournamentid, matchid, roundnumber, top8, archetype_id, player_id, format_id, color_id, deckname)
select
	base.tournamentid,
	base.matchid,
	CASE
		WHEN SUBSTRING_INDEX(m.RoundName,' ',-1) != 'Finals' THEN CAST(SUBSTRING_INDEX(m.RoundName,' ',-1) AS UNSIGNED)
	END AS RoundNumber,
	CASE
		WHEN SUBSTRING_INDEX(m.RoundName,' ',-1) = 'Finals' THEN SUBSTRING_INDEX(m.RoundName,' ',1)
	END AS Top8Round,
	case
		when d.name like '%devotion%' then (select id from coverage.coverage_archetype where name = 'Devotion')
		when d.name like '%control%' then (select id from coverage.coverage_archetype where name = 'Control')
		when d.name like '%slivers%' then (select id from coverage.coverage_archetype where name = 'Slivers')
		when d.name like '%monsters%' then (select id from coverage.coverage_archetype where name = 'Monsters')
		when d.name like '%aggro%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%midrange%' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%delver%' then (select id from coverage.coverage_archetype where name = 'Delver')
		when d.name like '%sneak and show%' then (select id from coverage.coverage_archetype where name = 'Sneak and Show')
		when d.name like '%punishing%' then (select id from coverage.coverage_archetype where name = 'Punishing Fire')
		when d.name like '%walkers%' then (select id from coverage.coverage_archetype where name = 'Super Friends')
		when d.name like '%burn%' then (select id from coverage.coverage_archetype where name = 'Burn')
		when d.name like '%tron%' then (select id from coverage.coverage_archetype where name = 'Tron')
		when d.name like '%affinity%' then (select id from coverage.coverage_archetype where name = 'Affinity')
		when d.name like '%twin%' then (select id from coverage.coverage_archetype where name = 'Twin')
		when d.name like '%loam%' then (select id from coverage.coverage_archetype where name = 'Loam')
		when d.name like '%pod%' then (select id from coverage.coverage_archetype where name = 'Pod')
		when d.name like '%infect%' then (select id from coverage.coverage_archetype where name = 'Infect')
		when d.name like '%leylines%' then (select id from coverage.coverage_archetype where name = 'Leylines')
		when d.name like '%miracles%' then (select id from coverage.coverage_archetype where name = 'Miracles')
		when d.name like '%rabble%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%constellation%' then (select id from coverage.coverage_archetype where name = 'Constellation')
		when d.name like '%generator%' then (select id from coverage.coverage_archetype where name = 'Generator Servant')
		when d.name like '%brave%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%shardless%' then (select id from coverage.coverage_archetype where name = 'Shardless')
		when d.name like '%high tide%' then (select id from coverage.coverage_archetype where name = 'High Tide')
		when d.name like '%artifacts%' then (select id from coverage.coverage_archetype where name = 'Artifacts')
		when d.name like '%mud%' then (select id from coverage.coverage_archetype where name = 'Metalworker')
		when d.name like '%death and taxes%' then (select id from coverage.coverage_archetype where name = 'Death and Taxes')
		when d.name like '%stoneblade%' then (select id from coverage.coverage_archetype where name = 'Stoneblade')
		when d.name like '%tokens%' then (select id from coverage.coverage_archetype where name = 'Tokens')
		when d.name like '%elves%' then (select id from coverage.coverage_archetype where name = 'Elves')
		when d.name like '%chord%' then (select id from coverage.coverage_archetype where name = 'Chord')
		when d.name like '%omnitell%' then (select id from coverage.coverage_archetype where name = 'Omni-Tell')
		when d.name like '%omni-tell%' then (select id from coverage.coverage_archetype where name = 'Omni-Tell')
		when d.name like '%planeswalkers%' then (select id from coverage.coverage_archetype where name = 'Super Friends')
		when d.name like '%ascendancy%' then (select id from coverage.coverage_archetype where name = 'Ascendancy')
		when d.name like '%ascendency%' then (select id from coverage.coverage_archetype where name = 'Ascendancy')
		when d.name like '%whip%' then (select id from coverage.coverage_archetype where name = 'Whip')
		when d.name like '%sligh%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%merfolk%' then (select id from coverage.coverage_archetype where name = 'Merfolk')
		when d.name like '%tendrils%' then (select id from coverage.coverage_archetype where name = 'Ad Nauseum')
		when d.name like '%deathblade%' then (select id from coverage.coverage_archetype where name = 'Deathblade')
		when d.name like '%storm%' then (select id from coverage.coverage_archetype where name = 'Storm')
		when d.name like '%lands%' then (select id from coverage.coverage_archetype where name = 'Lands')
		when d.name like '%painter%' then (select id from coverage.coverage_archetype where name = 'Painter')
		when d.name like '%riddle of lightning%' then (select id from coverage.coverage_archetype where name = 'Riddle')
		when d.name like '%heroic%' then (select id from coverage.coverage_archetype where name = 'Heroic')
		when d.name like '%nic fit%' then (select id from coverage.coverage_archetype where name = 'Veteran Explorer')
		when d.name like '%delves%' then (select id from coverage.coverage_archetype where name = 'Delver')
		when d.name like '%sultai delve%' then (select id from coverage.coverage_archetype where name = 'Delver')
		when d.name = 'jund' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name = 'junk' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name = 'abzan' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name = 'wilt-leaf abzan' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name = 'rock' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%maze''s%' then (select id from coverage.coverage_archetype where name = 'Maze''s End')
		when d.name like '%stockpile%' then (select id from coverage.coverage_archetype where name = 'Stockpile')
		when d.name like '%dragons%' then (select id from coverage.coverage_archetype where name = 'Dragons')
		when d.name like '%megamorph%' then (select id from coverage.coverage_archetype where name = 'Megamorph')
		when d.name like '% morph%' then (select id from coverage.coverage_archetype where name = 'Morph')
		when d.name like '%reanimator%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
		when d.name like '%maverick%' then (select id from coverage.coverage_archetype where name = 'Zenith')
		when d.name = 'sultai' then (select id from coverage.coverage_archetype where name = 'Control')
		when d.name = 'bant' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%dredge%' then (select id from coverage.coverage_archetype where name = 'Dredge')
		when d.name like '%12-post%' then (select id from coverage.coverage_archetype where name = 'Cloudpost')
		when d.name like '%cloudpost%' then (select id from coverage.coverage_archetype where name = 'Cloudpost')
		when d.name like '%moggcatcher%' then (select id from coverage.coverage_archetype where name = 'Goblins')
		when d.name like '%token%' then (select id from coverage.coverage_archetype where name = 'Tokens')
		when d.name like '%Oops All%' then (select id from coverage.coverage_archetype where name = 'All Spells')
		when d.name like '%boggle%' then (select id from coverage.coverage_archetype where name = 'Hexproof')
		when d.name like '%scapeshift%' then (select id from coverage.coverage_archetype where name = 'Scapeshift')
		when d.name like '%through the breach%' then (select id from coverage.coverage_archetype where name = 'Breach')
		when d.name like '%mono-red cruise%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%amulet bloom%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
		when d.name like '%soulflayer%' then (select id from coverage.coverage_archetype where name = 'Soulflayer')
		when d.name like '%chromanti-flayer%' then (select id from coverage.coverage_archetype where name = 'Soulflayer')
		when d.name like '%prison%' then (select id from coverage.coverage_archetype where name = 'Prison')
		when d.name like '%pirson%' then (select id from coverage.coverage_archetype where name = 'Prison')
		when d.name like '%ramp%' then (select id from coverage.coverage_archetype where name = 'Ramp')
		when d.name like '%tinfins%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
		when d.name like '%tin fins%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
		when d.name like '%frankenstein%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
		when d.name like '%manifest%' then (select id from coverage.coverage_archetype where name = 'Manifest')
		when d.name like '%gifts%' then (select id from coverage.coverage_archetype where name = 'Gifts')
		when d.name like '%living end%' then (select id from coverage.coverage_archetype where name = 'Living End')
		when d.name like '%temur moon%' then (select id from coverage.coverage_archetype where name = 'Moon')
		when d.name like '%deathcloud%' then (select id from coverage.coverage_archetype where name = 'Deathcloud')
		when d.name like '%weenie%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%Atarka Abzan%' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%atarka red%' then (select id from coverage.coverage_archetype where name = 'Aggro')
		when d.name like '%collected company%' then (select id from coverage.coverage_archetype where name = 'Collected Company')
		when d.name like '% rock%' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%Aluren%' then (select id from coverage.coverage_archetype where name = 'Aluren')
		when d.name like '%ojutai bant%' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%rg bees%' then (select id from coverage.coverage_archetype where name = 'Midrange')
		when d.name like '%4-color soul%' then (select id from coverage.coverage_archetype where name = 'Soul of Theros')
		when d.name like '%goblins%' then (select id from coverage.coverage_archetype where name = 'Goblins')
		when d.name like '%Thopter Foundry%' then (select id from coverage.coverage_archetype where name = 'Thopter Sword')
		when d.name like '%cloud vine%' then (select id from coverage.coverage_archetype where name = 'Cloud Vine')
		when d.name like '%faeries%' then (select id from coverage.coverage_archetype where name = 'Faeries')
		when d.name like '%Zoo%' then (select id from coverage.coverage_archetype where name = 'Zoo')
		when d.name like '%amulet of vigor%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
		when d.name like '%amulet combo%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
		when d.name like '%shackles%' then (select id from coverage.coverage_archetype where name = 'Schackles')
		when d.name like '%Martyr of Sands%' then (select id from coverage.coverage_archetype where name = 'Sands')
		when d.name like '%food chain%' then (select id from coverage.coverage_archetype where name = 'Food Chain')
		when d.name like '%minotaurs%' then (select id from coverage.coverage_archetype where name = 'Minotaurs')
		when d.name like '%soldiers%' then (select id from coverage.coverage_archetype where name = 'Soldiers')
		when d.name like '%humans%' then (select id from coverage.coverage_archetype where name = 'Humans')
		when d.name like '%hatebears%' then (select id from coverage.coverage_archetype where name = 'Hatebears')
	end as translated_deck_archetype,
	cp.id,
	f.id,
	case
		when d.name like '%mono-white%' then (select id from coverage.coverage_color where name = 'mono-white')
		when d.name like '%mono-blue%' then (select id from coverage.coverage_color where name = 'mono-blue')
		when d.name like '%mono-black%' then (select id from coverage.coverage_color where name = 'mono-black')
		when d.name like '%mono-red%' then (select id from coverage.coverage_color where name = 'mono-red')
		when d.name like '%mono-green%' then (select id from coverage.coverage_color where name = 'mono-green')
		when d.name like '%esper%' then (select id from coverage.coverage_color where name = 'esper')
		when d.name like '%grixis%' then (select id from coverage.coverage_color where name = 'grixis')
		when d.name like '%jund%' then (select id from coverage.coverage_color where name = 'jund')
		when d.name like '%bant%' then (select id from coverage.coverage_color where name = 'bant')
		when d.name like '%abzan%' then (select id from coverage.coverage_color where name = 'abzan')
		when d.name like '%temur%' then (select id from coverage.coverage_color where name = 'temur')
		when d.name like '%jeskai%' then (select id from coverage.coverage_color where name = 'jeskai')
		when d.name like '%sultai%' then (select id from coverage.coverage_color where name = 'sultai')
		when d.name like '%slivers%' then (select id from coverage.coverage_color where name = 'five color')
		when d.name like '%gw %' then (select id from coverage.coverage_color where name = 'Selesnya')
		when d.name like '%bw %' then (select id from coverage.coverage_color where name = 'Orzhov')
		when d.name like '%death and taxes%' then (select id from coverage.coverage_color where name = 'Selesnya')
		when d.name like '%sneak and show%' then (select id from coverage.coverage_color where name = 'Izzet')
		when d.name like '%gb %' then (select id from coverage.coverage_color where name = 'Golgari')
		when d.name like '%rw %' then (select id from coverage.coverage_color where name = 'Boros')
		when d.name like '%junk%' then (select id from coverage.coverage_color where name = 'Abzan')
		when d.name like '%uw %' then (select id from coverage.coverage_color where name = 'Azorius')
		when d.name like '%affinity%' then (select id from coverage.coverage_color where name = 'colorless')
		when d.name like '%melira%' then (select id from coverage.coverage_color where name = 'abzan')
		when d.name like '%splinter twin%' then (select id from coverage.coverage_color where name = 'izzet')
		when d.name like '%wr %' then (select id from coverage.coverage_color where name = 'Boros')
		when d.name like '%loam%' then (select id from coverage.coverage_color where name = 'jund')
		when d.name like '%infect%' then (select id from coverage.coverage_color where name = 'Simic')
		when d.name like '%leylines%' then (select id from coverage.coverage_color where name = 'five color')
		when d.name like '%uwr %' then (select id from coverage.coverage_color where name = 'Jeskai')
		when d.name like '%omni-tell%' then (select id from coverage.coverage_color where name = 'Mono-Blue')
		when d.name like '%burn%' then (select id from coverage.coverage_color where name = 'Mono-Red')
		when d.name like '%maze''s end%' then (select id from coverage.coverage_color where name = 'Five Color')
		when d.name like '%bg %' then (select id from coverage.coverage_color where name = 'Golgari')
		when d.name like '%wb %' then (select id from coverage.coverage_color where name = 'Orzhov')
		when d.name like '%naya%' then (select id from coverage.coverage_color where name = 'naya')
		when d.name like '%rabblemaster red%' then (select id from coverage.coverage_color where name = 'Mono-red')
		when d.name like '%rabble red%' then (select id from coverage.coverage_color where name = 'mono-red')
		when d.name like '%br %' then (select id from coverage.coverage_color where name = 'Rakdos')
		when d.name like '%bu %' then (select id from coverage.coverage_color where name = 'Dimir')
		when d.name like '%high tide%' then (select id from coverage.coverage_color where name = 'mono-blue')
		when d.name like '%ur %' then (select id from coverage.coverage_color where name = 'izzet')
		when d.name like '%rug %%' then (select id from coverage.coverage_color where name = 'temur')
		when d.name like '%elves%' then (select id from coverage.coverage_color where name = 'mono-green')
		when d.name like '%gr %' then (select id from coverage.coverage_color where name = 'Gruul')
		when d.name like '%maverick%' then (select id from coverage.coverage_color where name = 'selesnya')
		when d.name like '%mardu%' then (select id from coverage.coverage_color where name = 'mardu')
		when d.name like '%4-color%' then (select id from coverage.coverage_color where name = 'four color' limit 1)
		when d.name like '%mud%' then (select id from coverage.coverage_color where name = 'colorless')
		when d.name like '%sligh%' then (select id from coverage.coverage_color where name = 'mono-red')
		when d.name like '%tendrils%' then (select id from coverage.coverage_color where name = 'grixis')
		when d.name = 'miracles' then (select id from coverage.coverage_color where name = 'azorius')
		when d.name like '%storm%' then (select id from coverage.coverage_color where name = 'izzet')
		when d.name like '%lands%' then (select id from coverage.coverage_color where name = 'colorless')
		when d.name like '%sidisi%' then (select id from coverage.coverage_color where name = 'sultai')
		when d.name like '%ascendency%' then (select id from coverage.coverage_color where name = 'jeskai')
		when d.name like '%ascendancy%' then (select id from coverage.coverage_color where name = 'jeskai')
		when d.name like '%ub %' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%rg %' then (select id from coverage.coverage_color where name = 'gruul')
		when d.name like '%post%' then (select id from coverage.coverage_color where name = 'colorless')
		when d.name like '%dredge%' then (select id from coverage.coverage_color where name = 'golgari')
		when d.name like '%atarka red%' then (select id from coverage.coverage_color where name = 'gruul')
		when d.name like '%ug %' then (select id from coverage.coverage_color where name = 'simic')
		when d.name like '%flayer%' then (select id from coverage.coverage_color where name = 'five color')
		when d.name like '%omnitell%' then (select id from coverage.coverage_color where name = 'mono-blue')
		when d.name like '%reanimator%' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%merfolk%' then (select id from coverage.coverage_color where name = 'mono-blue')
		when d.name like '%wu %' then (select id from coverage.coverage_color where name = 'azorius')
		when d.name like '%oops all%' then (select id from coverage.coverage_color where name = 'five color')
		when d.name like '%scapeshift%' then (select id from coverage.coverage_color where name = 'temur')
		when d.name like '%tarmo-twin%' then (select id from coverage.coverage_color where name = 'temur')
		when d.name like '%boggle%' then (select id from coverage.coverage_color where name = 'selesnya')
		when d.name like '%through the breach%' then (select id from coverage.coverage_color where name = 'grixis')
		when d.name = 'pod' then (select id from coverage.coverage_color where name = 'abzan')
		when d.name like '%hatebears%' then (select id from coverage.coverage_color where name = 'selesnya')
		when d.name = 'tron' then (select id from coverage.coverage_color where name = 'gruul')
		when d.name like '%amulet%' then (select id from coverage.coverage_color where name = 'simic')
		when d.name like '%martyr of sands%' then (select id from coverage.coverage_color where name = 'mono-white')
		when d.name like '%angel prison%' then (select id from coverage.coverage_color where name = 'mono-white')
		when d.name like '%angel pirson%' then (select id from coverage.coverage_color where name = 'mono-white')
		when d.name like '%tinfins%' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%tin fins%' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%young frankenstein%' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%four-color%' then (select id from coverage.coverage_color where name = 'four color' limit 1)
		when d.name like '%living end%' then (select id from coverage.coverage_color where name = 'jund')
		when d.name like '% rock%' then (select id from coverage.coverage_color where name = 'golgari')
		when d.name = 'rock' then (select id from coverage.coverage_color where  name = 'golgari')
		when d.name like '%weenie%' then (select id from coverage.coverage_color where name = 'mono-white')
		when d.name like '%rb %' then (select id from coverage.coverage_color where name = 'rakdos')
		when d.name like '%collected company%' then (select id from coverage.coverage_color where name = 'abzan')
		when d.name like '%aluren%' then (select id from coverage.coverage_color where name = 'sultai')
		when d.name like '%wg %' then (select id from coverage.coverage_color where name = 'selesnya')
		when d.name like '%gu %' then (select id from coverage.coverage_color where name = 'simic')
		when d.name like '%bu %' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%unwritten%' then (select id from coverage.coverage_color where name = 'mono-green')
		when d.name like '%soldiers%' then (select id from coverage.coverage_color where name = 'boros')
		when d.name like '%%' then (select id from coverage.coverage_color where name = '')
		when d.name like '%food chain%' then (select id from coverage.coverage_color where name = 'simic')
		when d.name like '%deathblade%' then (select id from coverage.coverage_color where name = 'esper')
		when d.name like '%%' then (select id from coverage.coverage_color where name = '')
		when d.name like '%angel pod%' then (select id from coverage.coverage_color where name = 'abzan')
		when d.name like '%zoo%' then (select id from coverage.coverage_color where name = 'five color')
		when d.name like '%faeries%' then (select id from coverage.coverage_color where name = 'dimir')
		when d.name like '%cloud vine%' then (select id from coverage.coverage_color where name = 'sui')
		when d.name like '%thopter foundry%' then (select id from coverage.coverage_color where name = 'azorius')
		when d.name like '%five-color%' then (select id from coverage.coverage_color where name = 'five color')
	end as translated_deck_color,
	d.name
from dpid base
join mtgcoverage_archive.decks d
	on d.id = base.deckid
join mtgcoverage_archive.matches m
	on m.id = base.matchid
join mtgcoverage_archive.players p
	on p.id = base.playerid
left join coverage.coverage_player cp
	on cp.first_name = SUBSTRING_INDEX(p.name,' ',1)
	and cp.last_name = SUBSTRING_INDEX(p.name,' ',-1)
left join coverage.coverage_format f
	on f.name = m.format;

INSERT INTO coverage.coverage_organizer
(name)
VALUES 	('Star City Games'),
		('Wizards of the Coast'),
		('Channel Fireball');

INSERT INTO coverage.coverage_event
(event_type_id, start_date, end_date, location, organizer_id, rounds, format_id)
select DISTINCT
	CASE
      WHEN t.Name LIKE '%open%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Open Series')
      WHEN t.Name LIKE '%invitational%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Invitational')
      WHEN t.Name LIKE '%grand prix%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Grand Prix')
      WHEN t.Name LIKE '%pro tour%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Pro Tour')
      WHEN t.Name LIKE '%magic cup%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'World Magic Cup')
      WHEN t.Name LIKE '%world championship%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'World Championship')
      WHEN t.Name LIKE '%magic online championship%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Magic Online Championship')
      WHEN t.Name LIKE '%super sunday%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Super Sunday Series')
      WHEN t.Name LIKE '%starcitygames players%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Players Championship')
END AS EventTypeID,
	t.startdate,
	t.enddate,
	SUBSTRING_INDEX(t.location,',',1) AS Location,
	CASE
  WHEN t.organiser = 'SCG' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Star City Games')
  WHEN t.organiser = 'GP' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'PT' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'WORLDS' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'CFB' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Channel Fireball')
  WHEN t.name = 'Super Sunday Series 2014' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
END,
	15,
	f.id
from stageground base
join mtgcoverage_archive.tournament t
	on t.id = base.tournamentid
left join coverage.coverage_format f
	on f.name = t.format;

INSERT INTO coverage.coverage_deck
  (name, archetype_id, player_id, format_id, color_id)
SELECT DISTINCT
	base.deckname,
	base.archetype_id,
	base.player_id,
	base.format_id,
	base.color_id
FROM stageground base;

INSERT INTO subdecks
	(matchid, decka, deckb)
SELECT DISTINCT
	base.matchid,
	MAX(d.id) AS DeckA,
	MIN(d.id) AS DeckB
FROM stageground base
JOIN coverage.coverage_deck d
	ON d.color_id = base.color_id
	AND d.player_id = base.player_id
	AND d.archetype_id = base.archetype_id
	AND d.name = base.deckname
	AND d.format_id = base.format_id
GROUP BY base.matchid;

INSERT INTO coverage.coverage_match
  (event_id, vod_url, round_number, top8, first_deck_id, second_deck_id)
SELECT DISTINCT
	e.id,
	vod,
	base.roundnumber,
	base.top8,
	subdecks.decka,
	subdecks.deckb
FROM stageground base
JOIN mtgcoverage_archive.matches m
	ON m.id = base.matchid
JOIN mtgcoverage_archive.tournament t
	ON t.id = base.tournamentid
JOIN subdecks
	ON subdecks.matchid = base.matchid
LEFT JOIN coverage.coverage_event e
	ON e.start_date = t.startdate
	AND e.end_date = t.enddate
	AND e.location = SUBSTRING_INDEX(t.location,',',1)
LEFT JOIN coverage.coverage_format f
	ON f.id = e.format_id
WHERE f.name = t.format
ORDER BY e.id, base.roundnumber ASC
