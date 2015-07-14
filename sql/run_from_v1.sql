drop table if exists basepop;
drop table if exists ed;
create temporary table basepop (eventid int);
create temporary table ed (eventid int, deckname varchar(100), playername varchar(100), vodurl varchar(255), roundnumber int);

insert into basepop
select
	id
from events t
where 1 = 1
AND t.finished = 1
AND t.startdate > '2015-4-25'
AND t.formattype != 'limited'
AND t.visible = 1
AND t.organiser != 'tcg';

INSERT INTO coverage.coverage_event
	(event_type_id, start_date, end_date, location, organizer_id, format_id, rounds)
SELECT DISTINCT
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
	startdate,
	enddate,
	SUBSTRING_INDEX(t.location,',',1) AS Location,
	CASE
  WHEN t.organiser = 'SCG' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Star City Games')
  WHEN t.organiser = 'GP' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'PT' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'WORLDS' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
  WHEN t.organiser = 'CFB' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Channel Fireball')
  WHEN t.name = 'Super Sunday Series 2014' THEN (SELECT id FROM coverage.coverage_organizer WHERE name = 'Wizards of the Coast')
END,
	f.id,
	15
FROM events t
JOIN basepop b
	ON b.eventid = t.id
left join coverage.coverage_format f
	on f.name = t.formattype
;

INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round1deck1, round1player1, round1, 1 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round1deck2, round1player2, round1, 1 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round2deck1, round2player1, round2, 2 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round2deck2, round2player2, round2, 2 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round3deck1, round3player1, round3, 3 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round3deck2, round3player2, round3, 3 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round4deck1, round4player1, round4, 4 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round4deck2, round4player2, round4, 4 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round5deck1, round5player1, round5, 5 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round5deck2, round5player2, round5, 5 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round6deck1, round6player1, round6, 6 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round6deck2, round6player2, round6, 6 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round7deck1, round7player1, round7, 7 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round7deck2, round7player2, round7, 7 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round8deck1, round8player1, round8, 8 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round8deck2, round8player2, round8, 8 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round9deck1, round9player1, round9, 9 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round9deck2, round9player2, round9, 9 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round10deck1, round10player1, round10, 10 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round10deck2, round10player2, round10, 10 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round11deck1, round11player1, round11, 11 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round11deck2, round11player2, round11, 11 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round12deck1, round12player1, round12, 12 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round12deck2, round12player2, round12, 12 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round13deck1, round13player1, round13, 13 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round13deck2, round13player2, round13, 13 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round14deck1, round14player1, round14, 14 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round14deck2, round14player2, round14, 14 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round15deck1, round15player1, round15, 15 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round15deck2, round15player2, round15, 15 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round16deck1, round16player1, round16, 16 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round16deck2, round16player2, round16, 16 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round17deck1, round17player1, round17, 17 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round17deck2, round17player2, round17, 17 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round18deck1, round18player1, round18, 18 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round18deck2, round18player2, round18, 18 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round19deck1, round19player1, round19, 19 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round19deck2, round19player2, round19, 19 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round20deck1, round20player1, round20, 20 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, round20deck2, round20player2, round20, 20 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, quarterdeck1, quarterplayer1, quarter, 98 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, quarterdeck2, quarterplayer2, quarter, 98 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, semideck1, semiplayer1, semi, 99 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, semideck2, semiplayer2, semi, 99 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, finaldeck1, finalplayer1, final, 100 FROM basepop b JOIN events e ON e.id = b.eventid;
INSERT INTO ed (eventid, deckname, playername, vodurl, roundnumber) SELECT e.id, finaldeck2, finalplayer2, final, 100 FROM basepop b JOIN events e ON e.id = b.eventid;

DELETE FROM ed WHERE deckname ='';


INSERT INTO coverage.coverage_player
	(first_name, last_name)
SELECT DISTINCT
	SUBSTRING_INDEX(ed.playername,' ',1),
	SUBSTRING_INDEX(ed.playername,' ',-1)
FROM ed
LEFT JOIN coverage.coverage_player cp
	on cp.first_name = SUBSTRING_INDEX(ed.playername,' ',1)
	and cp.last_name = SUBSTRING_INDEX(ed.playername,' ',-1)
