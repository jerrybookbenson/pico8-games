pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--plane-battle 
--by jerry benson
--this is a cool & fun game
function _init()
  game_over = true
  is_singleplayer = true
end


function setup()
  speed = .125
  other_speed = .0625
  
  pause = false 
  is_crashing = false
  war = "ww2"
  --player direction spr
  if (war == "ww1") then
    pl1_n = 163
    pl1_ne = 179
    pl1_e = 130
    pl1_se = 146
    pl1_s = 162
    pl1_sw = 178
    pl1_w = 131
    pl1_nw = 147
    pl1_flame_spr = 132
    
    pl2_n = 161
    pl2_ne = 177
    pl2_e = 128
    pl2_se = 144
    pl2_s = 160
    pl2_sw = 176
    pl2_w = 129
    pl2_nw = 145
    pl2_flame_spr = 148
    
    --player spr when hit
    pl1_n_h = 175
    pl1_ne_h = 191
    pl1_e_h = 142
    pl1_se_h = 158
    pl1_s_h = 174
    pl1_sw_h = 190
    pl1_w_h = 143
    pl1_nw_h = 159
  
    pl2_n_h = 173
    pl2_ne_h = 189
    pl2_e_h = 140
    pl2_se_h = 156
    pl2_s_h = 172
    pl2_sw_h = 188
    pl2_w_h = 141
    pl2_nw_h = 157

    zepplin_left_spr = 166 
    zepplin_middle_spr = 167
    zepplin_right_spr = 168

    balloon_nw_spr = 137
    balloon_ne_spr = 138
    balloon_sw_spr = 153
    balloon_se_spr = 154

    bullet_spr_horiz = 164 
    bullet_spr_vert = 164
    
    bomb_spr = 183
  elseif (war == "ww2") then
    pl1_n = 87
    pl1_ne = 74
    pl1_e = 71
    pl1_se = 106
    pl1_s = 119
    pl1_sw = 122
    pl1_w = 103
    pl1_nw = 90
    pl1_flame_spr = 101
    
 
    pl2_n = 104
    pl2_ne = 73
    pl2_e = 88
    pl2_se = 105
    pl2_s = 72
    pl2_sw = 121
    pl2_w = 120
    pl2_nw = 89
    pl2_flame_spr = 117
  
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

    allied_bomber_ne = 108
    allied_bomber_se = 124
    allied_bomber_nw_1 = 107
    allied_bomber_sw_1 = 123
    allied_bomber_nw_2 = 109
    allied_bomber_sw_2 = 125

    german_bomber_nw = 75
    german_bomber_sw = 91
    german_bomber_ne_1 = 76
    german_bomber_se_1 = 92
    german_bomber_ne_2 = 77
    german_bomber_se_2 = 93
   
    
    bullet_spr_horiz = 70
    bullet_spr_vert = 86

    mortar_spr = 116
  elseif (war == "ww3") then
    pl1_n = 227
    pl1_ne = 243
    pl1_e = 194
    pl1_se = 210
    pl1_s = 226
    pl1_sw = 242
    pl1_w = 195
    pl1_nw = 211
    pl1_flame_spr = 201
    
    pl2_n = 225
    pl2_ne = 241
    pl2_e = 192
    pl2_se = 208
    pl2_s = 224
    pl2_sw = 240
    pl2_w = 209
    pl2_nw = 145
    pl2_flame_spr = 217
    
    --player spr when hit
    pl1_n_h = 231
    pl1_ne_h = 247
    pl1_e_h = 198
    pl1_se_h = 214
    pl1_s_h = 230
    pl1_sw_h = 246
    pl1_w_h = 199
    pl1_nw_h = 215
  
    pl2_n_h = 229
    pl2_ne_h = 245
    pl2_e_h = 196
    pl2_se_h = 212
    pl2_s_h = 228
    pl2_sw_h = 244
    pl2_w_h = 197
    pl2_nw_h = 213

    bullet_spr_horiz = 216 
    bullet_spr_vert = 200

  end
  
  pl1_rubble_spr1 = 0
  pl1_rubble_spr2 = 16
  pl2_rubble_spr1 = 32
  pl2_rubble_spr2 = 48
  
  flame_tail_spr1 = 2 
  flame_tail_spr2 = 3

  

  

  explosion_spr = 100
  explosion_nw_spr = 68
  explosion_sw_spr = 84
  explosion_ne_spr = 69
  explosion_se_spr = 85
  
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
  

