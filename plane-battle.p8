pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--plane-battle 
--by jerry benson
--this is a cool & fun game
function _init()
  game_over = true
  is_singleplayer = true
end


function setup()
  
  pause = false 
  is_crashing = false

  --player direction spr
  pl1_n = 87
  pl1_ne = 74
  pl1_e = 71
  pl1_se = 106
  pl1_s = 119
  pl1_sw = 122
  pl1_w = 103
  pl1_nw = 90
	pl1_flame_spr = 94
 
  pl2_n = 104
  pl2_ne = 73
  pl2_e = 88
  pl2_se = 105
  pl2_s = 72
  pl2_sw = 121
  pl2_w = 120
  pl2_nw = 89
  pl2_flame_spr = 93
  
  --player spr when hit
  pl1_n_h = 80
  pl1_ne_h = 67
  pl1_e_h = 64
  pl1_se_h = 99
  pl1_s_h = 112
  pl1_sw_h = 115
  pl1_w_h = 96
  pl1_nw_h = 83
  
  pl2_n_h = 97
  pl2_ne_h = 66
  pl2_e_h = 81
  pl2_se_h = 98
  pl2_s_h = 65
  pl2_sw_h = 114
  pl2_w_h = 113
  pl2_nw_h = 82
  
  flame_tail_spr1 = 77 
  flame_tail_spr2 = 78

  bullet_spr_horiz = 95 
  bullet_spr_vert = 111
  
  pl1_rubble_spr1 = 75
  pl1_rubble_spr2 = 91
  pl2_rubble_spr1 = 107
  pl2_rubble_spr2 = 123
  
	actors = {} --all actors in world
  game_over = false
  game_over_damage = 5 
  middle = 8 
  min_x = .5
  max_x = 15.5
 	min_y = .5
  max_y = 14
  
	pl1_direction = "left"
	pl2_direction = "left"
	pl1_original_direction = "left"
	pl2_original_direction = "left"
		  
  speed = .125
  other_speed = .0625
  pl1_speed = speed
  pl2_speed = speed

  pl1_rubble1 = {}
  pl1_rubble2 = {}
  pl2_rubble1 = {}
  pl2_rubble2 = {}
  
	bullet_speed = speed * 3 

	-- don't allow user to hold down fire button
  pl1_is_pressed = false
  pl2_is_pressed = false
  pl1 = make_actor(max_x - 1,7, pl1_w, "w",  0, -speed)
  pl2 = make_actor(min_x + 1,7, pl2_e, "e",  0,  speed)
  pl1_flame = nil
  pl2_flame = nil
  
  --only for singleplayer
  is_turning = false 
  
   turn_max = 0
   turn_counter = 0
end
  

function make_actor(x, y, spr, d,  speed_y , speed_x)
  a={}
  a.is_pressed = false
  a.damage = 0
  a.x = x
  a.y = y
  a.frame = 0
  a.spr = spr
  a.direction = d
  a.speed_y = speed_y
  a.speed_x = speed_x
  a.bullet_counter = 0
  add(actors,a)
  return a 
end

function _update()
	if (not game_over) then
    for actor in all(actors) do
      check_boundaries(actor)
    end
    pl1_speed = control_players (pl1, pl1_flame_spr, pl1_n, pl1_s, pl1_w, pl1_e, pl1_nw, pl1_sw, pl1_se, pl1_ne,0)
    if (is_singleplayer == false) then
      pl2_speed = control_players (pl2, pl2_flame_spr, pl2_n, pl2_s, pl2_w, pl2_e, pl2_nw, pl2_sw, pl2_se, pl2_ne,1)
    end
    singleplayer()
    move_player (pl1, pl1_flame, pl1_flame_spr,pl1_speed)
    move_player (pl2, pl2_flame, pl2_flame_spr,pl2_speed)
    move_bullets ()
    check_collision()
	end
end

function check_boundaries (actor)
  
  if (actor.y < min_y - .5 and (actor.direction == "nw" or actor.direction == "n" or actor.direction == "ne")) then
    actor.y =  actor.y + max_y + .5
  elseif (actor.y > max_y + .5 and (actor.direction == "sw" or actor.direction == "s" or actor.direction == "se")) then
    actor.y =  actor.y  - max_y - .5  
  elseif (actor.x > max_x + .5 and (actor.direction == "se" or actor.direction == "e" or actor.direction == "ne")) then
    actor.x =  actor.x - max_x - .5  
  elseif (actor.x < min_x - .5 and (actor.direction == "sw" or actor.direction == "w" or actor.direction == "nw")) then
    actor.x =  actor.x + max_x + .5
  end  