WHERE 1 = 1
AND cp.id is null
;

INSERT INTO coverage.coverage_deck
	(name, archetype_id, player_id, format_id, color_id, event_id)
SELECT DISTINCT
	ed.deckname,
	case
	  when ed.deckname = 'goryo''s vengeance' then (select id from coverage.coverage_archetype where name = 'reanimator')
	    when ed.deckname = 'vengevine' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%devotion%' then (select id from coverage.coverage_archetype where name = 'Devotion')
  when ed.deckname like '%control%' then (select id from coverage.coverage_archetype where name = 'Control')
  when ed.deckname like '%slivers%' then (select id from coverage.coverage_archetype where name = 'Slivers')
  when ed.deckname like '%monsters%' then (select id from coverage.coverage_archetype where name = 'Monsters')
  when ed.deckname like '%aggro%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%midrange%' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%delver%' then (select id from coverage.coverage_archetype where name = 'Delver')
  when ed.deckname like '%sneak and show%' then (select id from coverage.coverage_archetype where name = 'Sneak and Show')
  when ed.deckname like '%punishing%' then (select id from coverage.coverage_archetype where name = 'Punishing Fire')
  when ed.deckname like '%walkers%' then (select id from coverage.coverage_archetype where name = 'Super Friends')
  when ed.deckname like '%burn%' then (select id from coverage.coverage_archetype where name = 'Burn')
  when ed.deckname like '%tron%' then (select id from coverage.coverage_archetype where name = 'Tron')
  when ed.deckname like '%affinity%' then (select id from coverage.coverage_archetype where name = 'Affinity')
  when ed.deckname like '%twin%' then (select id from coverage.coverage_archetype where name = 'Twin')
  when ed.deckname like '%loam%' then (select id from coverage.coverage_archetype where name = 'Loam')
  when ed.deckname like '%pod%' then (select id from coverage.coverage_archetype where name = 'Pod')
  when ed.deckname like '%infect%' then (select id from coverage.coverage_archetype where name = 'Infect')
  when ed.deckname like '%leylines%' then (select id from coverage.coverage_archetype where name = 'Leylines')
  when ed.deckname like '%miracles%' then (select id from coverage.coverage_archetype where name = 'Miracles')
  when ed.deckname like '%rabble%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%constellation%' then (select id from coverage.coverage_archetype where name = 'Constellation')
  when ed.deckname like '%generator%' then (select id from coverage.coverage_archetype where name = 'Generator Servant')
  when ed.deckname like '%brave%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%shardless%' then (select id from coverage.coverage_archetype where name = 'Shardless')
  when ed.deckname like '%high tide%' then (select id from coverage.coverage_archetype where name = 'High Tide')
  when ed.deckname like '%artifacts%' then (select id from coverage.coverage_archetype where name = 'Artifacts')
  when ed.deckname like '%mud%' then (select id from coverage.coverage_archetype where name = 'Metalworker')
  when ed.deckname like '%death and taxes%' then (select id from coverage.coverage_archetype where name = 'Death and Taxes')
  when ed.deckname like '%stoneblade%' then (select id from coverage.coverage_archetype where name = 'Stoneblade')
  when ed.deckname like '%tokens%' then (select id from coverage.coverage_archetype where name = 'Tokens')
  when ed.deckname like '%elves%' then (select id from coverage.coverage_archetype where name = 'Elves')
  when ed.deckname like '%chord%' then (select id from coverage.coverage_archetype where name = 'Chord')
  when ed.deckname like '%omnitell%' then (select id from coverage.coverage_archetype where name = 'Omni-Tell')
  when ed.deckname like '%omni-tell%' then (select id from coverage.coverage_archetype where name = 'Omni-Tell')
  when ed.deckname like '%planeswalkers%' then (select id from coverage.coverage_archetype where name = 'Super Friends')
  when ed.deckname like '%ascendancy%' then (select id from coverage.coverage_archetype where name = 'Ascendancy')
  when ed.deckname like '%ascendency%' then (select id from coverage.coverage_archetype where name = 'Ascendancy')
  when ed.deckname like '%whip%' then (select id from coverage.coverage_archetype where name = 'Whip')
  when ed.deckname like '%sligh%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%merfolk%' then (select id from coverage.coverage_archetype where name = 'Merfolk')
  when ed.deckname like '%tendrils%' then (select id from coverage.coverage_archetype where name = 'Ad Nauseum')
  when ed.deckname like '%deathblade%' then (select id from coverage.coverage_archetype where name = 'Deathblade')
  when ed.deckname like '%storm%' then (select id from coverage.coverage_archetype where name = 'Storm')
  when ed.deckname like '%lands%' then (select id from coverage.coverage_archetype where name = 'Lands')
  when ed.deckname like '%painter%' then (select id from coverage.coverage_archetype where name = 'Painter')
  when ed.deckname like '%riddle of lightning%' then (select id from coverage.coverage_archetype where name = 'Riddle')
  when ed.deckname like '%heroic%' then (select id from coverage.coverage_archetype where name = 'Heroic')
  when ed.deckname like '%nic fit%' then (select id from coverage.coverage_archetype where name = 'Veteran Explorer')
  when ed.deckname like '%delves%' then (select id from coverage.coverage_archetype where name = 'Delver')
  when ed.deckname like '%sultai delve%' then (select id from coverage.coverage_archetype where name = 'Delver')
  when ed.deckname = 'jund' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname = 'junk' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname = 'abzan' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname = 'wilt-leaf abzan' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname = 'rock' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%maze''s%' then (select id from coverage.coverage_archetype where name = 'Maze''s End')
  when ed.deckname like '%stockpile%' then (select id from coverage.coverage_archetype where name = 'Stockpile')
  when ed.deckname like '%dragons%' then (select id from coverage.coverage_archetype where name = 'Dragons')
  when ed.deckname like '%megamorph%' then (select id from coverage.coverage_archetype where name = 'Megamorph')
  when ed.deckname like '% morph%' then (select id from coverage.coverage_archetype where name = 'Morph')
  when ed.deckname like '%reanimator%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
  when ed.deckname like '%maverick%' then (select id from coverage.coverage_archetype where name = 'Zenith')
  when ed.deckname = 'sultai' then (select id from coverage.coverage_archetype where name = 'Control')
  when ed.deckname = 'bant' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%dredge%' then (select id from coverage.coverage_archetype where name = 'Dredge')
  when ed.deckname like '%12-post%' then (select id from coverage.coverage_archetype where name = 'Cloudpost')
  when ed.deckname like '%cloudpost%' then (select id from coverage.coverage_archetype where name = 'Cloudpost')
  when ed.deckname like '%moggcatcher%' then (select id from coverage.coverage_archetype where name = 'Goblins')
  when ed.deckname like '%token%' then (select id from coverage.coverage_archetype where name = 'Tokens')
  when ed.deckname like '%Oops All%' then (select id from coverage.coverage_archetype where name = 'All Spells')
  when ed.deckname like '%boggle%' then (select id from coverage.coverage_archetype where name = 'Hexproof')
  when ed.deckname like '%scapeshift%' then (select id from coverage.coverage_archetype where name = 'Scapeshift')
  when ed.deckname like '%through the breach%' then (select id from coverage.coverage_archetype where name = 'Breach')
  when ed.deckname like '%mono-red cruise%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%amulet bloom%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
  when ed.deckname like '%soulflayer%' then (select id from coverage.coverage_archetype where name = 'Soulflayer')
  when ed.deckname like '%chromanti-flayer%' then (select id from coverage.coverage_archetype where name = 'Soulflayer')
  when ed.deckname like '%prison%' then (select id from coverage.coverage_archetype where name = 'Prison')
  when ed.deckname like '%pirson%' then (select id from coverage.coverage_archetype where name = 'Prison')
  when ed.deckname like '%ramp%' then (select id from coverage.coverage_archetype where name = 'Ramp')
  when ed.deckname like '%tinfins%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
  when ed.deckname like '%tin fins%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
  when ed.deckname like '%frankenstein%' then (select id from coverage.coverage_archetype where name = 'Reanimator')
  when ed.deckname like '%manifest%' then (select id from coverage.coverage_archetype where name = 'Manifest')
  when ed.deckname like '%gifts%' then (select id from coverage.coverage_archetype where name = 'Gifts')
  when ed.deckname like '%living end%' then (select id from coverage.coverage_archetype where name = 'Living End')
  when ed.deckname like '%temur moon%' then (select id from coverage.coverage_archetype where name = 'Moon')
  when ed.deckname like '%deathcloud%' then (select id from coverage.coverage_archetype where name = 'Deathcloud')
  when ed.deckname like '%weenie%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%Atarka Abzan%' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%atarka red%' then (select id from coverage.coverage_archetype where name = 'Aggro')
  when ed.deckname like '%collected company%' then (select id from coverage.coverage_archetype where name = 'Collected Company')
  when ed.deckname like '%collective company%' then (select id from coverage.coverage_archetype where name = 'collected company')
  when ed.deckname like '%dargons%' then (select id from coverage.coverage_archetype where name = 'dragons')
  when ed.deckname like '% rock%' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%Aluren%' then (select id from coverage.coverage_archetype where name = 'Aluren')
  when ed.deckname like '%ojutai bant%' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%ojutai%' then (select id from coverage.coverage_archetype where name = 'midrange')
  when ed.deckname like '%dragonlord jeskai%' then (select id from coverage.coverage_archetype where name = 'midrange')
  when ed.deckname like '%rg bees%' then (select id from coverage.coverage_archetype where name = 'Midrange')
  when ed.deckname like '%4-color soul%' then (select id from coverage.coverage_archetype where name = 'Soul of Theros')
  when ed.deckname like '%goblins%' then (select id from coverage.coverage_archetype where name = 'Goblins')
  when ed.deckname like '%Thopter Foundry%' then (select id from coverage.coverage_archetype where name = 'Thopter Sword')
  when ed.deckname like '%cloud vine%' then (select id from coverage.coverage_archetype where name = 'Cloud Vine')
  when ed.deckname like '%faeries%' then (select id from coverage.coverage_archetype where name = 'Faeries')
  when ed.deckname like '%Zoo%' then (select id from coverage.coverage_archetype where name = 'Zoo')
  when ed.deckname like '%amulet of vigor%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
  when ed.deckname like '%amulet combo%' then (select id from coverage.coverage_archetype where name = 'Amulet Bloom')
  when ed.deckname like '%shackles%' then (select id from coverage.coverage_archetype where name = 'Schackles')
  when ed.deckname like '%Martyr of Sands%' then (select id from coverage.coverage_archetype where name = 'Sands')
  when ed.deckname like '%food chain%' then (select id from coverage.coverage_archetype where name = 'Food Chain')
  when ed.deckname like '%minotaurs%' then (select id from coverage.coverage_archetype where name = 'Minotaurs')
  when ed.deckname like '%soldiers%' then (select id from coverage.coverage_archetype where name = 'Soldiers')
  when ed.deckname like '%humans%' then (select id from coverage.coverage_archetype where name = 'Humans')
  when ed.deckname like '%hatebears%' then (select id from coverage.coverage_archetype where name = 'Hatebears')
  when ed.deckname like '%company%' then (select id from coverage.coverage_archetype where name = 'collected company')
  when ed.deckname like '%chromantiflayer%' then (select id from coverage.coverage_archetype where name = 'soulflayer')

  when ed.deckname like '%nauseam%' then (select id from coverage.coverage_archetype where name = 'ad nauseum')
  when ed.deckname like '%grixis pyromancer%' then (select id from coverage.coverage_archetype where name = 'delver')
  when ed.deckname like '%ghostway%' then (select id from coverage.coverage_archetype where name = 'ghostway')
  when ed.deckname like '%formation%' then (select id from coverage.coverage_archetype where name = 'formation')
  when ed.deckname like '%warriors%' then (select id from coverage.coverage_archetype where name = 'warriors')
