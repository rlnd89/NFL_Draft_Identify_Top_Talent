USE DataRobot
GO

-- #1 Set correct data types

ALTER TABLE nfl_draft ALTER COLUMN Age int
GO
ALTER TABLE nfl_draft ALTER COLUMN AV int
GO
ALTER TABLE ncaa_team_ratings ALTER COLUMN AP_Rank int
GO
ALTER TABLE ncaa_player_stats ALTER COLUMN G int
GO

-- #2 Check for duplicates
SELECT Player_ID, COUNT(Player_ID)
  FROM [DataRobot].[dbo].[nfl_draft]
  GROUP BY Player_ID
  HAVING COUNT(Player_ID)>1

SELECT Player_ID, COUNT(Player_ID)
  FROM [DataRobot].[dbo].[nfl_combine]
  GROUP BY Player_ID
  HAVING COUNT(Player_ID)>1

SELECT *
FROM nfl_combine
WHERE Player_ID in('DaviBu99','LongDa01')


-- #3 data cleaning

-- set AV 0 where NULL
UPDATE nfl_draft SET AV=0 WHERE AV IS NULL

-- add expected carAV to draft table
ALTER TABLE nfl_draft
ADD Exp_AV float
GO

UPDATE d
SET d.Exp_AV = v.Exp_AV
FROM nfl_draft d
LEFT JOIN Draft_Exp_CarAV_Chart v
ON d.Pick = v.Pk

-- manual corrections based on research
UPDATE nfl_combine
SET 
	NCAA_Link = 'https://www.sports-reference.com/cfb/players/david-long-2.html',
	School = 'West Virginia',
	Player_ID = 'LongDa00'
WHERE Player_ID = 'LongDa01' AND Pos = 'LB'

DELETE FROM nfl_combine
WHERE Player_ID = 'DaviBu99' AND Pos = 'WR'

UPDATE nfl_combine 
	  SET Player_ID = 'JoneRo01', [Round]=2, Pick=38, Team='Tampa Bay Buccaneers'
	  where player='ronald jones'

-- fix links
UPDATE nfl_combine
SET NCAA_Link = REPLACE(NCAA_Link,'https://','http://')
WHERE NCAA_Link IS NOT NULL

UPDATE ncaa_all_americans
SET NCAA_Link = REPLACE(NCAA_Link,'https://','http://')
WHERE NCAA_Link IS NOT NULL

UPDATE ncaa_player_stats
SET NCAA_Link = REPLACE(NCAA_Link,'https://','http://')
WHERE NCAA_Link IS NOT NULL

-- fix team names
SELECT DISTINCT School, count(*)
FROM nfl_combine
group by School
ORDER BY 1

UPDATE nfl_combine
SET School = CASE
	WHEN School = 'East. Michigan' THEN 'Eastern Michigan'
	WHEN School = 'West. Michigan' THEN 'Western Michigan'
	WHEN School = 'Louisiana St' THEN 'LSU'
	WHEN School = 'Boston Col.' THEN 'Boston College'
	WHEN School = 'Mississippi' THEN 'Ole Miss'
	WHEN School = 'Pittsburgh' THEN 'Pitt'
	WHEN School = 'Southern Miss' THEN 'Southern Mississippi'
	WHEN School = 'TCU' THEN 'Texas Christian'
	WHEN School = 'Ala-Birmingham' THEN 'UAB'
	WHEN School = 'Texas-El Paso' THEN 'UTEP'
	WHEN School = 'Texas-San Antonio' THEN 'UTSA'
	WHEN School = 'Bowling Green' THEN 'Bowling Green State'
	WHEN School = 'La-Monroe' THEN 'Louisiana-Monroe'
	WHEN School = 'Central Florida' THEN 'UCF'
	WHEN School = 'Louisiana-Lafayette' THEN 'Louisiana'
	WHEN School = 'Miami' THEN 'Miami (FL)'
END
WHERE School IN('East. Michigan','West. Michigan','Louisiana St','Boston Col.','Mississippi','Pittsburgh','Southern Miss','TCU','Ala-Birmingham','Texas-El Paso','Texas-San Antonio','Bowling Green','La-Monroe','Central Florida','Louisiana-Lafayette','Miami')

UPDATE ncaa_team_offense_defense
SET School = 'BYU'
WHERE School = 'Brigham Young'

UPDATE ncaa_team_ratings
SET School = 'UNLV'
WHERE School = 'Nevada-Las Vegas'