function make_actor(x, y, spr, d,  speed_y , speed_x,explosion_y )
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
  a.turn_count = 0
  a.explosion_y = explosion_y
  a.explosion_counter = 0
  add(actors,a)
  return a 
end

function _update()
  if (not game_over) then
    --switch back to normal any players that were hit in last loop and show hit sprite
    switch_back(pl1)
    switch_back(pl2)
    for actor in all(actors) do
      check_boundaries(actor)
    end
    pl1_speed = control_players (pl1, pl1_flame_spr, pl1_n, pl1_s, pl1_w, pl1_e, pl1_nw, pl1_sw, pl1_se, pl1_ne,0, pl1_turn_count)
    if (is_singleplayer == false) then
      pl2_speed = control_players (pl2, pl2_flame_spr, pl2_n, pl2_s, pl2_w, pl2_e, pl2_nw, pl2_sw, pl2_se, pl2_ne,1, pl2_turn_count)
    end
    if (is_singleplayer) then
      singleplayer()
    end
    move_player (pl1, pl1_flame, pl1_flame_spr,pl1_speed)
    move_player (pl2, pl2_flame, pl2_flame_spr,pl2_speed)
    move_bullets ()
    if(war == "ww1") then
      move_zepplins()
      move_balloons()
      move_bombs()
     
    elseif (war == "ww2") then 
      move_mortars()
      move_bombers()
    end
    check_collision(pl1, pl1_flame_spr)
    check_collision(pl2, pl2_flame_spr)
  
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

function check_collision(pl, flame_spr, flame)
  for actor in all(actors) do
		if (actor.spr == bullet_spr_horiz or actor.spr == bullet_spr_vert or actor.spr == mortar_spr or actor.spr == explosion_spr or is_exploding_spr(actor.spr) or actor.spr == bomb_spr) then
      if (actor.x >  pl.x -.7  
        and actor.x < pl.x +.7  
        and actor.y > pl.y - .7  
        and actor.y <  pl.y +.7) then  
        del (actors, actor)
        if (not is_crashing) then
          pl.damage = pl.damage + 1
          switch(pl) 	
          if (pl.damage == game_over_damage or actor.spr == explosion_spr or is_exploding_spr(actor.spr)) then
            pl.damage = game_over_damage
            is_crashing = true;
            pl.spr = flame_spr
            if (pl == pl1) then
              pl1_flame = make_actor(pl.x ,pl.y - 1, flame_tail_spr1)
            else 
              pl2_flame = make_actor(pl.x ,pl.y - 1, flame_tail_spr1)
            end
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
    print (" up:single player", 12, 20, 5) 
    print (" down:multiplayer player", 12, 30, 5) 
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

function move_ordanance(actor, ordanance_spr,ordanance_speed)
  
    if (actor.spr == ordanance_spr) then
      if ((actor.direction == "n" and actor.y <= actor.explosion_y) or (actor.direction == "s" and actor.y >= actor.explosion_y)) then
        del(actors,actor)
        make_actor(actor.x,actor.y, explosion_spr)
      end
      actor.y = actor.y + ordanance_speed
    elseif (actor.spr == explosion_spr) then
      actor.explosion_counter = actor.explosion_counter + 1 
      if (actor.explosion_counter == 10) then
        make_actor(actor.x - .5 ,actor.y - .5, 68)
        make_actor(actor.x - .5,actor.y + .5, 84)
        make_actor(actor.x + .5,actor.y - .5, 69)
        make_actor(actor.x + .5,actor.y + .5, 85)
        del(actors,actor)
      end
    elseif (is_exploding_spr(actor.spr)) then
      actor.explosion_counter = actor.explosion_counter + 1 
      if (actor.explosion_counter == 30) then
        del(actors,actor)
      end
    end
end 