end

function check_collision()
  for actor in all(actors) do
		if (actor.spr == bullet_spr_horiz or actor.spr == bullet_spr_vert) then
      if (actor.x >  pl1.x -.5 
        and actor.x < pl1.x +.5  
        and actor.y > pl1.y - .5  
        and actor.y <  pl1.y +.5) then  
        del (actors, actor)
        if (not is_crashing) then
          pl1.damage = pl1.damage + 1	
          switch(pl1)	  	
          if (pl1.damage == game_over_damage) then
            is_crashing = true;
            pl1.spr = pl1_flame_spr
            pl1_flame = make_actor(pl1.x ,pl1.y - 1, flame_tail_spr1)
          end
        end						
      end
      if (actor.x >  pl2.x -.5  
        and actor.x < pl2.x +.5  
        and actor.y > pl2.y - .5  
        and actor.y <  pl2.y +.5) then  
        del (actors, actor)
        if (not is_crashing) then
          pl2.damage = pl2.damage + 1
          switch(pl2) 	
          if (pl2.damage == game_over_damage) then
            is_crashing = true;
            pl2.spr = pl2_flame_spr
            pl2_flame = make_actor(pl2.x ,pl2.y - 1, flame_tail_spr1)
          end
        end		   
      end
    end
  end
end



function draw_actor(a) 
  local sx = (a.x * 8) - 4
  local sy = (a.y * 8) - 4
  spr(a.spr, sx, sy)
end

function _draw()
  cls()
  map(0,0,0,0,16,16)
  
  foreach(actors,draw_actor)
  
  if (game_over) then
  	if (pl2 and pl2.damage == game_over_damage) then
      print ("green won!!!",45, 10, 9)
      del (actors, pl2_flame)
      del (actors, pl2)
      pl2_rubble1.x = pl2_flame.x
      pl2_rubble1.y = pl2_flame.y
      pl2_rubble2.x = pl2_flame.x + 1
      pl2_rubble2.y = pl2_flame.y
      if (pl2_rubble1.spr == pl2_rubble_spr1) then
        pl2_rubble1.spr = pl2_rubble_spr2
        pl2_rubble2.spr = pl2_rubble_spr2 + 1
      else
        pl2_rubble1.spr = pl2_rubble_spr1
        pl2_rubble2.spr = pl2_rubble_spr1 + 1
      end
      draw_actor(pl2_rubble1)
      draw_actor(pl2_rubble2)
    elseif (pl1 and pl1.damage == game_over_damage) then 
      print ("grey won!!!", 45, 10, 5)
      del (actors, pl1_flame)
      del (actors, pl1)
      pl1_rubble1.x = pl1_flame.x
      pl1_rubble1.y = pl1_flame.y
      pl1_rubble2.x = pl1_flame.x + 1
      pl1_rubble2.y = pl1_flame.y
      if (pl1_rubble1.spr == pl1_rubble_spr1) then
        pl1_rubble1.spr = pl1_rubble_spr2
        pl1_rubble2.spr = pl1_rubble_spr2 + 1
      else
        pl1_rubble1.spr = pl1_rubble_spr1
        pl1_rubble2.spr = pl1_rubble_spr1 + 1
      end
      draw_actor(pl1_rubble1)
      draw_actor(pl1_rubble2)
    end
    print (" up:single player", 12, 30, 5) 
    print (" down:multiplayer player", 12, 20, 5) 
    if (btn (3) or btn (3,1)) then 
      is_singleplayer = false
      setup() 
    end	
    if (btn (2) or btn(2,1)) then
      is_singleplayer = true
      setup()
    end
  end
  if (pl2 and pl1) then 
    print ("green damage:"..pl1.damage.."    grey damage:"..pl2.damage, 0,120, 9)	
  end
end
 
