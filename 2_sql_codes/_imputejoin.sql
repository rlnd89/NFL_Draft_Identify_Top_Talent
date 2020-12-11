SELECT p.[Combine_Year]
      ,p.[Player_ID]
      ,p.[Rnd]
      ,p.[Round_Cat]
      ,p.[Pick]
      ,p.[Draft_Team]
      ,p.[Player]
      ,p.[AV]
      ,p.[Exp_AV]
      ,p.[Success]
      ,p.[Class]
      ,p.[Underclassman]
      ,p.[Pos]
      ,p.[Pos_Group]
      ,p.[Pos_Type]
      ,p.[Draft_age]
      ,p.[School]
      ,p.[Conf]
      ,p.[Power_Conf]
      ,p.[Ht]
      ,p.[Wt]
      ,p.[BMI]
      ,coalesce(p.[Arm_length],c.[Arm_length]) Arm_length
      ,coalesce(p.[Hand_size],c.[Hand_size]) Hand_size
      ,coalesce(p.[40yd],c.[40yd]) [40yd]
      ,coalesce(p.[Speed_Score],c.[speed_score]) Speed_Score
      ,coalesce(p.[HASS],c.[HASS]) HASS
      ,coalesce(p.[Vertical],c.[Vertical]) Vertical
      ,coalesce(p.[Vertical_Jump_Power],c.[Vertical_Jump_power]) Vertical_Jump_Power
      ,coalesce(p.[Bench],c.Bench) Bench
      --,p.[Exp_Bench]
      ,coalesce(p.[Bench_Diff],c.[Bench_Diff])Bench_Diff
      ,coalesce(p.[BroadJump],c.[BroadJump]) BroadJump
      ,coalesce(p.[Broad_Jump_Power],c.Broad_Jump_Power) Broad_Jump_Power
      ,coalesce(p.[3Cone],c.[3cone]) [3Cone]
      ,coalesce(p.[Shuttle],c.[Shuttle]) Shuttle
      ,coalesce(p.[Quix_Score],c.[Quix_Score]) Quix_Score
      ,p.[School_Off_Rnk]
      ,p.[School_Def_Rnk]
      ,p.[School_Off_Rating]
      ,p.[School_Def_Rating]
      ,p.[School_Rating]
      ,p.[Consensus_AA]
      ,p.[Dominator_Rating_Prior]
      ,p.[Dominator_Rating_Draft]
      ,p.[Rush_Att_PG_Prior]
      ,p.[Rush_Att_PG_Draft]
      ,p.[Rush_Yds_PG_Prior]
      ,p.[Rush_Yds_PG_Draft]
      ,p.[Rush_Avg_Prior]
      ,p.[Rush_Avg_Draft]
      ,p.[Rush_TD_PG_Prior]
      ,p.[Rush_TD_PG_Draft]
      ,p.[Rec_PG_Prior]
      ,p.[Rec_PG_Draft]
      ,p.[Rec_Yds_PG_Prior]
      ,p.[Rec_Yds_PG_Draft]
      ,p.[Rec_TD_PG_Prior]
      ,p.[Rec_TD_PG_Draft]
      ,p.[Scrim_Yds_PG_Prior]
      ,p.[Scrim_Yds_PG_Draft]
      ,p.[Scrim_TD_PG_Prior]
      ,p.[Scrim_TD_PG_Draft]
      --,p.[Kick_FGA_PG_Prior]
      --,p.[Kick_FGA_PG_Draft]
      --,p.[Kick_FGM_PG_Prior]
      --,p.[Kick_FGM_PG_Draft]
      --,p.[Kick_FG_pct_Prior]
      --,p.[Kick_FG_pct_Draft]
      --,p.[Kick_XPA_PG_Prior]
      --,p.[Kick_XPA_PG_Draft]
      --,p.[Kick_XPM_PG_Prior]
      --,p.[Kick_XPM_PG_Draft]
      --,p.[Kick_XP_pct_Prior]
      --,p.[Kick_XP_pct_Draft]
      ,p.[Non_offensive_TD_PG_Prior]
      ,p.[Non_offensive_TD_PG_Draft]
  FROM [DataRobot].[dbo].[player_stats_final_raw_pg] p
  INNER JOIN player_stats_final_raw_pg_imputed c
  on c.Player_ID=p.Player_ID
    where p.Draft_Team<>'Undrafted'
  and p.Combine_Year < 2016
  AND p.Pos NOT IN('LS','FB','P','K','OT','OG','C','QB') and p.pos_type='offense'
 --AND Pos='WR'
 -- and draft_age is null
 --and Exp_AV>av
  order by 2

 -- select class, draft_age, count(*) from player_stats_final_raw_pg group by class,Draft_age order by 1,2