function is_exploding_spr(actor_spr)
  return (actor_spr == explosion_ne_spr or actor_spr == explosion_nw_spr or actor_spr == explosion_se_spr or actor_spr == explosion_sw_spr) 
end

function move_zepplins()
  if(flr(rnd(300)) == 1) then
    make_actor(min_x - 2,min_y + .3, zepplin_left_spr)
    make_actor(min_x - 1,min_y + .3, zepplin_middle_spr)
    make_actor(min_x,min_y + .3, zepplin_right_spr)
  end
 
  for actor in all(actors) do
    if (actor.spr == zepplin_left_spr or actor.spr == zepplin_middle_spr or actor.spr == zepplin_right_spr) then
      actor.x = actor.x + other_speed
      
      if(actor.x >= max_x + 1) then
        del(actors,actor)
      end
    end
  end    
end

function move_balloons()
  if(flr(rnd(300)) == 1) then
    make_actor(max_x + 1,min_y + .3, balloon_ne_spr)
    make_actor(max_x,min_y + .3, balloon_nw_spr)
    make_actor(max_x + 1,min_y + 1.3, balloon_se_spr)
    make_actor(max_x, min_y + 1.3, balloon_sw_spr)
  end
  
  for actor in all(actors) do
    if (actor.spr == balloon_nw_spr or actor.spr == balloon_ne_spr or actor.spr == balloon_sw_spr or actor.spr == balloon_se_spr) then
      actor.x = actor.x - other_speed
      
      if(actor.x <= min_x - 1) then
        del(actors,actor)
      end
    end
  end    
end

function move_bombs()
  for actor in all(actors) do
    if (actor.spr == zepplin_middle_spr or actor.spr == balloon_sw_spr) then 
      if(flr(rnd(100)) == 1) then
        make_actor(actor.x,actor.y,bomb_spr,"s",  nil, nil, rnd(max_y - 4)+ 4)
      end 
    end
    move_ordanance (actor,bomb_spr,speed)
  end
end

function move_bombers()
  if(flr(rnd(300)) == 1) then
    make_actor(max_x + 1,min_y + .3,allied_bomber_ne)
    make_actor(max_x,min_y + .3, allied_bomber_nw_1)
    make_actor(max_x + 1,min_y + 1.3,allied_bomber_se)
    make_actor(max_x, min_y + 1.3,allied_bomber_sw_1)
  
  end
  if(flr(rnd(300)) == 1) then
    make_actor(min_x,min_y + .3,german_bomber_ne_1)
    make_actor(min_x - 1,min_y + .3, german_bomber_nw)
    make_actor(min_x,min_y + 1.3, german_bomber_se_1)
    make_actor(min_x - 1, min_y + 1.3, german_bomber_sw)
  
  end
  
  for actor in all(actors) do
    if (actor.spr == allied_bomber_ne or actor.spr == allied_bomber_nw_1 or actor.spr == allied_bomber_nw_2 or actor.spr == allied_bomber_se or actor.spr == allied_bomber_sw_1 or actor.spr == allied_bomber_sw_2) then
      actor.x = actor.x - other_speed
      if(actor.x <= min_x - 1) then
        del(actors,actor)
      end
    end
    if (actor.spr == german_bomber_ne_1 or actor.spr == german_bomber_ne_2 or actor.spr == german_bomber_nw or actor.spr == german_bomber_se_1 or actor.spr == german_bomber_se_2 or actor.spr == german_bomber_sw) then
      actor.x = actor.x + other_speed
      if(actor.x >= max_x + 1) then
        del(actors,actor)
      end
    end
  end    
end
  
function move_mortars()
  if (flr(rnd(100)) == 1) then
    make_actor(rnd(max_x), max_y + 1, mortar_spr, "n",speed, 0,rnd(max_y))
  end
  for actor in all(actors) do
    move_ordanance (actor,mortar_spr,-speed)
  end
end