function switch(pl)
  if (pl.spr == pl1_n) then
    pl.spr = pl1_n_h 
  elseif (pl.spr == pl1_ne) then
    pl.spr = pl1_ne_h 
  elseif (pl.spr == pl1_e) then
    pl.spr = pl1_e_h 
  elseif (pl.spr == pl1_se) then
    pl.spr = pl1_se_h 
  elseif (pl.spr == pl1_s) then
    pl.spr = pl1_s_h 
  elseif (pl.spr == pl1_sw) then
    pl.spr = pl1_sw_h 
  elseif (pl.spr == pl1_w) then
    pl.spr = pl1_w_h 
  elseif (pl.spr == pl1_nw) then
    pl.spr = pl1_nw_h 

  elseif (pl.spr == pl2_n) then
    pl.spr = pl2_n_h 
  elseif (pl.spr == pl2_ne) then
    pl.spr = pl2_ne_h 
  elseif (pl.spr == pl2_e) then
    pl.spr = pl2_e_h 
  elseif (pl.spr == pl2_se) then
    pl.spr = pl2_se_h 
  elseif (pl.spr == pl2_s) then
    pl.spr = pl2_s_h 
  elseif (pl.spr == pl2_sw) then
    pl.spr = pl2_sw_h 
  elseif (pl.spr == pl2_w) then
    pl.spr = pl2_w_h 
  elseif (pl.spr == pl2_nw) then
    pl.spr = pl2_nw_h 
  end
end




function switch_back(pl)
  if (pl.spr == pl1_n_h) then
    pl.spr = pl1_n 
  elseif (pl.spr == pl1_ne_h) then
    pl.spr = pl1_ne
  elseif (pl.spr == pl1_e_h) then
    pl.spr = pl1_e 
  elseif (pl.spr == pl1_se_h) then
    pl.spr = pl1_se
  elseif (pl.spr == pl1_s_h) then
    pl.spr = pl1_s
  elseif (pl.spr == pl1_sw_h) then
    pl.spr = pl1_sw
  elseif (pl.spr == pl1_w_h) then
    pl.spr = pl1_w 
  elseif (pl.spr == pl1_nw_h) then
    pl.spr = pl1_nw 

  elseif (pl.spr == pl2_n_h) then
    pl.spr = pl2_n
  elseif (pl.spr == pl2_ne_h) then
    pl.spr = pl2_ne
  elseif (pl.spr == pl2_e_h) then
    pl.spr = pl2_e 
  elseif (pl.spr == pl2_se_h) then
    pl.spr = pl2_se 
  elseif (pl.spr == pl2_s_h) then
    pl.spr = pl2_s
  elseif (pl.spr == pl2_sw_h) then
    pl.spr = pl2_sw 
  elseif (pl.spr == pl2_w_h) then
    pl.spr = pl2_w 
  elseif (pl.spr == pl2_nw_h) then
    pl.spr = pl2_nw 
  end
end

function move_bullets() 
  switch_back(pl1)
  switch_back(pl2)
	for actor in all(actors) do
		if (actor.spr == bullet_spr_horiz or actor.spr == bullet_spr_vert) then
			if (actor.direction == "n") then
			  actor.y = actor.y - bullet_speed 						
			end
			if (actor.direction == "s") then
				actor.y = actor.y + bullet_speed 						
			end
			if (actor.direction == "e") then
				actor.x = actor.x + bullet_speed 						
			end
			if (actor.direction == "w") then
				actor.x = actor.x - bullet_speed 						
      end
      if (actor.direction == "nw") then
        actor.y = actor.y - bullet_speed 	
        actor.x = actor.x - bullet_speed					
			end
			if (actor.direction == "sw") then
        actor.y = actor.y + bullet_speed 	
        actor.x = actor.x - bullet_speed					
			end
      if (actor.direction == "ne") then
        actor.y = actor.y - bullet_speed 
				actor.x = actor.x + bullet_speed 						
			end
      if (actor.direction == "se") then
        actor.y = actor.y + bullet_speed 
				actor.x = actor.x + bullet_speed 						
      end

      
     

      actor.bullet_counter += 1 
      if (actor.bullet_counter == 30) then
        del(actors,actor)
      end
      


	  end
  end
end

