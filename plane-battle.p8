pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--plane-battle 
--by jerry benson
--this is a cool & fun game
	
function _init()
  pause = false 
	 	 
  pl1_n = 16
  pl1_ne = 15
  pl1_e = 0
  pl1_se = 47
  pl1_s = 48
  pl1_sw = 63 
  pl1_w = 32
  pl1_nw = 31
	pl1_flame_spr = 43
  pl2_n = 33
  
  pl2_ne = 14
  pl2_e = 17
  pl2_se = 46
  pl2_s = 2
  pl2_sw = 62
  pl2_w = 49
  pl2_nw = 30
	pl2_flame_spr = 42
  
  flame_tail_spr = 27 
	actors = {} --all actors in world
  game_over = false
  game_over_damage = 2 
  middle = 8 
  min_x = .5
  max_x = 15.5
 	min_y = .5
  max_y = 14
	bullet_spr_horiz = 3 
	corner_rounding = 1
	pl1_direction = "left"
	pl2_direction = "left"
	pl1_original_direction = "left"
	pl2_original_direction = "left"
		  
  pl_speed = .1
  
  
 
	bullet_speed = pl_speed * 3 

	-- don't allow user to hold down fire button
  pl1_is_pressed = false
  pl2_is_pressed = false
  pl1 = make_actor(max_x - 1,7, pl1_w, "w",  0, -pl_speed)
  pl2 = make_actor(min_x + 1,7, pl2_e, "e",  0,  pl_speed)

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
		check_boundaries()
    control_players (pl1, pl1_flame_spr, pl1_n, pl1_s, pl1_w, pl1_e, pl1_nw, pl1_sw, pl1_se, pl1_ne,0)
    control_players (pl2, pl2_flame_spr, pl2_n, pl2_s, pl2_w, pl2_e, pl2_nw, pl2_sw, pl2_se, pl2_ne,1)
    move_player (pl1, pl1_flame)
    move_player (pl2, pl2_flame)
		move_bullets ()
	end
end

function check_boundaries ()
  if (pl1.y < min_y - .5 and (pl1.direction == "nw" or pl1.direction == "n" or pl1.direction == "ne")) then
    pl1.y = max_y 
  elseif (pl1.y > max_y - .30 and (pl1.direction == "sw" or pl1.direction == "s" or pl1.direction == "se")) then
    pl1.y = min_y - .5  
  elseif (pl1.x > max_x + .5 and (pl1.direction == "se" or pl1.direction == "e" or pl1.direction == "ne")) then
    pl1.x = min_x - .5  
  elseif (pl1.x < min_x - .3 and (pl1.direction == "sw" or pl1.direction == "w" or pl1.direction == "nw")) then
    pl1.x = max_x + .5
  end  
  if (pl2.y < min_y - .5 and (pl2.direction == "nw" or pl2.direction == "n" or pl2.direction == "ne")) then
    pl2.y = max_y 
  elseif (pl2.y > max_y - .30 and (pl2.direction == "sw" or pl2.direction == "s" or pl2.direction == "se")) then
    pl2.y = min_y - .5  
  elseif (pl2.x > max_x + .5 and (pl2.direction == "se" or pl2.direction == "e" or pl2.direction == "ne")) then
    pl2.x = min_x - .5  
  elseif (pl2.x < min_x - .3 and (pl2.direction == "sw" or pl2.direction == "w" or pl2.direction == "nw")) then
    pl2.x = max_x + .5  
  end
end
  


function draw_actor(a) 
  local sx = (a.x * 8) - 4
  local sy = (a.y * 8) - 4
  spr(a.spr + a.frame, sx, sy)
end

function _draw()
  cls()
  map(0,0,0,0,16,16)
  foreach(actors,draw_actor)
  print ("green damage:"..pl1.damage.."    grey damage:"..pl2.damage, 0,120, 9)	 
  if (game_over) then
  	if (pl2.damage == game_over_damage) then
      print ("green won!!!",50, 10, 8)
      -- if (first_time = true) then 
      --  if (pl2_rubble_1.spr = 57) then
      --    pl2_rubble_1 (pl2.x, pl2.y + .2, 59 )
      --    pl2_rubble_2 (pl2.x + 1, pl2.y + .2, 60)
      --    del (actors, pl2)
      --    del (actors, pl2_flame)
      --  else pl2_rubble_1_1 (pl2.x, pl2.y + .2, 57 )
      --    pl2_rubble_1_2 (pl2.x + 1, pl2.y + .2, 58)
      --   end
      -- end
      --first_time = false
      make_actor (pl2.x, pl2.y + .2, 57 )
      make_actor (pl2.x + 1, pl2.y + .2, 58)
      del (actors, pl2)
      del (actors, pl2_flame)
      
    else 
      print ("grey won!!!", 50, 10, 8)
      make_actor (pl1.x, pl1.y + .2, 9 )
      make_actor (pl1.x + 1, pl1.y + .2, 10)
      del (actors, pl1)
      del (actors, pl1_flame)
    end
  	print ("press 'a' button to play again", 2, 20, 8) 
    if (btn (3) or btn (3,1)) then 
      _init()  
  	end	
	end