function control_players(pl, pl_flame_spr, pl_n, pl_s, pl_w, pl_e, pl_nw, pl_sw, pl_se, pl_ne,pl_index, pl_turn_count)
  -- left
  if (btn(0,pl_index) and pl.x > min_x and pl.turn_count > 10 and pl.spr != pl_flame_spr ) then 
    pl.is_pressed = true
    pl.turn_count = 0
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
  elseif (btn(1,pl_index) and pl.x < max_x and pl.turn_count > 10  and pl.spr != pl_flame_spr )  then
    pl.is_pressed = true
    pl.turn_count = 0
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

  --bullet  
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

  if (pl.turn_count <= 10) then
    pl.turn_count = pl.turn_count + 1
  end

  --tell when user releases the button for no continuous fire
  if (not btn(0, pl_index) and not btn(1, pl_index) and not btn(4, pl_index)) then 
    pl.is_pressed = false
  end

  -- allow user to slow down
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

  if (not is_crashing) then

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
      	
  end
end



__gfx__
000a0000000a00000000a000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a0000aa00000000aa00000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aa0a0339aa0000000a9a00000a9a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaa903389a0000000a9a00000a9a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
098993333399000000a999a000a999a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
098339330338000000a989a000a989a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
093303a300300000009888aa009888aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03300900000000000998888909988889000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000a0a000000ccaaaacccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a000090aa00000caaaaaaccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a00a0339aa0000aaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaa903389a0000aaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0989933333990000aaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0983393303380000aaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0933030300300000caaaaaaccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0330090000000000ccaaaacccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000000a0000ccc777cc7ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a0000aa0000cc77777777777ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aa0a0559aa0000c7777777777777cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaa905559a0000c777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09599555559900007777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09555955555500007777c7777777777c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0955559500500000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0550090000000000cccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000a0a000000cccccccc777ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a000090aa00000ccc77777777777cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a00a0559aa0000c7777777777777cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaa905559a0000777777777777777c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
095995555599000077777777777777cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0955595555550000c7777777777777cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0955550500500000cc777777777ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0550090000000000ccccc7777ccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088800085558000085580000833800000a009a0900000000000000000000000055500000055000000330000000000000550000005500000000000000000000
8083338000855588085588880833888800900a890080809000005000000333000005550000550000003300000000000005550000055500000000000000000000
38833800088855550855866508338663008909809809890000000000300330000000555500550665003306630000000005750400057500000000000000000000
33836688855555558085565580833633000809899808090000000000330366000555555500055655000336330000000007775400077754000000000000000000
33333333855655855855555838333338009998980088889000000000333333330556550550555550303333300000000005750400057500000000000000000000
83333338858655885555558033333380080988898998a90000000000033333300506550055555500333333005000000005550000055500000000000000000000
08883380080855805588558033883380909890088880009000005000000033000000550055005500330033005500000005550000055500000000000000000000
00083338000855808808555888083338098999888888890800000000000033300000550000005550000033305555555555555550555555500000000000000000
00083808000888000085580000833800089089999899988000000000000030000000000000055000000330000555555555555555555555550000000000000000
080833838085558088885580888833809008898888889a0800000000000033030005550000005500000033000000000005550000055500000000000000000000
8386333358855800566855803668338009898099889989a000000000030633335005500056605500366033000000000005550000055500000000000000000000
83363333558566885565580833633808089999889999890005000050033633335505660055655000336330000000000005750000057504000000000000000000
8333338855555555855555858333338300089089890800a000000000033333005555555505555505033333030000000007775400077754000000000000000000
08883380855555550855555508333333080099808909000000000000000033000555555500555555003333330000000005750000057504000000000000000000
0083338008885588085588550833883300008080a890000000000000000333000000550000550055003300330000000005550000055500000000000000000000
08333800000855588555808883338088000000990800000000000000003330000000555005550000033300000000000000550000005500000000000000000000
00888000000855885885558038833380090090090988333900000000000000000000550050055500300333000050330000000000000033000000000000000000
08333808080855855585580033833800890099800883338800000000003330000000550555055000330330000053111000000000005311100000000000000000
00833883858655555555588033333880008999000883388900000000000330030506555555555000333330000050777000000000000077700000000000000000
88663833855655558555566883333668099888090983333300000000006630330556555505555660033336600000787000000000005078700000000000000000
33333333855555880885556508833363008888900333363300000000333333330555550000055565000333630053777000000000005377700000000000000000
83333338088855800008555500083333988088000333360300000000033333300000550000005555000033330000111000000033005011100000000000000000
08883380008555800008558800083388090090990303300000000000000033000005550000005500000033000000333000000033000033300000000000000000
00833380085558000008555800083338000080000000300000000000000333000055500000005550000033303333333333333333333333330000000000000000
00083338008880000855588508333883000000000988555900000000000033300000000000555005003330030333333333330000033333330000000000000000
00833380085558080085585500833833000000000885558800000000000333000055500000055055000330330000333000000000000033300000000000000000
00833888008558850885555508833333000050000885588900000000000330000005500500055555000333330050111000000000000011100000000000000000
08833333886658558665555886633338000050000985555500555000000333330066505506655550066333300053777000000000005377700000000000000000
83333633555555555655588036333880000050000555565505555500033336335555555556555000363330000050787000000000000078700000000000000000
83333683555555585555800033338000000000000555560500555000033336035555555055550000333300000000777000000000005077700000000000000000
83833808888855808855800088338000000000000505500000000000030330000000550000550000003300000053111000000000005311100000000000000000
08083800008555808555800083338000000000000005500000000000000030000005550005550000033300000000330000000000005033000000000000000000
05050000000050500303000000003030098888990000000000000000000000000000000000000333333000000000000005850000000058500383000000003830
0050500000050500003030000003030009a88a900000000000000000000000000000000000003311113300000000000000585000000585000038300000038300
500500044000500530030005500030030098a9000000000000000000000000000000000000033111111330000000000050050004400050053003000550003003
55555054450555553333303553033333000933330000000000000000000000000000000000331177771133000000000055555054450555553333303553033333
00055554455550000003333553333000333339000000000000000000000000000000000000331178871133000000000000055554455550000003333553333000
00050504405050000003030550303000000333330000000000000000000000000000000000331178871133000000000000058504405850000003830550383000
00005050050500000000303003030000333030000000000000000000000000000000000000331177771133000000000000005850058500000000383003830000
00000505505000000000030330300000000555000000000000000000000000000000000000333111111333000000000000000585585000000000038338300000
05000050004000500300003000500030098888990000000000000000000000000000000000033311113330000000000005000050004000500300003000500030
5500050504000505330003030500030309a88a900000000000000000000000000000000000003333333300000000000055000585040005853300038305000383
005050504050505000303030503030300095a9000000000000000000000000000000000000005333333500000000000000505850405058500030383050303830
00050500000505000003030000030300000955550000000000000000000000000000000000000500005000000000000000058500000585000003830000038300
00505000005050000030300000303000555559000000000000000000000000000000000000000050050000000000000000585000005850000038300000383000
05050504050505000303030503030300000555550000000000000000000000000000000000000005500000000000000005850504058505000383030503830300
50500040505000553030005030300033555050000000000000000000000000000000000000000005500000000000000058500040585000553830005038300033
05000400050000500300050003000030000444000000000000000000000000000000000000000000000000000000000005000400050000500300050003000030
00505000000444000030300000055500000000000000000000000000005555555555500000000000000000000000000000505000000444000030300000055500
00050000555050000003000033303000000000000000000005550055555577755555555000000000000000000000000000050000555050000003000033303000
00050000000555550003000000033333000000000000000000555555555757575555555500000000000000000000000000050000888555550003000088833333
00005555555550000000333333333000000050000000000005555555555777775555555500000000000000000000000000005555555558880000333333333888
55555000000055553333300000003333000000000000000000555555555757575555555500000000000000000000000055555888000055553333388800003333
00055555000500000003333300030000000000000000000005550055555577755555555000000000000000000000000088855555000500008883333300030000
55505000000500003330300000030000000000000000000000000000055555555555500000000000000000000000000055505000000500003330300000030000
00044400005050000005550000303000000000000000000000000000000077770000000000000000000000000000000000044400005050000005550000303000
05000050050004000300003003000500000000000000000000000000000000000000000000000000000000000000000005000050050004000300003003000500
50500055505000403030003330300050000000000000000000000000000000000000000000000000000000000000000058500055585000403830003338300050
05050500050505040303030003030305000000000000000000000000000050500000000000000000000000000000000005850500058505040383030003830305
00505000005050000030300000303000000000000000000000000000000005000000000000000000000000000000000000585000005850000038300000383000
00050500000505000003030000030300000000000000000000000000000055500000000000000000000000000000000000058500000585000003830000038300
40505050005050505030303000303030000000000000000000000000000055500000000000000000000000000000000040505850005058505030383000303830
04000505550005050500030333000303000000000000000000000000000005000000000000000000000000000000000004000585550005850500038333000383
00400050050000500050003003000030000000000000000000000000000000000000000000000000000000000000000000400050050000500050003003000030
05550000000055500333000000003330855580000008555083338000000833380000000008838389000000000000000000000000000000000000000000000000
00555000000555000033300000033300085558000085558008333800008333800000000003983883000000000000000000000000000000000000000000000000
50055500005550053003330000333003508555888855580530833388883338030000000003383833000000000000000000000000000000000000000000000000
05555665566555500333366336633330055556655665555003333663366333300500005003333333000000000000000000000000000000000000000000000000
50055500005550053003330000333003508555888855580530833388883338030000000000333330000000000000000000000000000000000000000000000000
00555000000555000033300000033300085558000085558008333800008333800000000000036300000000000000000000000000000000000000000000000000
05550000000055500333000000003330855580000008555083338000000833380000000000006000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000
00005500000000000000330000000000000855800000000000083380000000000000000008858599000000000000000000000000000000000000000000000000
00505500050000000030330003000000005855800588888800383380038888880000500005895885000000000000000000000000000000000000000000000000
05505500006555550330330000633333055855800865555503383380086333330000000005585855000000000000000000000000000000000000000000000000
00055500005555550003330000333333888555800855555588833380083333330000000005555555000000000000000000000000000000000000000000000000
55555500005550003333330000333000555555800855588833333380083338880000000000555550000000000000000000000000000000000000000000000000
55555600005505503333360000330330555556800855855033333680083383300000000000056500000000000000000000000000000000000000000000000000
00000050005505000000003000330300888888500855850088888830083383000000500000006000000000000000000000000000000000000000000000000000
00000000005500000000000000330000000000000855800000000000083380000000000000005000000000000000000000000000000000000000000000000000
00050500000050000003030000003000080505080008580008030308000838000008000000000000000000000000000000000000000000000000000000000000
05005005000060000300300300006000058050850008680003803083000868000005000000000000000000000000000000000000000000000000000000000000
05505055000565000330303300036300055858550085658003383833008363800055500000000000000000000000000000000000000000000000000000000000
05555555005555500333333300333330055555550855555803333333083333380005000000000000000000000000000000000000000000000000000000000000
00555550055555550033333003333333085555580555555508333338033333330005000000000000000000000000000000000000000000000000000000000000
00056500055050550003630003303033008565800558585500836380033838330005000000000000000000000000000000000000000000000000000000000000
00006000050050050000600003003003000868000580508500086800038030830055500000000000000000000000000000000000000000000000000000000000
00005000000505000000300000030300000858000805050800083800080303080080800000000000000000000000000000000000000000000000000000000000
00550000000000000033000000000000085580000000000008338000000000008080088888800808000000000000000000000000000000000000000000000000
00550500000000500033030000000030085585008888885008338300888888300500005005000050000000000000000000000000000000000000000000000000
00550550555556000033033033333600085585505555568008338330333336805550055555500555000000000000000000000000000000000000000000000000
00555000555555000033300033333300085558885555558008333888333333800000000000000000000000000000000000000000000000000000000000000000
00555555000555000033333300033300085555558885558008333333888333800000000000000000000000000000000000000000000000000000000000000000
00655555055055000063333303303300086555550558558008633333033833800088800000808000000000000000000000000000000000000000000000000000
05000000005055000300000000303300058888880058558003888888003833800005000000050000000000000000000000000000000000000000000000000000
00000000000055000000000000003300000000000008558000000000000833800055500000555000000000000000000000000000000000000000000000000000
__gff__
0000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000
0000000001000000000000000000000000000000010000000000000000000000010101010000000000000000010101010000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1312131313133233131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313132223131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1313131313131313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