function control_players(pl, pl_flame_spr, pl_n, pl_s, pl_w, pl_e, pl_nw, pl_sw, pl_se, pl_ne,pl_index)
  
  -- left
  if (btn(0,pl_index) and pl.x > min_x and not pl.is_pressed and pl.spr != pl_flame_spr ) then 
    pl.is_pressed = true
    if(pl.direction == "n") then 
      pl.spr = pl_nw 
      pl.direction = "nw" 

    elseif(pl.direction == "nw") then 
      pl.spr = pl_w 
      pl.direction = "w" 
    
    elseif(pl.direction == "w") then 
      pl.spr = pl_sw 
      pl.direction = "sw" 
       
    elseif (pl.direction == "sw") then 
      pl.spr = pl_s 
      pl.direction = "s" 
    
    elseif (pl.direction == "s") then 
      pl.spr = pl_se 
      pl.direction = "se" 
       
    elseif(pl.direction == "se") then 
      pl.spr = pl_e 
      pl.direction = "e" 
      
    elseif(pl.direction == "e") then 
      pl.spr = pl_ne 
      pl.direction = "ne" 

    elseif(pl.direction == "ne") then 
      pl.spr = pl_n 
      pl.direction = "n" 
    end
  --right  
  elseif (btn(1,pl_index) and pl.x < max_x  and not pl.is_pressed  and pl.spr != pl_flame_spr )  then
    pl.is_pressed = true
    if(pl.direction == "n") then 
      pl.spr = pl_ne
      pl.direction = "ne" 

    elseif(pl.direction == "ne") then 
      pl.spr = pl_e 
      pl.direction = "e" 
    
    elseif(pl.direction == "e") then 
      pl.spr = pl_se 
      pl.direction = "se" 
       
    elseif (pl.direction == "se") then 
      pl.spr = pl_s 
      pl.direction = "s" 
    
    elseif (pl.direction == "s") then 
      pl.spr = pl_sw
      pl.direction = "sw" 
       
    elseif(pl.direction == "sw") then 
      pl.spr = pl_w 
      pl.direction = "w" 
      
    elseif(pl.direction == "w") then 
      pl.spr = pl_nw 
      pl.direction = "nw" 

    elseif(pl.direction == "nw") then 
      pl.spr = pl_n 
      pl.direction = "n" 
    end
	  

	elseif (btn(4,pl_index) and not pl.is_pressed and pl.spr != pl_flame_spr) then
		pl.is_pressed = true
    if (pl.spr == pl_nw) then
      make_actor(pl.x-.6,pl.y-.6,bullet_spr_horiz,"nw") 
    end
    if (pl.spr == pl_sw) then
			make_actor(pl.x-.6,pl.y+.6,bullet_spr_horiz,"sw")
    end
    if (pl.spr == pl_se) then
			make_actor(pl.x+.6,pl.y+.6,bullet_spr_horiz,"se")
    end
    if (pl.spr == pl_ne) then
			make_actor(pl.x+.6,pl.y-.6,bullet_spr_horiz,"ne")
    end      
    if (pl.spr == pl_n) then
			make_actor(pl.x,pl.y-.6,bullet_spr_vert,"n")
    end	
		if (pl.spr == pl_s) then
			make_actor(pl.x,pl.y+.6,bullet_spr_vert,"s")
 		end	    	     	    		 
		if (pl.spr == pl_e) then
			make_actor(pl.x+.6,pl.y,bullet_spr_horiz,"e")
 		end	    	     	    		 
		if (pl.spr == pl_w) then
      make_actor(pl.x-.6,pl.y,bullet_spr_horiz,"w")
    end
  end	
  
  

  if (not btn(0, pl_index) and not btn(1, pl_index) and not btn(4, pl_index)) then 
    pl.is_pressed = false
  end

  if (btn(5,pl_index)) then
    return other_speed        
  else
    return speed
  end
end

