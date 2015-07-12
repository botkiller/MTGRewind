#DROP DATABASE coverage;
#CREATE DATABASE coverage;

## Run dbsync from manage.py

INSERT INTO coverage.coverage_player (first_name, last_name)
SELECT
  SUBSTRING_INDEX(name,' ',1),
  SUBSTRING_INDEX(name,' ',-1)
FROM mtgcoverage_archive.players
WHERE 1 = 1
AND SUBSTRING_INDEX(name,' ',1) != SUBSTRING_INDEX(name,' ',-1)
AND name NOT LIKE '%/%';

INSERT INTO coverage.coverage_format_type (name)
VALUES  ('Constructed'),
        ('Limited'),
        ('Mixed');

INSERT INTO coverage.coverage_format (name, format_type_id)
VALUES  ('Standard',1),
        ('Modern',1),
        ('Legacy',1),
        ('Mixed',3);

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

INSERT INTO coverage.coverage_archetype (name)
VALUES  ('Control'),      #1
        ('Aggro'),
        ('Megamorph'),
        ('Company'),
        ('Midrange'),     #5
        ('Devotion'),
        ('Dragons'),
        ('Elves'),
        ('Goblins'),
        ('Merfolk'),      #10
        ('Burn'),
        ('Affinity'),
        ('Twin'),
        ('Tron'),
        ('Zoo'),          #15
        ('Infect'),
        ('Bloom Titan'),
        ('Living End'),
        ('Reanimator'),
        ('Scapeshift'),   #20
        ('Ghostway'),
        ('Dredge'),
        ('Delver'),
        ('Ad Nauseum'),
        ('Stoneblade'),   #25
        ('Sneak and Show'),
        ('Storm'),
        ('Death & Taxes'),
        ('Monsters'),
        ('Omni-Tell'),
        ('Metalworker'),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
        (''),
	#monsters
	#omni-tell
	#metalworker
	#dark depths
	#pox
	#birthing pod
	#punishing fire
	#miracles
	#loam
	#heroic
	#painter's servant
	#hexproof
	#shardless agent
	#whip of erebos
	#tokens
	#lands
	#ascendancy
	#blood moon
	#charbelcher
	#constellation

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

INSERT INTO coverage.coverage_event
(event_type_id, start_date, end_date, location, coverage, rounds, format_id)
SELECT
CASE
      WHEN a.Name LIKE '%open%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Open Series')
      WHEN a.Name LIKE '%invitational%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Invitational')
      WHEN a.Name LIKE '%grand prix%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Grand Prix')
      WHEN a.Name LIKE '%pro tour%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Pro Tour')
      WHEN a.Name LIKE '%magic cup%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'World Magic Cup')
      WHEN a.Name LIKE '%world championship%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'World Championship')
      WHEN a.Name LIKE '%magic online championship%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Magic Online Championship')
      WHEN a.Name LIKE '%super sunday%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Super Sunday Series')
      WHEN a.Name LIKE '%starcitygames players%' THEN (SELECT coverage_event_type.id FROM coverage.coverage_event_type WHERE name = 'Star City Games Players Championship')
END AS EventTypeID,
a.StartDate,
a.EndDate,
SUBSTRING_INDEX(a.location,',',1) AS Location,
CASE
  WHEN a.organiser = 'SCG' THEN 'Star City Games'
  WHEN a.organiser = 'GP' THEN 'Wizards of the Coast'
  WHEN a.organiser = 'PT' THEN 'Wizards of the Coast'
  WHEN a.organiser = 'WORLDS' THEN 'Wizards of the Coast'
  WHEN a.organiser = 'CFB' THEN 'Channel Fireball'
END AS Organizer,
ma.Rounds,
format.id
FROM mtgcoverage_archive.tournament a
LEFT JOIN
(
  SELECT
    m.TournamentID,
    MAX(CAST(SUBSTRING_INDEX(m.RoundName,' ',-1) AS UNSIGNED)) AS Rounds
  FROM mtgcoverage_archive.matches m
  WHERE 1 = 1
  AND SUBSTRING_INDEX(m.RoundName,' ',-1) != 'Finals'
  GROUP BY m.TournamentID
) AS ma
  ON ma.TournamentID = a.ID
LEFT JOIN
(
	SELECT
		f.id, f.name
	FROM coverage.coverage_format f
) AS format
	ON format.name = a.format
WHERE 1 = 1
AND a.organiser IN ('SCG','GP','CFB','PT','WORLDS')
AND ma.Rounds IS NOT NULL
AND a.format != 'limited'
ORDER BY StartDate ASC;