end

function move_bullets() 

	for actor in all(actors) do
		if (actor.spr == bullet_spr) then
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

      if (actor.y < min_y - .5 and (actor.direction == "nw" or actor.direction == "n" or actor.direction == "ne")) then
        actor.y = max_y 
      elseif (actor.y > max_y - .30 and (actor.direction == "sw" or actor.direction == "s" or actor.direction == "se")) then
        actor.y = min_y - .5  
      elseif (actor.x > max_x + .5 and (actor.direction == "se" or actor.direction == "e" or actor.direction == "ne")) then
        actor.x = min_x - .5  
      elseif (actor.x < min_x - .3 and (actor.direction == "sw" or actor.direction == "w" or actor.direction == "nw")) then
        actor.x = max_x + .5
      end

      actor.bullet_counter += 1 
      if (actor.bullet_counter == 30) then
        del(actors,actor)
      end

      if (actor.x >  pl1.x -.5 
        and actor.x < pl1.x +.5  
  			and actor.y > pl1.y - .5  
  			and actor.y <  pl1.y +.5) then  
  			del (actors, actor)
  			pl1.damage = pl1.damage + 1		  	
        if (pl1.damage == game_over_damage) then 
          pl1.speed_x = 0
          pl1.speed_y = pl_speed
          pl1.spr = pl1_flame_spr
          pl1_flame = make_actor(pl1.x ,pl1.y - 1, flame_tail_spr)
          
        end						
			end
			if (actor.x >  pl2.x -.5  
	     	and actor.x < pl2.x +.5  
  			and actor.y > pl2.y - .5  
  			and actor.y <  pl2.y +.5) then  
  			del (actors, actor)
  			pl2.damage = pl2.damage + 1  	
				if (pl2.damage == game_over_damage) then 
          pl2.speed_x = 0
          pl2.speed_y = pl_speed
          pl2.spr = pl2_flame_spr
          pl2_flame = make_actor(pl2.x ,pl2.y - 1, flame_tail_spr)
        end		   
			end
	  end
  end
end