-- fix links
UPDATE nfl_combine
SET NCAA_Link = CASE
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/louis-nix-iii.html' THEN 'http://www.sports-reference.com/cfb/players/louis-nix-iii-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/walter-thurmond-1.html' THEN 'http://www.sports-reference.com/cfb/players/walter-thurmond-iii-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/jj-watt-2.html' THEN 'http://www.sports-reference.com/cfb/players/jj-watt-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/roy-helu-1.html' THEN 'http://www.sports-reference.com/cfb/players/roy-helu-jr-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/donta-hightower-2.html' THEN 'http://www.sports-reference.com/cfb/players/donta-hightower-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/jr-sweezy-2.html' THEN 'http://www.sports-reference.com/cfb/players/jr-sweezy-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/stanley-boom-williams-1.html' THEN 'http://www.sports-reference.com/cfb/players/boom-williams-1.html'
	WHEN NCAA_Link = 'https://www.sports-reference.com/cfb/players/dmitri-flowers-1.html' THEN 'http://www.sports-reference.com/cfb/players/dimitri-flowers-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/byron-cowart-2.html' THEN 'http://www.sports-reference.com/cfb/players/byron-cowart-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/jokobi-meyers-1.html' THEN 'http://www.sports-reference.com/cfb/players/jakobi-meyers-1.html'
	WHEN NCAA_Link = 'http://www.sports-reference.com/cfb/players/derrek-thomas-2.html' THEN 'http://www.sports-reference.com/cfb/players/derrek-thomas-1.html'
END
WHERE NCAA_Link IN(
'http://www.sports-reference.com/cfb/players/louis-nix-iii.html',
'http://www.sports-reference.com/cfb/players/walter-thurmond-1.html',
'http://www.sports-reference.com/cfb/players/jj-watt-2.html',
'http://www.sports-reference.com/cfb/players/roy-helu-1.html',
'http://www.sports-reference.com/cfb/players/donta-hightower-2.html',
'http://www.sports-reference.com/cfb/players/jr-sweezy-2.html',
'http://www.sports-reference.com/cfb/players/louis-nix-iii.html',
'http://www.sports-reference.com/cfb/players/stanley-boom-williams-1.html',
'https://www.sports-reference.com/cfb/players/dmitri-flowers-1.html',
'http://www.sports-reference.com/cfb/players/byron-cowart-2.html',
'http://www.sports-reference.com/cfb/players/jokobi-meyers-1.html',
'http://www.sports-reference.com/cfb/players/derrek-thomas-2.html'
)
-------------------------------------------------------------------------------------------
-- a player can be all american for multiple years in his career
SELECT NCAA_Link, COUNT(NCAA_Link)
  FROM [DataRobot].[dbo].[ncaa_all_americans]
  GROUP BY NCAA_Link
  HAVING COUNT(NCAA_Link)>1
--------------------------------------------------------------------------------------------

-- fix positions	
select distinct pos, count(*)
from nfl_combine
group by pos
order by 1

-- Offensive Lineman
UPDATE c
SET c.Pos = d.Pos
from nfl_combine c
left join nfl_draft d
on c.NCAA_Link=d.NCAA_Link
where c.pos = 'OL'
and d.pos is not null

UPDATE nfl_combine
SET Pos = CASE
WHEN Player = 'Zack Bailey' THEN 'OG'
WHEN Player = 'Alex Bars' THEN 'OG'
WHEN Player = 'Ryan Bates' THEN 'OG'
WHEN Player = 'Beau Benzschawel' THEN 'OG'
WHEN Player = 'Deion Calhoun' THEN 'OG'
WHEN Player = 'Ethan Greenidge' THEN 'OT'
WHEN Player = 'Nate Herbig' THEN 'OG'
WHEN Player = 'Martez Ivey' THEN 'OT'
WHEN Player = 'Fred Johnson' THEN 'OG'
WHEN Player = 'Iosua Opeta' THEN 'OG'
WHEN Player = 'Trevon Tate' THEN 'OG'
WHEN Player = 'Trey Adams' THEN 'OT'
WHEN Player = 'Ben Bartch' THEN 'OT'
WHEN Player = 'Cohl Cabral' THEN 'C'
WHEN Player = 'Trystan Colon-Castillo' THEN 'C'
WHEN Player = 'Yasir Durant' THEN 'OT'
WHEN Player = 'Cordel Iwuagwu' THEN 'OG'
WHEN Player = 'John Molchon' THEN 'OG'
WHEN Player = 'Kyle Murphy' THEN 'OT'
WHEN Player = 'Terence Steele' THEN 'OT'
WHEN Player = 'Alex Taylor' THEN 'OT'
WHEN Player = 'Calvin Throckmorton' THEN 'OT'
WHEN Player = 'Darryl Williams' THEN 'OG'
END
where pos='OL'

UPDATE nfl_combine
SET Pos = CASE
	WHEN Pos = 'T' THEN 'OT'
	WHEN Pos = 'G' THEN 'OG'
	WHEN Pos = 'NT' THEN 'DT'
END
WHERE Pos IN('T','G','NT')

UPDATE nfl_combine 
SET Pos = CASE
WHEN Player_ID = 'FitzMi00' THEN 'FS'
WHEN Player_ID = 'MeekQu00' THEN 'CB'
END
WHERE Player_ID IN('FitzMi00','MeekQu00')

-- Defensive Lineman
UPDATE c
SET c.Pos = d.Pos
FROM nfl_combine c
LEFT JOIN nfl_draft d
ON c.NCAA_Link = d.NCAA_Link
WHERE c.Pos = 'DL'
AND d.Pos IS NOT NULL

