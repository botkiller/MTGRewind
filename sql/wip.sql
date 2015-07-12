INSERT INTO coverage_match
  (event_id, vod_url, round_number, is_top8, first_deck_id, second_deck_id)
VALUES  (1,'https://www.youtube.com/watch?v=GQTHE_tJLrs',1,0,1,2)




##FIX INSERT STATEMENT
INSERT INTO coverage_deck
(name, archetype_id, player_id, format_id, color_id)
select
	d1.name,
	case
		when d1.name like '%control%' then 1
		when d1.name like '%aggro%' then 2
		when d1.name like '%megamorph%' then 3
		when d1.name like '%company%' then 4
		when d1.name like '%midrange%' then 5
		when d1.name like 'junk' then 5
		when d1.name like 'jund' then 5
		when d1.name like '%rock' then 5
		when d1.name like '%devotion%' then 6
		when d1.name like '%dragons%' then 7
		when d1.name like '%elves%' then 8
		when d1.name like '%goblins%' then 9
		when d1.name like '%merfolk%' then 10
		when d1.name like '%burn%' then 11
		when d1.name like '%affinity%' then 12
		when d1.name like '%twin%' then 13
		when d1.name like '%tron%' then 14
		when d1.name like '%zoo%' then 15
		when d1.name like '%infect%' then 16
		when d1.name like '%bloom titan%' then 17
		when d1.name like '%amulet%' then 17
		when d1.name like '%living end%' then 18
		when d1.name like '%reanimator%' then 19
		when d1.name like '%scapeshift%' then 20
		when d1.name like '%ghostway%' then 21
		when d1.name like '%dredge%' then 22
		when d1.name like '%delver%' then 23
		when d1.name like '%tendrils%' then 24
		when d1.name like '%stoneblade%' then 25
		when d1.name like '%deathblade%' then 25
		when d1.name like '%show%' then 26
		when d1.name like '%storm%' then 27
		when d1.name like '%taxes%' then 28
		when d1.name like '%monsters%' then 29
		when d1.name like '%omni-tell%' then 30
		when d1.name like '%metalworker%' then 31
		when d1.name like '%depths%' then 32
		when d1.name like '%pox%' then 33
		when d1.name like '%pod%' then 34
		when d1.name like '%punishing%' then 35
		when d1.name like '%miracles%' then 36
		when d1.name like '%loam%' then 37
		when d1.name like '%heroic%' then 38
		when d1.name like '%painter%' then 39
		when d1.name like '%hexproof%' then 40
		when d1.name like '%bogles%' then 40
		when d1.name like '%shardless%' then 41
		when d1.name like '%whip%' then 42
		when d1.name like '%tokens%' then 43
		when d1.name like '%lands%' then 44
		when d1.name like '%ascendancy%' then 45
		when d1.name like '%moon%' then 46
		when d1.name like '%charbelcher%' then 47
		when d1.name like '%belcher%' then 47
		when d1.name like '%constellation%' then 48
		else 9999
	end,
	p.id,
	f.id,
	null
from mtgcoverage_archive.matches m
join mtgcoverage_archive.players p1
	on m.playerida = p1.id
join mtgcoverage_archive.decks d1
	on m.deckida = d1.id
join mtgcoverage_archive.tournament t
	on t.id = m.tournamentid
join coverage.coverage_event e
	on SUBSTRING_INDEX(t.location,',',1) = e.location
	and e.start_date = t.startdate
join coverage.coverage_player p
	on p.first_name =  SUBSTRING_INDEX(p1.name,' ',1)
	AND p.last_name =  SUBSTRING_INDEX(p1.name,' ',-1)
left join coverage.coverage_format f
	on f.name = t.format
where 1 = 1
and d1.name not like '%sealed%'
and d1.name not like '%draft%';



INSERT INTO coverage_deck
(name, archetype_id, player_id, format_id, color_id)
select
	d1.name,
	case
		when d1.name like '%control%' then 1
		when d1.name like '%aggro%' then 2
		when d1.name like '%megamorph%' then 3
		when d1.name like '%company%' then 4
		when d1.name like '%midrange%' then 5
		when d1.name like 'junk' then 5
		when d1.name like 'jund' then 5
		when d1.name like '%rock' then 5
		when d1.name like '%devotion%' then 6
		when d1.name like '%dragons%' then 7
		when d1.name like '%elves%' then 8
		when d1.name like '%goblins%' then 9
		when d1.name like '%merfolk%' then 10
		when d1.name like '%burn%' then 11
		when d1.name like '%affinity%' then 12
		when d1.name like '%twin%' then 13
		when d1.name like '%tron%' then 14
		when d1.name like '%zoo%' then 15
		when d1.name like '%infect%' then 16
		when d1.name like '%bloom titan%' then 17
		when d1.name like '%amulet%' then 17
		when d1.name like '%living end%' then 18
		when d1.name like '%reanimator%' then 19
		when d1.name like '%scapeshift%' then 20
		when d1.name like '%ghostway%' then 21
		when d1.name like '%dredge%' then 22
		when d1.name like '%delver%' then 23
		when d1.name like '%tendrils%' then 24
		when d1.name like '%stoneblade%' then 25
		when d1.name like '%deathblade%' then 25
		when d1.name like '%show%' then 26
		when d1.name like '%storm%' then 27
		when d1.name like '%taxes%' then 28
		when d1.name like '%monsters%' then 29
		when d1.name like '%omni-tell%' then 30
		when d1.name like '%metalworker%' then 31
		when d1.name like '%depths%' then 32
		when d1.name like '%pox%' then 33
		when d1.name like '%pod%' then 34
		when d1.name like '%punishing%' then 35
		when d1.name like '%miracles%' then 36
		when d1.name like '%loam%' then 37
		when d1.name like '%heroic%' then 38
		when d1.name like '%painter%' then 39
		when d1.name like '%hexproof%' then 40
		when d1.name like '%bogles%' then 40
		when d1.name like '%shardless%' then 41
		when d1.name like '%whip%' then 42
		when d1.name like '%tokens%' then 43
		when d1.name like '%lands%' then 44
		when d1.name like '%ascendancy%' then 45
		when d1.name like '%moon%' then 46
		when d1.name like '%charbelcher%' then 47
		when d1.name like '%belcher%' then 47
		when d1.name like '%constellation%' then 48

		else 9999
	end,
	p.id,
	f.id,
	null
from mtgcoverage_archive.matches m
join mtgcoverage_archive.players p1
	on m.playeridb = p1.id
join mtgcoverage_archive.decks d1
	on m.deckidb = d1.id
join mtgcoverage_archive.tournament t
	on t.id = m.tournamentid
join coverage.coverage_event e
	on SUBSTRING_INDEX(t.location,',',1) = e.location
	and e.start_date = t.startdate
join coverage.coverage_player p
	on p.first_name =  SUBSTRING_INDEX(p1.name,' ',1)
	AND p.last_name =  SUBSTRING_INDEX(p1.name,' ',-1)
left join coverage.coverage_format f
	on f.name = t.format
where 1 = 1
and d1.name not like '%sealed%'
and d1.name not like '%draft%';