function control_players(pl, pl_flame_spr, pl_n, pl_s, pl_w, pl_e, pl_nw, pl_sw, pl_se, pl_ne,pl_index)
  
  -- left
  if (btn(0,pl_index) and pl.x > min_x and not pl.is_pressed and pl.spr != pl_flame_spr ) then 
    pl.is_pressed = true
    if(pl.direction == "n") then 
      pl.speed_y = -pl_speed
 	    pl.speed_x = -pl_speed
      pl.spr = pl_nw 
      pl.direction = "nw" 

    elseif(pl.direction == "nw") then 
      pl.speed_y =  0	 
 	    pl.speed_x = -pl_speed
      pl.spr = pl_w 
      pl.direction = "w" 
    
    elseif(pl.direction == "w") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x = -pl_speed
      pl.spr = pl_sw 
      pl.direction = "sw" 
       
    elseif (pl.direction == "sw") then 
      pl.speed_y =  pl_speed	 
      pl.speed_x = 0
      pl.spr = pl_s 
      pl.direction = "s" 
    
    elseif (pl.direction == "s") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x = pl_speed
      pl.spr = pl_se 
      pl.direction = "se" 
       
    elseif(pl.direction == "se") then 
      pl.speed_y = 0 	 
      pl.speed_x = pl_speed
      pl.spr = pl_e 
      pl.direction = "e" 
      
    elseif(pl.direction == "e") then 
      pl.speed_y = -pl_speed 	 
      pl.speed_x = pl_speed
      pl.spr = pl_ne 
      pl.direction = "ne" 

    elseif(pl.direction == "ne") then 
      pl.speed_y = -pl_speed	 
      pl.speed_x = 0
      pl.spr = pl_n 
      pl.direction = "n" 
    end
  --right  
  elseif (btn(1,pl_index) and pl.x < max_x  and not pl.is_pressed  and pl.spr != pl_flame_spr )  then
    pl.is_pressed = true
    if(pl.direction == "n") then 
      pl.speed_y = -pl_speed
 	    pl.speed_x =  pl_speed
      pl.spr = pl_ne
      pl.direction = "ne" 

    elseif(pl.direction == "ne") then 
      pl.speed_y =  0	 
 	    pl.speed_x =  pl_speed
      pl.spr = pl_e 
      pl.direction = "e" 
    
    elseif(pl.direction == "e") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x =  pl_speed
      pl.spr = pl_se 
      pl.direction = "se" 
       
    elseif (pl.direction == "se") then 
      pl.speed_y =  pl_speed	 
      pl.speed_x = 0
      pl.spr = pl_s 
      pl.direction = "s" 
    
    elseif (pl.direction == "s") then 
      pl.speed_y =  pl_speed 	 
      pl.speed_x = -pl_speed
      pl.spr = pl_sw
      pl.direction = "sw" 
       
    elseif(pl.direction == "sw") then 
      pl.speed_y = 0 	 
      pl.speed_x = -pl_speed
      pl.spr = pl_w 
      pl.direction = "w" 
      
    elseif(pl.direction == "w") then 
      pl.speed_y = -pl_speed 	 
      pl.speed_x = -pl_speed
      pl.spr = pl_nw 
      pl.direction = "nw" 

    elseif(pl.direction == "nw") then 
      pl.speed_y = -pl_speed	 
      pl.speed_x = 0
      pl.spr = pl_n 
      pl.direction = "n" 
    end
  	  

	elseif (btn(4,pl_index) and not pl.is_pressed and pl.spr != pl_flame_spr) then
		pl.is_pressed = true
    if (pl.spr == pl_nw) then
			make_actor(pl.x-.6,pl.y-.6,bullet_spr,"nw")
    end
    if (pl.spr == pl_sw) then
			make_actor(pl.x-.6,pl.y+.6,bullet_spr,"sw")
    end
    if (pl.spr == pl_se) then
			make_actor(pl.x+.6,pl.y+.6,bullet_spr,"se")
    end
    if (pl.spr == pl_ne) then
			make_actor(pl.x+.6,pl.y-.6,bullet_spr,"ne")
    end      
    if (pl.spr == pl_n) then
			make_actor(pl.x,pl.y-.6,bullet_spr,"n")
    end	
		if (pl.spr == pl_s) then
			make_actor(pl.x,pl.y+.6,bullet_spr,"s")
 		end	    	     	    		 
		if (pl.spr == pl_e) then
			make_actor(pl.x+.6,pl.y,bullet_spr,"e")
 		end	    	     	    		 
		if (pl.spr == pl_w) then
      make_actor(pl.x-.6,pl.y,bullet_spr,"w")
     end
  end	
  
  if (not btn(0, pl_index) and not btn(1, pl_index) and not btn(4, pl_index)) then 
    pl.is_pressed = false
  end
end

function move_player(pl,  pl_flame)   
		pl.x = pl.x + pl.speed_x
		pl.y = pl.y + pl.speed_y
    if (pl_flame) then
      pl_flame.y = pl_flame.y + pl.speed_y
		end
end 