end as archetype_id,
cp.id,
f.id,
case
  when ed.deckname like '%zoo%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname = 'ad Nauseam' then (select id from coverage.coverage_color where name = 'grixis')
  when ed.deckname like '%ghostway%' then (select id from coverage.coverage_color where name = 'abzan')
  when ed.deckname like '%goblins%' then (select id from coverage.coverage_color where name = 'mono-red')
  when ed.deckname like '%painter%' then (select id from coverage.coverage_color where name = 'colorless')
  when ed.deckname like '%miracles v2%' then (select id from coverage.coverage_color where name = 'azorius')
  when ed.deckname like '%zoo%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname like '%vengevine%' then (select id from coverage.coverage_color where name = 'golgari')
when ed.deckname = 'goryo''s vengeance' then (select id from coverage.coverage_color where name = 'jund')
	  when ed.deckname = 'Collective Company' then (select id from coverage.coverage_color where name = 'selesnya')
  when ed.deckname like '%mono-white%' then (select id from coverage.coverage_color where name = 'mono-white')
  when ed.deckname like '%mono-blue%' then (select id from coverage.coverage_color where name = 'mono-blue')
  when ed.deckname like '%mono-black%' then (select id from coverage.coverage_color where name = 'mono-black')
  when ed.deckname like '%mono-red%' then (select id from coverage.coverage_color where name = 'mono-red')
  when ed.deckname like '%mono-green%' then (select id from coverage.coverage_color where name = 'mono-green')
  when ed.deckname like '%esper%' then (select id from coverage.coverage_color where name = 'esper')
  when ed.deckname like '%grixis%' then (select id from coverage.coverage_color where name = 'grixis')
  when ed.deckname like '%jund%' then (select id from coverage.coverage_color where name = 'jund')
  when ed.deckname like '%bant%' then (select id from coverage.coverage_color where name = 'bant')
  when ed.deckname like '%abzan%' then (select id from coverage.coverage_color where name = 'abzan')
  when ed.deckname like '%temur%' then (select id from coverage.coverage_color where name = 'temur')
  when ed.deckname like '%jeskai%' then (select id from coverage.coverage_color where name = 'jeskai')
  when ed.deckname like '%sultai%' then (select id from coverage.coverage_color where name = 'sultai')
  when ed.deckname like '%slivers%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname like '%gw %' then (select id from coverage.coverage_color where name = 'Selesnya')
  when ed.deckname like '%bw %' then (select id from coverage.coverage_color where name = 'Orzhov')
  when ed.deckname like '%death and taxes%' then (select id from coverage.coverage_color where name = 'Selesnya')
  when ed.deckname like '%sneak and show%' then (select id from coverage.coverage_color where name = 'Izzet')
  when ed.deckname like '%gb %' then (select id from coverage.coverage_color where name = 'Golgari')
  when ed.deckname like '%rw %' then (select id from coverage.coverage_color where name = 'Boros')
  when ed.deckname like '%junk%' then (select id from coverage.coverage_color where name = 'Abzan')
  when ed.deckname like '%uw %' then (select id from coverage.coverage_color where name = 'Azorius')
  when ed.deckname like '%affinity%' then (select id from coverage.coverage_color where name = 'colorless')
  when ed.deckname like '%melira%' then (select id from coverage.coverage_color where name = 'abzan')
  when ed.deckname like '%splinter twin%' then (select id from coverage.coverage_color where name = 'izzet')
  when ed.deckname like '%wr %' then (select id from coverage.coverage_color where name = 'Boros')
  when ed.deckname like '%loam%' then (select id from coverage.coverage_color where name = 'jund')
  when ed.deckname like '%infect%' then (select id from coverage.coverage_color where name = 'Simic')
  when ed.deckname like '%leylines%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname like '%uwr %' then (select id from coverage.coverage_color where name = 'Jeskai')
  when ed.deckname like '%omni-tell%' then (select id from coverage.coverage_color where name = 'Mono-Blue')
  when ed.deckname like '%burn%' then (select id from coverage.coverage_color where name = 'Mono-Red')
  when ed.deckname like '%maze''s end%' then (select id from coverage.coverage_color where name = 'Five Color')
  when ed.deckname like '%bg %' then (select id from coverage.coverage_color where name = 'Golgari')
  when ed.deckname like '%wb %' then (select id from coverage.coverage_color where name = 'Orzhov')
  when ed.deckname like '%naya%' then (select id from coverage.coverage_color where name = 'naya')
  when ed.deckname like '%rabblemaster red%' then (select id from coverage.coverage_color where name = 'Mono-red')
  when ed.deckname like '%rabble red%' then (select id from coverage.coverage_color where name = 'mono-red')
  when ed.deckname like '%br %' then (select id from coverage.coverage_color where name = 'Rakdos')
  when ed.deckname like '%bu %' then (select id from coverage.coverage_color where name = 'Dimir')
  when ed.deckname like '%high tide%' then (select id from coverage.coverage_color where name = 'mono-blue')
  when ed.deckname like '%ur %' then (select id from coverage.coverage_color where name = 'izzet')
  when ed.deckname like '%rug %%' then (select id from coverage.coverage_color where name = 'temur')
  when ed.deckname like '%elves%' then (select id from coverage.coverage_color where name = 'mono-green')
  when ed.deckname like '%gr %' then (select id from coverage.coverage_color where name = 'Gruul')
  when ed.deckname like '%maverick%' then (select id from coverage.coverage_color where name = 'selesnya')
  when ed.deckname like '%mardu%' then (select id from coverage.coverage_color where name = 'mardu')
  when ed.deckname like '%4-color%' then (select id from coverage.coverage_color where name = 'four color' limit 1)
  when ed.deckname like '%mud%' then (select id from coverage.coverage_color where name = 'colorless')
  when ed.deckname like '%sligh%' then (select id from coverage.coverage_color where name = 'mono-red')
  when ed.deckname like '%tendrils%' then (select id from coverage.coverage_color where name = 'grixis')
  when ed.deckname = 'miracles' then (select id from coverage.coverage_color where name = 'azorius')
  when ed.deckname like '%storm%' then (select id from coverage.coverage_color where name = 'izzet')
  when ed.deckname like '%lands%' then (select id from coverage.coverage_color where name = 'colorless')
  when ed.deckname like '%sidisi%' then (select id from coverage.coverage_color where name = 'sultai')
  when ed.deckname like '%ascendency%' then (select id from coverage.coverage_color where name = 'jeskai')
  when ed.deckname like '%ascendancy%' then (select id from coverage.coverage_color where name = 'jeskai')
  when ed.deckname like '%ub %' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%rg %' then (select id from coverage.coverage_color where name = 'gruul')
  when ed.deckname like '%post%' then (select id from coverage.coverage_color where name = 'colorless')
  when ed.deckname like '%dredge%' then (select id from coverage.coverage_color where name = 'golgari')
  when ed.deckname like '%atarka red%' then (select id from coverage.coverage_color where name = 'gruul')
  when ed.deckname like '%ug %' then (select id from coverage.coverage_color where name = 'simic')
  when ed.deckname like '%flayer%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname like '%omnitell%' then (select id from coverage.coverage_color where name = 'mono-blue')
  when ed.deckname like '%reanimator%' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%merfolk%' then (select id from coverage.coverage_color where name = 'mono-blue')
  when ed.deckname like '%wu %' then (select id from coverage.coverage_color where name = 'azorius')
  when ed.deckname like '%oops all%' then (select id from coverage.coverage_color where name = 'five color')
  when ed.deckname like '%scapeshift%' then (select id from coverage.coverage_color where name = 'temur')
  when ed.deckname like '%tarmo-twin%' then (select id from coverage.coverage_color where name = 'temur')
  when ed.deckname like '%boggle%' then (select id from coverage.coverage_color where name = 'selesnya')
  when ed.deckname like '%through the breach%' then (select id from coverage.coverage_color where name = 'grixis')
  when ed.deckname = 'pod' then (select id from coverage.coverage_color where name = 'abzan')
  when ed.deckname like '%hatebears%' then (select id from coverage.coverage_color where name = 'selesnya')
  when ed.deckname = 'tron' then (select id from coverage.coverage_color where name = 'gruul')
  when ed.deckname like '%amulet%' then (select id from coverage.coverage_color where name = 'simic')
  when ed.deckname like '%martyr of sands%' then (select id from coverage.coverage_color where name = 'mono-white')
  when ed.deckname like '%angel prison%' then (select id from coverage.coverage_color where name = 'mono-white')
  when ed.deckname like '%angel pirson%' then (select id from coverage.coverage_color where name = 'mono-white')
  when ed.deckname like '%tinfins%' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%tin fins%' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%young frankenstein%' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%four-color%' then (select id from coverage.coverage_color where name = 'four color' limit 1)
  when ed.deckname like '%living end%' then (select id from coverage.coverage_color where name = 'jund')
  when ed.deckname like '% rock%' then (select id from coverage.coverage_color where name = 'golgari')
  when ed.deckname = 'rock' then (select id from coverage.coverage_color where  name = 'golgari')
  when ed.deckname like '%weenie%' then (select id from coverage.coverage_color where name = 'mono-white')
  when ed.deckname like '%rb %' then (select id from coverage.coverage_color where name = 'rakdos')
  when ed.deckname like '%collected company%' then (select id from coverage.coverage_color where name = 'abzan')
  when ed.deckname like '%aluren%' then (select id from coverage.coverage_color where name = 'sultai')
  when ed.deckname like '%wg %' then (select id from coverage.coverage_color where name = 'selesnya')
  when ed.deckname like '%gu %' then (select id from coverage.coverage_color where name = 'simic')
  when ed.deckname like '%bu %' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%unwritten%' then (select id from coverage.coverage_color where name = 'mono-green')
  when ed.deckname like '%soldiers%' then (select id from coverage.coverage_color where name = 'boros')
  when ed.deckname like '%%' then (select id from coverage.coverage_color where name = '')
  when ed.deckname like '%food chain%' then (select id from coverage.coverage_color where name = 'simic')
  when ed.deckname like '%deathblade%' then (select id from coverage.coverage_color where name = 'esper')
  when ed.deckname like '%%' then (select id from coverage.coverage_color where name = '')
  when ed.deckname like '%angel pod%' then (select id from coverage.coverage_color where name = 'abzan')

  when ed.deckname like '%faeries%' then (select id from coverage.coverage_color where name = 'dimir')
  when ed.deckname like '%cloud vine%' then (select id from coverage.coverage_color where name = 'sui')
  when ed.deckname like '%thopter foundry%' then (select id from coverage.coverage_color where name = 'azorius')
  when ed.deckname like '%five-color%' then (select id from coverage.coverage_color where name = 'five color')

