-- Power conference binary
-- https://en.wikipedia.org/wiki/Power_Five_conferences

ALTER TABLE ncaa_team_ratings
ADD Power_Conf bit
GO
UPDATE ncaa_team_ratings
SET Power_Conf = CASE
	WHEN Conf IN('ACC', 'Big Ten', 'Big 12', 'Pac-12', 'SEC') THEN 1
	ELSE 0
END

-- BMI - To measure lean muscle mass
ALTER TABLE nfl_combine
ADD BMI float
GO

UPDATE nfl_combine
SET BMI = CAST(Wt AS float)/CAST(Ht AS float)/CAST(Ht AS float)*703

-- Speed score -- used for RBs, rewards heavier players
-- https://www.footballoutsiders.com/stat-analysis/2018/speed-score-2018
ALTER TABLE nfl_combine
ADD Speed_score float
GO

UPDATE nfl_combine
SET Speed_score = (CAST(Wt AS float)*200)/(POWER([40yd],4))

-- Height-Adjusted Speed Score -- for WRs, rewards taller players
--HaSS = Speed Score * (Height/73.5)^1.5
-- http://moneyinthebananastand.com/2012/04/24/dominator-rating-height-adjusted-speed-score-and-wr-draft-rankings/

ALTER TABLE nfl_combine
ADD HASS float
GO

UPDATE nfl_combine
SET HASS = Speed_score * POWER((CAST(Ht AS float)/73.5),1.5)

-- Vertical Jump Power - Sayers Power Formula: measures lower body force generation
-- https://www.topendsports.com/testing/vertical-jump-power.htm

ALTER TABLE nfl_combine
ADD Vertical_Jump_Power float
GO

UPDATE nfl_combine
SET Vertical_Jump_Power = (60.7*Vertical*2.54) + (45.3 * (CAST(Wt AS float)/2.205)) - 2055


-- Broad Jump Power - Sayers Power Formula
ALTER TABLE nfl_combine
ADD Broad_Jump_Power float
GO

UPDATE nfl_combine
SET Broad_Jump_Power = (60.7*BroadJump*2.54) + (45.3 * (CAST(Wt AS float)/2.205)) - 2055


-- Quix Score: measures speed with changing directions - rewards heavier players
-- https://www.milehighreport.com/2016/3/8/11160328/2016-nfl-draft-top-10-quix-score

ALTER TABLE nfl_combine
ADD Quix_score float
GO

UPDATE nfl_combine
SET Quix_score = (CAST(Wt AS float)*7000) / (POWER([3Cone]+Shuttle,4))


--Weight and Height Adjusted Bench
--http://www.footballperspective.com/alex-barnes-was-the-2019-combine-bench-press-champion/#more-41629
ALTER TABLE nfl_combine
ADD Exp_Bench float
GO

UPDATE nfl_combine
SET Exp_Bench = ROUND(45-0.75113*Ht+0.124*Wt,1)

ALTER TABLE nfl_combine
ADD Bench_Diff float
GO

UPDATE nfl_combine
SET Bench_Diff = Bench-Exp_Bench


/* 
College Dominator Rating
https://www.playerprofiler.com/terms-glossary/
The college dominator rating represents a player’s “market share” or his percentage of his team’s offensive production.
For example, a 35+% dominator indicates that a wide receiver has the potential to be a team’s No. 1 WR and/or a high caliber
contributor. 20-35% indicates a mid-level talent with situational upside. Less than 20% is a red flag.
For wide receivers and tight ends, the dominator rating is the percentage of team receiving production. 
For running backs, it is the percentage of total offensive production, because running backs are involved in both the running and passing game. College Dominator Rating is not relevant for the quarterback position.

-- for wr
yds % = rec_yds/team_rec_yds
td % = rec_td/team_rec_td
dominator rating = (yds%+td)%/2

-- for rb
yds % = (scrim_yds)/team_total_yds
td % = (scrim_td)/team_total_offensive_td
dominator rating = (yds%+td)%/2
*/

ALTER TABLE ncaa_player_stats_clean
ADD Yds_Share float
GO

ALTER TABLE ncaa_player_stats_clean
ADD TD_Share float
GO

ALTER TABLE ncaa_player_stats_clean
ADD Dominator_Rating float
GO

-- create helper table
select 
p.ncaa_link,
p.year,
p.School,
p.Rec_Yds,
p.Rec_TD,
p.Scrim_Yds,
p.Scrim_TD,
t.G,
round(t.Pass_Yds*t.G,0) Pass_Yds,
round(t.Pass_TD*t.G,0) Pass_TD,
round(t.Off_Yds*t.G,0) Off_Yds,
(round(t.Rush_TD*t.G,0))+(round(t.Pass_TD*t.G,0)) Off_TD
INTO _helper_dominator_rating
from ncaa_player_stats_clean p
inner join ncaa_team_offense_defense t
on p.School = t.School AND p.Year = t.Year
WHERE p.Year<>'career' and p.year is not null --and p.NCAA_Link='http://www.sports-reference.com/cfb/players/saquon-barkley-1.html'

UPDATE p
SET 
	p.Yds_Share = h.Rec_Yds/h.Pass_Yds,
	p.TD_Share = h.Rec_TD/h.Pass_TD,
	p.Dominator_Rating = (h.Rec_Yds/h.Pass_Yds+h.Rec_TD/h.Pass_TD)/2
FROM ncaa_player_stats_clean p
LEFT JOIN _helper_dominator_rating h
ON p.NCAA_Link=h.ncaa_link AND p.Year=h.year
LEFT JOIN nfl_combine c
ON c.NCAA_Link = p.NCAA_Link AND c.Year-1=p.Year
WHERE p.Pos IN('WR','TE')
AND p.Year<>'Career' and p.Year IS NOT NULL

UPDATE p
SET 
	p.Yds_Share = h.Scrim_Yds/h.Off_Yds,
	p.TD_Share = h.Scrim_TD/h.Off_TD,
	p.Dominator_Rating = (h.Scrim_Yds/h.Off_Yds+h.Scrim_TD/h.Off_TD)/2
FROM ncaa_player_stats_clean p
LEFT JOIN _helper_dominator_rating h
ON p.NCAA_Link=h.ncaa_link AND p.Year=h.year
LEFT JOIN nfl_combine c
ON c.NCAA_Link = p.NCAA_Link AND c.Year-1=p.Year
WHERE p.Pos IN('RB','FB')
AND p.Year<>'Career' and p.Year IS NOT NULL