function move_player(pl,  pl_flame, pl_flame_spr,pl_speed)    
  

  if (pl_flame) then
    pl.y += speed
    pl_flame.y += speed
    if (pl_flame.spr == flame_tail_spr1) then
      pl_flame.spr = flame_tail_spr2
    else
      pl_flame.spr = flame_tail_spr1
    end
    if (pl_flame.y > max_y) then
      game_over = true  
    end
  else
    if(pl.direction == "nw") then 
      pl.speed_y = -pl_speed
      pl.speed_x = -pl_speed
    elseif(pl.direction == "w") then 
      pl.speed_y =  0	 
      pl.speed_x = -pl_speed
    elseif(pl.direction == "sw") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x = -pl_speed
    elseif (pl.direction == "s") then 
      pl.speed_y =  pl_speed	 
      pl.speed_x = 0
    elseif (pl.direction == "se") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x = pl_speed
    elseif(pl.direction == "e") then 
      pl.speed_y = 0 	 
      pl.speed_x = pl_speed
    elseif(pl.direction == "ne") then 
      pl.speed_y = -pl_speed 	 
      pl.speed_x = pl_speed
    elseif(pl.direction == "n") then 
      pl.speed_y = -pl_speed	 
      pl.speed_x = 0 
    end 
    pl.x = pl.x + pl.speed_x
    pl.y = pl.y + pl.speed_y 
  end 
end