end as color_id,
	en.id
FROM ed
left join coverage.coverage_player cp
	on cp.first_name = SUBSTRING_INDEX(ed.playername,' ',1)
	and cp.last_name = SUBSTRING_INDEX(ed.playername,' ',-1)
 join events e
	on ed.eventid = e.id
 join coverage.coverage_format f
	on f.name = e.formattype
JOIN coverage.coverage_event en
	ON en.location = SUBSTRING_INDEX(e.location,',',1)
	AND e.startdate = en.start_date
;

drop table if exists subdecks;
create table subdecks (eventid int, round int, decka int, deckb int);
insert into subdecks
	(eventid, round, decka, deckb)
select e.id, ed.roundnumber, max(cd.id) as decka, min(cd.id) as deckb
	from ed
	join events e
		on e.id = ed.eventid
	join coverage.coverage_deck	cd
		on cd.name = ed.deckname
	join coverage.coverage_player cp
		on cp.first_name = SUBSTRING_INDEX(ed.playername,' ',1)
		and cp.last_name = SUBSTRING_INDEX(ed.playername,' ',-1)
		and cp.id = cd.player_id
	join coverage.coverage_event ce
		on ce.id = cd.event_id
		and ce.start_date = e.startdate
	group by e.id, ed.roundnumber;


insert coverage.coverage_match
	(event_id, vod_url, round_number, top8, first_deck_id, second_deck_id)
select DISTINCT
	ce.id,
	ed.vodurl,
	CASE WHEN ed.roundnumber NOT IN (98,99,100) THEN ed.roundnumber END AS round_number,
	CASE
		WHEN ed.roundNumber IN (98) THEN 'Quarter'
		WHEN ed.roundNumber IN (99) THEN 'Semi'
		WHEN ed.roundNumber IN (100) THEN 'Finals'
	END as Top8,
	sub.decka,
	sub.deckb
from ed
join events e
	on e.id = ed.eventid
join coverage.coverage_event ce
	on ce.location = SUBSTRING_INDEX(e.location,',',1)
	and ce.start_date = e.startdate
join subdecks sub
	on sub.eventid = ed.eventid
	and sub.round = ed.roundnumber
;