UPDATE nfl_combine
SET Pos = CASE
	WHEN Player = 'John Cominsky' THEN 'DE'
	WHEN Player = 'Kevin Givens' THEN 'DT'
	WHEN Player = 'Albert Huggins' THEN 'DT'
	WHEN Player = 'Jonathan Ledbetter' THEN 'DE'
	WHEN Player = 'Khalen Saunders' THEN 'DT'
	WHEN Player = 'Gerald Willis' THEN 'DE'
	WHEN Player = 'Daniel Wise' THEN 'DT'
	WHEN Player = 'Josiah Coatney' THEN 'DT'
	WHEN Player = 'Kendall Coleman' THEN 'DE'
	WHEN Player = 'Darrion Daniels' THEN 'DT'
	WHEN Player = 'LaDarius Hamilton' THEN 'DE'
	WHEN Player = 'Trevon Hill' THEN 'DE'
	WHEN Player = 'Benito Jones' THEN 'DT'
	WHEN Player = 'Chauncey Rivers' THEN 'DE'
	WHEN Player = 'Malcolm Roach' THEN 'DT'
	WHEN Player = 'Qaadir Sheppard' THEN 'OLB'
	WHEN Player = 'Derrek Tuszka' THEN 'OLB'
	WHEN Player = 'Raequan Williams' THEN 'DT'
END
WHERE Pos = 'DL'

-- Trey Walker --> Tracy Walker
UPDATE nfl_combine
SET 
	Player_ID = 'WalkTr01',
	NCAA_Link = 'http://www.sports-reference.com/cfb/players/tracy-walker-1.html',
	Player = 'Tracy Walker',
	Team = 'Detroit Lions',
	[Round] = 3,
	Pick = 82,
	Pos = 'FS'
WHERE Player = 'Trey Walker' AND Pos = 'S' and School = 'Louisiana'

-- Derrick Johnson
UPDATE nfl_combine
SET NCAA_Link = 'http://www.sports-reference.com/cfb/players/derrick-johnson-4.html'
WHERE Player_ID = 'JohnDe24'

-- Safety
SELECT *
from nfl_combine c
where pos = 'S'

UPDATE nfl_combine
SET Pos = CASE
	WHEN Player = 'Marcus Allen' THEN 'SS'
	WHEN Player = 'Troy Apke' THEN 'FS'
	WHEN Player = 'Jessie Bates' THEN 'FS'
	WHEN Player = 'Quin Blanding' THEN 'FS'
	WHEN Player = 'Sean Chandler' THEN 'SS'
	WHEN Player = 'Dane Cruikshank' THEN 'SS'
	WHEN Player = 'Terrell Edmunds' THEN 'SS'
	WHEN Player = 'Deshon Elliott' THEN 'FS'
	WHEN Player = 'Tre Flowers' THEN 'CB'
	WHEN Player = 'Marcell Harris' THEN 'SS'
	WHEN Player = 'Ronnie Harrison' THEN 'SS'
	WHEN Player = 'Godwin Igwebuike' THEN 'SS'
	WHEN Player = 'Natrell Jamerson' THEN 'FS'
	WHEN Player = 'Derwin James' THEN 'SS'
	WHEN Player = 'Joshua Kalu' THEN 'SS'
	WHEN Player = 'Kameron Kelly' THEN 'FS'
	WHEN Player = 'Siran Neal' THEN 'CB'
	WHEN Player = 'Max Redfield' THEN 'FS'
	WHEN Player = 'Justin Reid' THEN 'FS'
	WHEN Player = 'Stephen Roberts' THEN 'SS'
	WHEN Player = 'Dominick Sanders' THEN 'FS'
	WHEN Player = 'Van Smith' THEN 'FS'
	WHEN Player = 'Tracy Walker' THEN 'SS'
	WHEN Player = 'Armani Watts' THEN 'FS'
	WHEN Player = 'Damon Webb' THEN 'FS'
	WHEN Player = 'Kyzir White' THEN 'ILB'
	WHEN Player = 'Jordan Whitehead' THEN 'FS'
	WHEN Player = 'Johnathan Abram' THEN 'SS'
	WHEN Player = 'Nasir Adderley' THEN 'FS'
	WHEN Player = 'Ugo Amadi' THEN 'FS'
	WHEN Player = 'John Battle' THEN 'FS'
	WHEN Player = 'Mike Bell' THEN 'CB'
	WHEN Player = 'Marquise Blair' THEN 'FS'
	WHEN Player = 'Jonathan Crawford' THEN 'SS'
	WHEN Player = 'Lukas Denis' THEN 'FS'
	WHEN Player = 'D''Cota Dixon' THEN 'SS'
	WHEN Player = 'Mike Edwards' THEN 'SS'
	WHEN Player = 'Malik Gant' THEN 'SS'
	WHEN Player = 'Chauncey Gardner-Johnson' THEN 'SS'
	WHEN Player = 'Saquan Hampton' THEN 'FS'
	WHEN Player = 'Will Harris' THEN 'SS'
	WHEN Player = 'Amani Hooker' THEN 'FS'
	WHEN Player = 'Jaquan Johnson' THEN 'FS'
	WHEN Player = 'Mark McLaurin' THEN 'SS'
	WHEN Player = 'Taylor Rapp' THEN 'FS'
	WHEN Player = 'Sheldrick Redwine' THEN 'FS'
	WHEN Player = 'Darnell Savage' THEN 'FS'
	WHEN Player = 'Marvell Tell' THEN 'FS'
	WHEN Player = 'Deionte Thompson' THEN 'FS'
	WHEN Player = 'Juan Thornhill' THEN 'FS'
	WHEN Player = 'Darius West' THEN 'SS'
	WHEN Player = 'Khari Willis' THEN 'SS'
	WHEN Player = 'Donovan Wilson' THEN 'SS'
	WHEN Player = 'Andrew Wingard' THEN 'FS'
	WHEN Player = 'Zedrick Woods' THEN 'FS'
	WHEN Player = 'Evan Worthington' THEN 'SS'
	WHEN Player = 'Julian Blackmon' THEN 'FS'
	WHEN Player = 'Terrell Burgess' THEN 'SS'
	WHEN Player = 'Shyheim Carter' THEN 'FS'
	WHEN Player = 'Jeremy Chinn' THEN 'FS'
	WHEN Player = 'Rodney Clemons' THEN 'SS'
	WHEN Player = 'Kamren Curl' THEN 'FS'
	WHEN Player = 'Ashtyn Davis' THEN 'FS'
	WHEN Player = 'Grant Delpit' THEN 'FS'
	WHEN Player = 'Kyle Dugger' THEN 'FS'
	WHEN Player = 'Jalen Elliott' THEN 'SS'
	WHEN Player = 'Jordan Fuller' THEN 'SS'
	WHEN Player = 'Alohi Gilman' THEN 'FS'
	WHEN Player = 'Jaylinn Hawkins' THEN 'SS'
	WHEN Player = 'Brian Cole II' THEN 'SS'
	WHEN Player = 'Brandon Jones' THEN 'FS'
	WHEN Player = 'Antoine Brooks Jr.' THEN 'SS'
	WHEN Player = 'Antoine Winfield Jr.' THEN 'FS'
	WHEN Player = 'Xavier McKinney' THEN 'SS'
	WHEN Player = 'Josh Metellus' THEN 'FS'
	WHEN Player = 'Chris Miller' THEN 'SS'
	WHEN Player = 'Tanner Muse' THEN 'FS'
	WHEN Player = 'J.R. Reed' THEN 'SS'
	WHEN Player = 'L''Jarius Sneed' THEN 'FS'
	WHEN Player = 'Geno Stone' THEN 'SS'
	WHEN Player = 'Daniel Thomas' THEN 'SS'
	WHEN Player = 'K''Von Wallace' THEN 'SS'