__gfx__
00000000000000000055500000000000000000000000000000000000cccccccc000000000000000a0a0000000000000000000000000008000005500000033000
00033300000000000005550000005000000000000000000000000000cccccccc0000000000a000090aa000000000000000000080000088800055000000330000
30033000000000000000555500000000000000000000000000000000cccccccc0000000000a00a0339aa00000000000000000000000003dd0055066500330663
33036600000000000555555500000000050000500000000000000000cccccccc000000000aaaa900389a0000000000000000000000ddee4d0005565500033633
33333333000000000556550500000000000000000000000000000000cccccccc00000000098993333399000000000000000000000eeeee4d5055555030333330
03333330000000000506550000000000000000000000000000000000cccccccc0000000009833933033800000000000000000000000003dd5555550033333300
00003300000000000000550000005000000000000000000000000000cccccccc0000000009330363003000000000000008000000000088805500550033003300
00003330000000000000550000000000000000000000000000000000cccccccc0000000003300960000000000000000000000000000008000000555000003330
0000300000000000a9999998ccc777cc7ccccccc00000000000000000000000000000000000000000000a0000000a00000000000008000000005500000033000
00003303000555008aa998a9cc77777777777ccc0000000000000000000000000000000000aa00000000aa000000aa0008000000088800000000550000003300
03063333500550008a8a989ac7777777777777cc0000000000000000000000000000000000a89000000a9a00000a9a0000000000dd3000005660550036603300
0336333355056600999a9a99c777777777777777000000000000000000000000000000000aa99a00000a9a00000a9a0000000000d4eedd005565500033633000
0333330055555555999199007777777777777777000000000000000000000000000000000a99a90000a999a000a999a000000000d4eeeee00555550503333303
0000330005555555000199007777c7777777777c00000000000000000000000000000000099a889000a989a000a989a000000000dd3000000055555500333333
000333000000550000009900cccccccccccccccc00000000000000000000000000000000a8998989009888aa009888aa00000080088800000055005500330033
003330000000555000000900cccccccccccccccc0000000000000000000000000000000099a98aa9099888890998888900000000008000000555000003330000
0000000000005500ccc3cccccccccccc777ccccccccaaccc980888a00000000000000000989888a0098855590988333900000000000000005005550030033300
0033300000005505cc333cccccc77777777777ccccaaaacc9aa88aa000000000000000008aa88aa008855588088333880008000000dddd005505500033033000
0003300305065555cc333cccc7777777777777cccaaaaaac99a89990000000000000000089a8999008855889088338890000000008d44d805555500033333000
0066303305565555c33433cc777777777777777ccaaaaaaa99a88880000000000000000099a88880098555550983333300000000883ee3880555566003333660
3333333305555500ccc4cccc77777777777777ccaaaaaaaa88881a80000000000000000088881a80055556550333363300000000080ee0800005556500033363
033333300000550044444444c7777777777777cccaaaaaac88881050000000000000000088881050055556050333360300000000000de0000000555500003333
000033000005550044444444cc777777777cccccccaaaacc50880000000000000000000050880000050550000303300000080000000de0000000550000003300
000333000055500044444444ccccc7777ccccccccccccccc008000000000000000000000008000000005500000003000000000000000e0000000555000003330
0000333000000000cccccccc5555555555555555cccccccc0000000000000000a99999980000000a0a0000000000000000000000000000000055500500333003
0003330000555000cccccccc5555555555555555cccccccc00000000000000008aa998a900a000090aa0000000000000000000000000e0000005505500033033
0003300000055005cccccccc5555555555555555cccccccc00000000000000008a8a989a00a00a0559aa00000000000000000000000de0000005555500033333
0003333300665055ccc3cccc5555555555555555cccccccc0000000000000000999a9a990aaaa905589a00000000000000000000000de0000665555006633330
0333363355555555cc333ccc5555555555555555cccccccc00000000000000009991990009899555559900000000000000000000080ee0805655500036333000
0333360355555550cc333ccc45555555555555544444444400000000000000000001990009855955555800000000000000000000883ee3885555000033330000
0303300000005500c33433cc4455555555555544444444440000000000000000000099000955556500500000000000000000000008d44d800055000000330000
0000300000055500ccc4cccc4445555555555444444444440000000000000000000009000550096000000000000000000000000000dddd000555000003330000
00000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000b0000000000000ddd000000000000000000000000000000000000000000000700000000700000000700000000000000000000000000000000000
0000000000ddddd000000000a0ded0a0000000000000000000000000000000000000007007070000007070000007070000000000000000000000000000000000
00000000ee444ed000000000abd4dba0000000000000000000000000000000007070070700700070000700000000700000000000000000000000000000000000
0000000000ddddd000000000a0d4d0a0000000000000000000000000000000000700007000000707000000700700000000000000000000000000000000000000
000000000000b0000000000000d4d000000000000000000000000000000000000007000000700070070007077070070000000000000000000000000000000000
00000000000aaa0000000000000e0000000000000000000000000000000000000070700007070000707000700700707000000000000000000000000000000000
000000000000000000000000000e0000000000000000000000000000000000000007000000700000070000000000070000000000000000000000000000000000
0000000000aaa000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b000000000000000e000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddddd0000000000000e000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000de444ee0000000000d4d00000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddddd0000000000a0d4d0a000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b000000000000abd4dba000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaa00000000000a0ded0a000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000ddd00000000000caaaaaac00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000ccccccccaaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccaaaaaaaaaaccccccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000ccccccccaaaaaaaacccccccc000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000caaaaaac00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000100010000000100000000000100010000000000000100000000000000000000
0000000000000000000000000000008000000000000000000000000000000000010000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0755070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6465661314070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0775070707070707232407070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