function singleplayer()
  if (pl2.direction == "e") then
    print ("grey won!!!", 45, 10, 5)
  end

  if (is_singleplayer and not is_crashing) then

    if (turn_counter == turn_max) then
      turn_counter = 0
      turn_max = flr(rnd(10))
      rand_direction = flr(rnd(2))


      if (pl2.direction) == "n" then
        if (pl1.direction) == "nw" then
          pl2.direction = "ne"
          pl2.spr = pl2_ne 
        elseif (pl1.direction == "ne") then
          pl2.direction = "nw"
          pl2.spr = pl2_nw
        else
          if (rand_direction == 0) then
            pl2.direction = "nw"
            pl2.spr = pl2_nw  
          else
            pl2.direction = "ne"
            pl2.spr = pl2_ne  
          end
        end
      end
      if (pl2.direction) == "e" then
        if (pl1.direction) == "se" then
          pl2.direction = "ne"
          pl2.spr = pl2_ne 
        elseif (pl1.direction == "ne") then
          pl2.direction = "se"
          pl2.spr = pl2_se 
        else
          if (rand_direction == 0) then
            pl2.direction = "ne"
            pl2.spr = pl2_ne 
          else
            pl2.direction = "se"
            pl2.spr = pl2_se 
          end
        end
      end
      if (pl2.direction) == "s" then
        if (pl1.direction) == "se" then
          pl2.direction = "sw"
          pl2.spr = pl2_sw 
        elseif (pl1.direction == "sw") then
          pl2.direction = "se"
          pl2.spr = pl2_se 
        else
          if (rand_direction == 0) then
            pl2.direction = "sw"
            pl2.spr = pl2_sw 
          else
            pl2.direction = "se"
            pl2.spr = pl2_se 
          end
        end
      end
      if (pl2.direction) == "w" then
        if (pl1.direction) == "sw" then
          pl2.direction = "nw"
          pl2.spr = pl2_nw 
        elseif (pl1.direction == "nw") then
          pl2.direction = "sw"
          pl2.spr = pl2_sw 
        else
          if (rand_direction == 0) then
            pl2.direction = "nw"
            pl2.spr = pl2_ne 
          else
            pl2.direction = "sw"
            pl2.spr = pl2_se 
          end
        end
      end
      if (pl2.direction) == "nw" then
        if (pl1.direction) == "w" then
          pl2.direction = "n"
          pl2.spr = pl2_n
        elseif (pl1.direction == "n") then
          pl2.direction = "w"
          pl2.spr = pl2_w 
        else
          if (rand_direction == 0) then
            pl2.direction = "w"
            pl2.spr = pl2_w 
          else
            pl2.direction = "sw"
            pl2.spr = pl2_sw 
          end
        end
      end
      if (pl2.direction) == "ne" then
        if (pl1.direction) == "n" then
          pl2.direction = "e"
          pl2.spr = pl2_e 
        elseif (pl1.direction == "e") then
          pl2.direction = "n"
          pl2.spr = pl2_n 
        else
          if (rand_direction == 0) then
            pl2.direction = "n"
            pl2.spr = pl2_n 
          else
            pl2.direction = "e"
            pl2.spr = pl2_e 
          end
        end
      end
      if (pl2.direction) == "se" then
        if (pl1.direction) == "s" then
          pl2.direction = "e"
          pl2.spr = pl2_e 
        elseif (pl1.direction == "e") then
          pl2.direction = "s"
          pl2.spr = pl2_se 
        else
          if (rand_direction == 0) then
            pl2.direction = "e"
            pl2.spr = pl2_e 
          else
            pl2.direction = "s"
            pl2.spr = pl2_s 
          end
        end
      end
      if (pl2.direction) == "sw" then
        if (pl1.direction) == "s" then
          pl2.direction = "w"
          pl2.spr = pl2_w 
        elseif (pl1.direction == "w") then
          pl2.direction = "s"
          pl2.spr = pl2_se 
        else
          if (rand_direction == 0) then
            pl2.direction = "w"
            pl2.spr = pl2_w 
          else
            pl2.direction = "s"
            pl2.spr = pl2_s 
          end
        end
      end
    end 
  end  
     
    

  turn_counter = turn_counter + 1
  
  --make pl2 fire
  if (is_turning == false and pl2.spr != pl2_flame_spr) then
    if (pl2.spr == pl2_nw) then
      make_actor(pl2.x-.6,pl2.y-.6,bullet_spr_horiz,"nw")
    end
    if (pl2.spr == pl2_sw) then
      make_actor(pl2.x-.6,pl2.y+.6,bullet_spr_horiz,"sw")
    end
    if (pl2.spr == pl2_se) then
      make_actor(pl2.x+.6,pl2.y+.6,bullet_spr_horiz,"se")
    end
    if (pl2.spr == pl2_ne) then
      make_actor(pl2.x+.6,pl2.y-.6,bullet_spr_horiz,"ne")
    end      
    if (pl2.spr == pl2_n) then
      make_actor(pl2.x,pl2.y-.6,bullet_spr_vert,"n")
    end	
    if (pl2.spr == pl2_s) then
        make_actor(pl2.x,pl2.y+.6,bullet_spr_vert,"s")
       end	    	     	    		 
    if (pl2.spr == pl2_e) then
        make_actor(pl2.x+.6,pl2.y,bullet_spr_horiz,"e")
       end	    	     	    		 
    if (pl2.spr == pl2_w) then
        make_actor(pl2.x-.6,pl2.y,bullet_spr_horiz,"w")
    end
      
 
      
    if (pl2.damage == game_over_damage) then
      pl2.spr = pl2_flame_spr

    end  	
  end
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008880008555800008558000083380000000000000000000000000000000000005550000005500000033000000a0000000a00000000a000000a0000ccaaaacc
8083338000855588085588880833888800000000000000000000000000033300000555000055000000330000000a0a0000aa00000000aa00000aa000caaaaaac
388338000888555508558665083386630000000000000000000000003003300000005555005506650033066300aa0a0339aa0000000a9a00000a9a00aaaaaaaa
33836688855555558085565580833633000000000000000000000000330366000555555500055655000336330aaaa903389a0000000a9a00000a9a00aaaaaaaa
3333333385565585585555583833333800000000000000000000000033333333055655055055555030333330098993333399000000a999a000a999a0aaaaaaaa
8333333885865588555555803333338000000000000000000000000003333330050655005555550033333300098339330338000000a989a000a989a0aaaaaaaa
08883380080855805588558033883380000000000000000000000000000033000000550055005500330033000933036300300000009888aa009888aacaaaaaac
000833380008558088085558880833380000000000000000000000000000333000005500000055500000333003300960000000000998888909988889ccaaaacc
00083808000888000085580000833800000000000000000000000000000030000000000000055000000330000000000a0a000000098855590988333900000000
080833838085558088885580888833800000000000000000000000000000330300055500000055000000330000a000090aa00000088555880883338800005000
838633335885580056685580366833800000000000000000000000000306333350055000566055003660330000a00a0339aa0000088558890883388900000000
83363333558566885565580833633808000000000000000000000000033633335505660055655000336330000aaaa903389a0000098555550983333300000000
83333388555555558555558583333383000000000000000000000000033333005555555505555505033333030989933333990000055556550333363300000000
08883380855555550855555508333333000000000000000000000000000033000555555500555555003333330983393303380000055556050333360300000000
00833380088855880855885508338833000000000000000000000000000333000000550000550055003300330933036300300000050550000303300000005000
08333800000855588555808883338088000000000000000000000000003330000000555005550000033300000330096000000000000550000000300000000000
0088800000085588588555803883338000000000000000000000000000000000000055005005550030033300000a0000000a0000ccc777cc7ccccccc00000000
0833380808085585558558003383380000000000000000000000000000333000000055055505500033033000000a0a0000aa0000cc77777777777ccc00000000
008338838586555555555880333338800000000000000000000000000003300305065555555550003333300000aa0a0559aa0000c7777777777777cc00000000
88663833855655558555566883333668000000000000000000000000006630330556555505555660033336600aaaa905589a0000c77777777777777705000050
33333333855555880885556508833363000000000000000000000000333333330555550000055565000333630989955555990000777777777777777700000000
833333380888558000085555000833330000000000000000000000000333333000005500000055550000333309855955555800007777c7777777777c00000000
08883380008555800008558800083388000000000000000000000000000033000005550000005500000033000955556500500000cccccccccccccccc00000000
00833380085558000008555800083338000000000000000000000000000333000055500000005550000033300550096000000000cccccccccccccccc00000000
00083338008880000855588508333883000000000000000000000000000033300000000000555005003330030000000a0a000000cccccccc777ccccccccccccc
008333800855580800855855008338330000000000000000000000000003330000555000000550550003303300a000090aa00000ccc77777777777cccccccccc
008338880085588508855555088333330000000000000000000000000003300000055005000555550003333300a00a0559aa0000c7777777777777cccccccccc
08833333886658558665555886633338000000000000000000000000000333330066505506655550066333300aaaa905589a0000777777777777777ccccccccc
8333363355555555565558803633388000000000000000000000000003333633555555555655500036333000098995555599000077777777777777cccccccccc
83333683555555585555800033338000000000000000000000000000033336035555555055550000333300000985595555580000c7777777777777cccccccccc
83833808888855808855800088338000000000000000000000000000030330000000550000550000003300000955556500500000cc777777777ccccccccccccc
08083800008555808555800083338000000000000000000000000000000030000005550005550000033300000550096000000000ccccc7777ccccccccccccccc
__gff__
0000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000100000000000000000000
0000000000000000000000000000008000000000000000000000000000000000010000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f4f7f6d6e7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7d7e7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000c07040d370103601037010360136701836013370183701c3701c370183701c36018670133701337013370133701436013370153601937012360103700a370093700a360183702137018370186601837018370
001000002b370063702e3702f3702e3702d370293702e3702d3701d3701d3701c370000001e3701e3700000020370000002b3003537037370383703737035370313703a3703b370000003f3703e3703b37036370
00100000210702c370200702537026070250703107033370310702f3702e0701b3002c37036070383703b0703837039070343703f0703f3703c070383703707034370363700e0700d07036070000003637034070
001000003f6703c6503a6503864031640306302d6302c620296203f6703c6503a650376402f6402c6302b63028620276203f6703c6503a650376402f6402d6302963027620256203f6703c65038650366402b640
001700003f0703f0703f0703f0703f1703f1703f1703f1703f2703f2703f2703f2703f2703f3703f3703f3703f3703f4703f4703f4703f5703f5703f5703f5703f6703f6703f6703f6703f7703f7703f7703f770
001000003f7703c7503f6503c7403f7403d7503f6503a7703c750397503b74036740396503575039770357503a650357403774036650317502e67029770237501d6501a74016740177502065025770327703f650
001000003f4703b3703f4703a3703f470383703f4702e3702f470314703237033370304702f4703037030470304702e47033470333703647034370384703947038370344703247037370374703e4703d37037370
003600003c27003270032703627003270032702f27004270042703f2703d2703b2703827033270312702f270342702f270332702f2703f2703d270382702c27028270202701a2701c2601c2401c2401c2201c220
0010001c3f6703c6503a6503864031640306302d6302c620296203f6703c6503a650376402f6402c6302b63028620276203f6703c6503a650376402f6402d6302963027620256203f6703c60038600366002b600
001000003c7000e000150001d0002100023000250002600028000280002700024000277001b0001500026700100000d0000c0000c0003b6000d0000f0001200032000336002c3001c00022000280000000028000
00100000070000d0000c00004000040000200001000010000a000090000a00009000090000100001000010000100001000010002c000000000a0000a0000e0001100002000010000000000000000000000001000
__music__
00 42424344