END
WHERE Pos = 'S'

-- EDGE
UPDATE c
SET c.Pos = d.Pos
from nfl_combine c
left join nfl_draft d
on c.NCAA_Link=d.NCAA_Link
where c.pos = 'EDGE'
and d.pos is not null

-- EDGE
UPDATE nfl_combine
SET Pos = CASE
	WHEN Player = 'Ola Adeniyi' THEN 'OLB'
	WHEN Player = 'Dorance Armstrong' THEN 'DE'
	WHEN Player = 'Davin Bellamy' THEN 'OLB'
	WHEN Player = 'Garret Dooley' THEN 'OLB'
	WHEN Player = 'James Hearns' THEN 'OLB'
	WHEN Player = 'Jeff Holland' THEN 'OLB'
	WHEN Player = 'Darius Jackson' THEN 'DE'
	WHEN Player = 'Hercules Mata''afa' THEN 'DT'
	WHEN Player = 'Javon Rolland-Jones' THEN 'OLB'
	WHEN Player = 'Anthony Winbush' THEN 'DE'
	WHEN Player = 'Malik Carney' THEN 'OLB'
	WHEN Player = 'Jamal Davis' THEN 'OLB'
	WHEN Player = 'Carl Granderson' THEN 'DE'
	WHEN Player = 'Porter Gustin' THEN 'DE'
	WHEN Player = 'Cece Jefferson' THEN 'DE'
	WHEN Player = 'Darryl Johnson' THEN 'DE'
	WHEN Player = 'Wyatt Ray' THEN 'DE'
END
WHERE Pos = 'EDGE'

-- Linebacker
SELECT *
from nfl_combine c
where pos = 'LB'

UPDATE nfl_combine
SET Pos = CASE
	WHEN Player = 'Tremaine Edmunds' THEN 'ILB'
	WHEN Player = 'Rashaan Evans' THEN 'ILB'
	WHEN Player = 'Joel Iyiegbuniwe' THEN 'ILB'
	WHEN Player = 'Azeez Al-Shaair' THEN 'OLB'
	WHEN Player = 'Otaro Alaka' THEN 'ILB'
	WHEN Player = 'Dakota Allen' THEN 'ILB'
	WHEN Player = 'Bryson Allen-Williams' THEN 'OLB'
	WHEN Player = 'Jeff Allison' THEN 'ILB'
	WHEN Player = 'Cody Barton' THEN 'OLB'
	WHEN Player = 'Ben Burr-Kirven' THEN 'ILB'
	WHEN Player = 'Devin Bush' THEN 'ILB'
	WHEN Player = 'Blake Cashman' THEN 'OLB'
	WHEN Player = 'Te''von Coney' THEN 'ILB'
	WHEN Player = 'Ryan Connelly' THEN 'ILB'
	WHEN Player = 'Deshaun Davis' THEN 'ILB'
	WHEN Player = 'Tyrel Dodson' THEN 'ILB'
	WHEN Player = 'T.J. Edwards' THEN 'ILB'
	WHEN Player = 'Emeke Egbule' THEN 'OLB'
	WHEN Player = 'Rashan Gary' THEN 'OLB'
	WHEN Player = 'Joe Giles-Harris' THEN 'OLB'
	WHEN Player = 'Andrew Van ginkel' THEN 'OLB'
	WHEN Player = 'Dre Greenlaw' THEN 'OLB'
	WHEN Player = 'Nate Hall' THEN 'OLB'
	WHEN Player = 'Terez Hall' THEN 'OLB'
	WHEN Player = 'Terrill Hanks' THEN 'OLB'
	WHEN Player = 'Chase Hansen' THEN 'ILB'
	WHEN Player = 'Gary Johnson' THEN 'ILB'
	WHEN Player = 'Jordan Jones' THEN 'ILB'
	WHEN Player = 'Kendall Joseph' THEN 'ILB'
	WHEN Player = 'Vosean Joseph' THEN 'OLB'
	WHEN Player = 'Tre Lamar' THEN 'ILB'
	WHEN Player = 'David Long' THEN 'ILB'
	WHEN Player = 'Bobby Okereke' THEN 'OLB'
	WHEN Player = 'Germaine Pratt' THEN 'ILB'
	WHEN Player = 'Cameron Smith' THEN 'ILB'
	WHEN Player = 'Ty Summers' THEN 'OLB'
	WHEN Player = 'Sione Takitaki' THEN 'OLB'
	WHEN Player = 'Jahlani Tavai' THEN 'OLB'
	WHEN Player = 'Drue Tranquill' THEN 'OLB'
	WHEN Player = 'Devin White' THEN 'ILB'
	WHEN Player = 'Mack Wilson' THEN 'ILB'
	WHEN Player = 'Joe Bachie' THEN 'ILB'
	WHEN Player = 'Markus Bailey' THEN 'OLB'
	WHEN Player = 'Zack Baun' THEN 'OLB'
	WHEN Player = 'Francis Bernard' THEN 'ILB'
	WHEN Player = 'Daniel Bituli' THEN 'ILB'
	WHEN Player = 'Shaun Bradley' THEN 'ILB'
	WHEN Player = 'Jordyn Brooks' THEN 'OLB'
	WHEN Player = 'Cameron Brown' THEN 'OLB'
	WHEN Player = 'K''Lavon Chaisson' THEN 'OLB'
	WHEN Player = 'Nick Coe' THEN 'OLB'
	WHEN Player = 'Carter Coughlin' THEN 'OLB'
	WHEN Player = 'Akeem Davis-Gaither' THEN 'ILB'
	WHEN Player = 'Michael Divinity' THEN 'OLB'
	WHEN Player = 'Troy Dye' THEN 'ILB'
	WHEN Player = 'Tipa Galeai' THEN 'OLB'
	WHEN Player = 'Cale Garrett' THEN 'ILB'
	WHEN Player = 'Scoota Harris' THEN 'ILB'
	WHEN Player = 'Malik Harrison' THEN 'OLB'
	WHEN Player = 'Alex Highsmith' THEN 'OLB'
	WHEN Player = 'Khaleke Hudson' THEN 'OLB'
	WHEN Player = 'Anfernee Jennings' THEN 'OLB'
	WHEN Player = 'Clay Johnston' THEN 'OLB'
	WHEN Player = 'Willie Gay Jr.' THEN 'OLB'
	WHEN Player = 'Azur Kamara' THEN 'OLB'
	WHEN Player = 'Terrell Lewis' THEN 'OLB'
	WHEN Player = 'Jordan Mack' THEN 'ILB'
	WHEN Player = 'Kamal Martin' THEN 'OLB'
	WHEN Player = 'Kenneth Murray' THEN 'OLB'
	WHEN Player = 'Dante Olson' THEN 'ILB'
	WHEN Player = 'Jacob Phillips' THEN 'ILB'
	WHEN Player = 'Michael Pinckney' THEN 'OLB'
	WHEN Player = 'Shaquille Quarterman' THEN 'ILB'
	WHEN Player = 'Patrick Queen' THEN 'OLB'
	WHEN Player = 'Chapelle Russell' THEN 'ILB'
	WHEN Player = 'Isaiah Simmons' THEN 'OLB'
	WHEN Player = 'Justin Strnad' THEN 'OLB'
	WHEN Player = 'Darrell Taylor' THEN 'OLB'
	WHEN Player = 'Davion Taylor' THEN 'OLB'
	WHEN Player = 'Casey Toohill' THEN 'OLB'
	WHEN Player = 'Josh Uche' THEN 'OLB'
	WHEN Player = 'Mykal Walker' THEN 'ILB'
	WHEN Player = 'Curtis Weaver' THEN 'DE'
	WHEN Player = 'Evan Weaver' THEN 'ILB'
	WHEN Player = 'Logan Wilson' THEN 'ILB'
	WHEN Player = 'David Woodward' THEN 'ILB'
	WHEN Player = 'Peter Kalambayi' THEN 'OLB'
	WHEN Player = 'Josh Allen' THEN 'OLB'
	WHEN Player = 'Ben Banogu' THEN 'OLB'
	WHEN Player = 'Justin Hollins' THEN 'OLB'
	WHEN Player = 'Christian Miller' THEN 'OLB'
	WHEN Player = 'Jachai Polite' THEN 'OLB'
	WHEN Player = 'D''Andre Walker' THEN 'OLB'
END
WHERE Pos = 'LB'

-- Add Position Groups - OL, OB, QB, Receivers, DL, DB, LB etc.
ALTER TABLE nfl_combine
ADD Pos_Group nvarchar(16)
GO

UPDATE nfl_combine
SET Pos_Group = CASE
	WHEN Pos IN('C', 'OG', 'OT') THEN 'OL'
	WHEN Pos IN('DT', 'DE') THEN 'DL'
	WHEN Pos IN('P','K') THEN 'Kicking'
	WHEN Pos IN('ILB','OLB') THEN 'LB'
	WHEN Pos = 'QB' THEN 'QB'
	WHEN PoS IN('FB','RB') THEN 'OB'
	WHEN PoS IN('CB','SS','FS') THEN 'DB'
	WHEN PoS IN('WR','TE') THEN 'Receivers'
	WHEN PoS = 'LS' THEN 'Snapping'
END

-- Add Position Types - Off, Def, Special Teams
ALTER TABLE nfl_combine
ADD Pos_Type nvarchar(16)
GO

UPDATE nfl_combine
SET Pos_Type = CASE
	WHEN Pos_Group IN('OL','QB','OB','Receivers') THEN 'Offense'
	WHEN Pos_Group IN('DL','LB','DB') THEN 'Defense'
	WHEN Pos_Group in('Kicking', 'Snapping') THEN 'Special teams'
END

-- Fill NCAA_Link based on draft table where empty
UPDATE c
SET c.NCAA_Link = d.NCAA_Link
from nfl_combine c
left join nfl_draft d
on c.Player_ID = d.Player_ID
where c.NCAA_Link is NULL
and d.NCAA_Link is not null
and c.Player_ID is not null
and d.Player_ID is not null

UPDATE c
SET c.NCAA_Link = d.NCAA_Link
from nfl_combine c
left join nfl_draft d
on c.Player = d.Player and c.Year = d.Year
where c.NCAA_Link is NULL
and d.NCAA_Link is not null
and c.Player_ID is null
and c.Player <> 'Mike Green'

-----------------------------------------------------------------------------------------------------------
-- Fix conferences
UPDATE ncaa_team_ratings
SET Conf = CASE
	WHEN Conf IN('ACC','ACC (Atlantic)','ACC (Coastal)') THEN 'ACC'
	WHEN Conf IN('American','American (East)','American (West)') THEN 'American'
	WHEN Conf IN('Big 12','Big 12 (North)','Big 12 (South)') THEN 'Big 12'
	WHEN Conf IN('Big Ten','Big Ten (East)','Big Ten (Leaders)','Big Ten (Legends)','Big Ten (West)') THEN 'Big Ten'
	WHEN Conf IN('CUSA','CUSA (East)','CUSA (West)') THEN 'CUSA'
	WHEN Conf IN('MAC (East)','MAC (West)') THEN 'MAC'
	WHEN Conf IN('MWC','MWC (Mountain)','MWC (West)') THEN 'MWC'
	WHEN Conf IN('Pac-12 (North)','Pac-12 (South)') THEN 'Pac-12'
	WHEN Conf IN('SEC (East)','SEC (West)') THEN 'SEC'
	WHEN Conf IN('Sun Belt','Sun Belt (East)','Sun Belt (West)') THEN 'Sun Belt'
	ELSE Conf
END

-- latest conference for each team
SELECT School, Conf
INTO _helper_School_Conf
FROM
(
select school,conf.[Year], MAX([Year]) OVER (PARTITION BY School ORDER BY [Year] DESC) Max_Year
from ncaa_team_ratings 
group by School,conf, Year
)t
WHERE t.[Year] = t.Max_Year

-- update to latest conference
UPDATE r
SET r.Conf = h.Conf
FROM ncaa_team_ratings r
LEFT JOIN _helper_School_Conf h
ON r.School = h.School

-- fix Notre Dame
select distinct school, conf from ncaa_team_ratings where school='Notre Dame'

UPDATE ncaa_team_ratings
SET Conf = 'ACC'
WHERE School = 'Notre Dame'

-- Idaho used to be in Sun Belt but now Division 1
select distinct school, conf from ncaa_team_ratings where Conf='Sun Belt'

-- Fix physical and drill measurements where missing
-- Arm length and hand size
UPDATE nflcombineresults
SET Shuttle = NULL
WHERE Shuttle = 9.99

UPDATE nflcombineresults
SET [3Cone] = NULL
WHERE [3Cone] = 9.99

UPDATE nflcombineresults
SET [40yd] = NULL
WHERE [40yd] = 9.99

ALTER TABLE [dbo].[nfl_combine]
ADD Arm_length float, Hand_size float
GO 
UPDATE c1
SET
	c1.Arm_length = c2.[Arm Length],
	c1.Hand_size = c2.Hands
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year

UPDATE c1
SET
	c1.Hand_size = c2.Hand_size,
	c1.Arm_length = c2.Arm_length
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Hand_size IS NULL and c1.Arm_length IS NULL

-- Height
UPDATE c1
SET c1.Ht = c2.Height
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.Ht is NULL

UPDATE c1
SET c1.Ht = ROUND(c2.Height,0)
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Ht is NULL

-- Weight
UPDATE c1
SET c1.Wt = c2.Weight
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.Wt is NULL

UPDATE c1
SET c1.Wt = c2.Weight
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Wt is NULL

-- 3 cone
UPDATE c1
SET c1.[3Cone] = c2.[Three Cone Drill]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.[3Cone] is NULL

UPDATE c1
SET c1.[3Cone] = c2.[3Cone]
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.[3Cone] is NULL

-- 40 yd dash
UPDATE c1
SET c1.[40yd] = c2.[40 Yard Dash]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.[40yd] is NULL

UPDATE c1
SET c1.[40yd] = c2.[40yd]
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.[40yd] is NULL

-- Bench press
UPDATE c1
SET c1.Bench = c2.[Bench Press]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.Bench is NULL

UPDATE c1
SET c1.Bench = c2.Bench
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Bench is NULL

-- Vertical jump
UPDATE c1
SET c1.Vertical = c2.[Vertical Jump]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.Vertical is NULL

UPDATE c1
SET c1.Vertical = c2.Vertical
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Vertical is NULL

-- Broad jump
UPDATE c1
SET c1.BroadJump= c2.[Broad Jump]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.BroadJump is NULL

UPDATE c1
SET c1.BroadJump = c2.BroadJump
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.BroadJump is NULL

-- Shuttle
UPDATE c1
SET c1.Shuttle= c2.[20 Yard Shuttle]
FROM nfl_combine c1
INNER JOIN nfl_combine_2016_2020 c2
ON c1.Player = c2.Player and c1.Year = c2.Year
WHERE c1.Shuttle is NULL

UPDATE c1
SET c1.Shuttle = c2.Shuttle
FROM nfl_combine c1
INNER JOIN nflcombineresults c2
ON c1.Player = c2.Name and c1.Year = c2.Year
WHERE c1.Shuttle is NULL

---- update with knn imputed values
--UPDATE c1
--SET
--c1.Arm_length = c2.Arm_Length,
--c1.Hand_size = c2.Hand_size,
--c1.[40yd] = c2.[40yd],
--c1.[3Cone] = c2.[3Cone],
--c1.Bench = c2.Bench,
--c1.Vertical = c2.Vertical,
--c1.BroadJump = c2.BroadJump,
--c1.Shuttle = c2.Shuttle
--FROM nfl_combine c1
--INNER JOIN nfl_combine_knn5_imputed c2
--ON c1.Player_ID = c2.Player_ID and c1.NCAA_Link=c2.NCAA_Link and c1.Player=c2.Player

--UPDATE c1
--SET
--c1.Arm_length = c2.Arm_Length,
--c1.Hand_size = c2.Hand_size,
--c1.[40yd] = c2.[40yd],
--c1.[3Cone] = c2.[3Cone],
--c1.Bench = c2.Bench,
--c1.Vertical = c2.Vertical,
--c1.BroadJump = c2.BroadJump,
--c1.Shuttle = c2.Shuttle
--FROM nfl_combine c1
--INNER JOIN nfl_combine_knn5_imputed c2
--ON c1.Player=c2.Player
--WHERE c1.Player_ID IS NULL or c1.NCAA_Link IS NULL


-- multiposition players
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ncaa_player_stats_clean') drop table ncaa_player_stats_clean;

SELECT *
INTO ncaa_player_stats_clean
FROM ncaa_player_stats

------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/aaron-hunt-2.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/adrian-jones-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/andre-woolfolk-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/andy-isabella-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/anthony-barr-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/antoine-harris-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/arnaz-battle-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/blace-brown-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/blake-bell-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/bradie-ewing-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/brandon-hogan-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/brandon-tate-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/braxton-miller-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/brian-allen-6.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/brian-cole-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/bruce-branch-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/bruce-thornton-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/byron-marshall-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/chansi-stuckey-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/charles-drake-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/charles-frederick-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/charles-gaines-2.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/chaz-powell-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/chinedum-ndukwe-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/chris-culliver-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/cj-prosise-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/collin-klein-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/connor-barwin-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/corey-webster-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/courtland-sutton-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/coy-wire-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/crockett-gillmore-1.html' AND Pos='DL'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/curtis-marsh-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dajuan-morgan-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/damarius-bilbo-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/damien-berry-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dare-ogunbowale-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dare-ogunbowale-1.html' AND Pos='CB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/darius-phillips-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/darrell-hunter-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/daven-holly-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/david-edwards-3.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/delano-howell-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/derek-ross-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/derrek-thomas-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/derrell-smith-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/devery-henderson-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/devon-johnson-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/devon-wylie-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dion-jordan-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dj-tialavea-1.html' AND Pos='DL'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dj-wolfe-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dorin-dickerson-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/dorin-dickerson-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/doug-hogue-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/duane-brown-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/duane-coleman-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/earl-mitchell-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/francis-bernard-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/isaiah-johnson-4.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/isaiah-stanback-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jacorey-shepherd-2.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jakobi-meyers-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jared-newberry-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jason-carter-2.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jason-jones-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jason-smith-3.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jason-wright-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jason-wright-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jeff-chaney-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jeremy-langford-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jermaine-phillips-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jj-watt-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/joe-cohen-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/joe-cooper-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/joe-staley-2.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/john-henderson-1.html' AND Pos='P'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/john-mccargo-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/johnny-white-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jonathan-babineaux-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jonathan-wade-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jonathan-wade-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jordan-reed-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/joseph-charlton-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/justin-gage-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/justin-king-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kameron-kelly-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kamryn-pettway-1.html' AND Pos='FB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kealoha-pilares-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kendrick-lewis-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/ken-lucas-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kerry-meier-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kevin-jurovich-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/kevin-payne-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/lance-briggs-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/legedu-naanee-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/lendy-holmes-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/leron-mcclain-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/levron-williams-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/lydell-sargeant-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marcell-allmond-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marcus-spears-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/mardy-gilyard-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marquis-weeks-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marshay-green-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marvin-mcnutt-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/mecole-hardman-1.html' AND Pos='FB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/mike-abrams-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/mike-pinkard-1.html' AND Pos='DL'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/mitch-petrus-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nate-ilaoa-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nathan-hairston-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nick-kasa-1.html' AND Pos='DL'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nick-polk-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/niles-brinkley-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/noah-herron-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nolan-carroll-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/owen-daniels-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/paul-arnold-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/pharoh-cooper-1.html' AND Pos='CB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/pig-prather-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rashad-washington-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rashawn-jackson-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/raymond-walls-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/reggie-lewis-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/richard-sherman-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rj-english-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/robert-gallery-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rob-ninkovich-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rod-rutherford-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/ryan-harris-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/ryan-hewitt-1.html' AND Pos='TE'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/sam-brandon-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/sammie-stroughter-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/sean-smith-2.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/shaun-draughn-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/stantley-thomas-oliver-iii-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/syvelle-newton-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/theo-riddick-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tim-shaw-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tony-lippett-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/torrie-cox-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/torrie-cox-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/travis-beckum-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tre-madden-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/troy-niklas-1.html' AND Pos='LB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tye-hill-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/vincent-meeks-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/will-blackmon-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/will-dissly-1.html' AND Pos='DL'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/willie-reid-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/zach-gentry-2.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/anthony-malbrough-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/anthony-malbrough-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/deltha-oneal-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/rob-morris-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/trung-canidate-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jerry-porter-1.html' AND Pos='DB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/larry-foster-1.html' AND Pos='PR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/ian-gold-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/hank-poteat-1.html' AND Pos='RB'

----------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jon-beason-1.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/justin-wyatt-1.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marcus-smith-4.html' AND Pos='RB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nick-bawden-1.html' AND Pos='QB'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/patrick-dyson-1.html' AND Pos='KR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/shaunard-harts-2.html' AND Pos='WR'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tom-ashworth-1.html'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/tony-pollard-1.html' AND Year='2015'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/trai-essex-1.html'

DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jon-beason-1.html' AND Year='2004'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/justin-wyatt-1.html' AND Year='2002'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/marcus-smith-4.html' AND Year='2004'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/nick-bawden-1.html' AND Year='2015'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/patrick-dyson-1.html' AND Year='1999'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/shaunard-harts-2.html' AND Year='1999'

-----------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/anthony-barr-1.html' AND Year='2011'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/bobby-newcombe-1.html' AND Year='1998'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/diamond-ferri-1.html' AND Year IN('2000','2001')
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/jimmy-williams-1.html' AND Year='1997'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/karlos-williams-1.html' AND Year IN('2011','2012')
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/levine-toilolo-1.html' AND Year='2010'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/noah-igbinoghene-1.html' AND Year='2017'
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/ryan-tannehill-1.html' AND Year IN('2008','2009')
DELETE FROM ncaa_player_stats_clean WHERE NCAA_Link='http://www.sports-reference.com/cfb/players/trindon-holliday-1.html'

-- fix BYU
UPDATE ncaa_player_stats_clean
SET School = 'BYU'
WHERE School = 'Brigham Young'


-- create index
CREATE INDEX iID ON ncaa_all_americans (NCAA_Link);
CREATE INDEX iID ON nfl_draft (NCAA_Link);
CREATE INDEX iID ON nfl_combine (NCAA_Link);
CREATE INDEX iID ON ncaa_player_stats (NCAA_Link);
CREATE INDEX iID ON ncaa_player_stats_clean (NCAA_Link);