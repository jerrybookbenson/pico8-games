pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--plane-battle 
--by jerry benson
--this is a cool & fun game
	
function _init()
  pause = false 
	 	 
	pl1_right = 0
	pl1_left = 32
	pl1_up = 16
	pl1_down = 48
  pl1_flame_spr = 43
  
	pl2_right = 17
	pl2_left = 49
  pl2_up = 33
  pl2_down = 2
     
  flame_tail_spr = 27 

	actors = {} --all actors in world
  game_over = false
  game_over_damage = 2
  middle = 8 
  min_x = .5
  max_x = 15.5
 	min_y = .5
  ground_y = 13
  pl1_damage = 0
  pl2_damage = 0
	bullet_spr = 3 
		  
   
  pl1_spr1 = 32
  pl2_spr1 = 17
		
	pl_speed = .1
  pl1_speed_y = 0
  pl2_speed_y = 0
  pl1_speed_x =  -pl_speed
  pl2_speed_x = pl_speed
 
	bullet_speed = pl_speed * 3 
  pl1_is_pressed = false
  pl2_is_pressed = false
  pl1 = make_actor(max_x - 1, ground_y-1,pl1_spr1)
  pl2 = make_actor(min_x + 1, ground_y-1,pl2_spr1)

end
  

function make_actor(x, y, sp, d)
  a={}
  a.x = x
  a.y = y
  a.frame = 0
  a.spr = sp
  a.direction = d
  add(actors,a)
  return a 
end

function _update()
	if (not game_over) then
		check_boundaries()
		control_players ()
		move_players ()
		move_bullets ()
	end
end

function check_boundaries ()
  if (pl2.y < min_y or  pl2.x > max_x or pl2.x < min_x) then
    pl2_speed_x = 0
    pl2_speed_y = pl_speed
    pl2.spr = pl2_down  
  end
	if (pl1.y < min_y or pl1.x > max_x or pl1.x < min_x) then 
    pl1_speed_x = 0
    pl1_speed_y = pl_speed
    pl1.spr = pl1_down  
  end
  if(pl1.y > ground_y) then
  		game_over = true
  		pl1_damage = game_over_damage  	
		end
	  if(pl2.y > ground_y) then
  		game_over = true
  		pl2_damage = game_over_damage  	
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
  print ("green damage:"..pl1_damage.."    grey damage:"..pl2_damage, 0,120, 9)	 
  if (game_over) then
  	if (pl2_damage == game_over_damage) then
  		print ("green won!!!",50, 10, 8)
    else  
			print ("grey won!!!", 50, 10, 8)
    end
  	print ("press 'a' button to play again", 2, 20, 8)
    if (btn (5)) then
      _init()  
  	end	
	end
end

function move_bullets() 
	for actor in all(actors) do
		if (actor.spr == bullet_spr) then
			if (actor.direction == "up") then
			  actor.y = actor.y - bullet_speed 						
			end
			if (actor.direction == "down") then
				actor.y = actor.y + bullet_speed 						
			end
			if (actor.direction == "right") then
				actor.x = actor.x + bullet_speed 						
			end
			if (actor.direction == "left") then
				actor.x = actor.x - bullet_speed 						
			end
      if (actor.x >  pl1.x -.5 
        and actor.x < pl1.x +.5  
  			and actor.y > pl1.y - .5  
  			and actor.y <  pl1.y +.5) then  
  			del (actors, actor)
  			pl1_damage = pl1_damage + 1		  	
        if (pl1_damage == game_over_damage) then 
          pl1_speed_x = 0
          pl1_speed_y = pl_speed
          pl1.spr = pl1_flame_spr
          pl1_flame = make_actor(pl1.x ,pl1.y - 1, flame_tail_spr)
         
        end						
			end
			if (actor.x >  pl2.x -.5  
	     	and actor.x < pl2.x +.5  
  			and actor.y > pl2.y - .5  
  			and actor.y <  pl2.y +.5) then  
  			del (actors, actor)
  			pl2_damage = pl2_damage + 1  	
				if (pl2_damage == game_over_damage) then 
          game_over = true
        end		   
			end
	  end
  end
end

function control_players()
  -- left
  if (btn(0) and pl1.x > min_x and pl1.spr != pl1_flame_spr) then 
		pl1_speed_y = 0 	 
 	  pl1_speed_x = -pl_speed
    pl1.spr = pl1_left  
  -- right
  elseif (btn(1) and pl1.x < max_x  and pl1.spr != pl1_flame_spr )  then
  	pl1_speed_y = 0
   	pl1_speed_x = pl_speed
  	pl1.spr = pl1_right  
	elseif (btn(2) and pl1.y > min_y  and pl1.spr != pl1_flame_spr)  then
 		pl1_speed_x = 0
   	pl1_speed_y = -pl_speed
  	pl1.spr = pl1_up  
	elseif (btn(3) and pl1.spr != pl1_flame_spr) then
   	pl1_speed_x = 0
   	pl1_speed_y = pl_speed
  	pl1.spr = pl1_down
	elseif (btn(4) and not pl1_is_pressed and pl1.spr != pl1_flame_spr) then
		pl1_is_pressed = true
		if (pl1.spr == pl1_up) then
			make_actor(pl1.x,pl1.y-.6,bullet_spr,"up")
 		end	    	     	    		 
		if (pl1.spr == pl1_down) then
			make_actor(pl1.x,pl1.y+.6,bullet_spr,"down")
 		end	    	     	    		 
		if (pl1.spr == pl1_right) then
			make_actor(pl1.x+.6,pl1.y,bullet_spr,"right")
 		end	    	     	    		 
		if (pl1.spr == pl1_left) then
			make_actor(pl1.x-.6,pl1.y,bullet_spr,"left")
 		end	    	     	    		 
	end
    -- now player 2
  if (btn(0,1) and pl2.x > min_x ) then 
		pl2_speed_y = 0 	 
 	  pl2_speed_x = -pl_speed
		pl2.spr = pl2_left  
  elseif (btn(1,1) and pl2.x < max_x )  then
  	pl2_speed_y = 0
   	pl2_speed_x = pl_speed
  	pl2.spr = pl2_right  
	elseif (btn(2,1) and pl2.y > min_y )  then
 		pl2_speed_x = 0
   	pl2_speed_y = -pl_speed
  	pl2.spr = pl2_up  
	elseif (btn(3,1)) then
   	pl2_speed_x = 0
   	pl2_speed_y = pl_speed
  	pl2.spr = pl2_down
	elseif (btn(4,1) and not pl2_is_pressed) then
		pl2_is_pressed = true
		if (pl2.spr == pl2_up) then
			make_actor(pl2.x,pl2.y-.6,bullet_spr,"up")
 		end	    	     	    		 
		if (pl2.spr == pl2_down) then
			make_actor(pl2.x,pl2.y+.6,bullet_spr,"down")
 		end	    	     	    		 
		if (pl2.spr == pl2_right) then
			make_actor(pl2.x+.6,pl2.y,bullet_spr,"right")
 		end	    	     	    		 
		if (pl2.spr == pl2_left) then
			make_actor(pl2.x-.6,pl2.y,bullet_spr,"left")
 		end	    	     	    		 
	end
	if  (not btn(4)) then
		pl1_is_pressed = false
	end
	if  (not btn(4,1)) then
		pl2_is_pressed = false
	end   
end

function move_players()   
		pl1.x = pl1.x + pl1_speed_x
		pl2.x = pl2.x + pl2_speed_x
		pl1.y = pl1.y + pl1_speed_y
    pl2.y = pl2.y + pl2_speed_y
    if (pl1_flame) then
      pl1_flame.y = pl1_flame.y + pl1_speed_y
    end
end 


__gfx__
00000000000000000055500000000000000000000000000000088800cccccccc000000000000000a0a0000000000000000000000000008000000000000000000
00033300000000000005550000000000000000000000000008808880cccccccc0000000000a000090aa000000000000000000000000088800000000000000000
30033000000000000000555500000000000000000000000000888888cccccccc0000000000a00a0339aa00000000000000000000000003dd0000000000000000
33036600000000000555555500080000000800000000000088880088cccccccc000000000aaaa900389a0000000000000000000000ddee4d0000000000000000
33333333000000000556550500000000000000000000000088888888cccccccc00000000098993333399000000000000000000000eeeee4d0000000000000000
03333330000000000506550000000000000000000000000000888888cccccccc0000000009833933033800000000000000000000000003dd0000000000000000
00003300000000000000550000000000000000000000000088888888cccccccc0000000009330363003000000000000000000000000088800000000000000000
00003330000000000000550000000000000000000000000088888888cccccccc0000000003300960000000000000000000000000000008000000000000000000
0000300000000000a9999998ccc777cc7ccccccc00000000000000000000000000000000000000000000a0000000a00000000000008000000000000000000000
00003303000555008aa998a9cc77777777777ccc0000000000000000000000000000000000aa00000000aa000000aa0000000000088800000000000000000000
03063333500550008a8a989ac7777777777777cc0000000000000000000000000000000000a89000000a9a00000a9a0000000000dd3000000000000000000000
0336333355056600999a9a99c777777777777777000000000000000000000000000000000aa99a00000a9a00000a9a0000000000d4eedd000000000000000000
0333330055555555999199007777777777777777000000000000000000000000000000000a99a90000a999a000a999a000000000d4eeeee00000000000000000
0000330005555555000199007777c7777777777c00000000000000000000000000000000099a889000a989a000a989a000000000dd3000000000000000000000
000333000000550000009900cccccccccccccccc00000000000000000000000000000000a8998989009888aa009888aa00000000088800000000000000000000
003330000000555000000900cccccccccccccccc0000000000000000000000000000000099a98aa9099888890998888900000000008000000000000000000000
0000000000005500ccc3cccccccccccc777ccccccccaaccc980888a00000000000000000989888a0098855590988333900000000000000000000000000000000
0033300000005505cc333cccccc77777777777ccccaaaacc9aa88aa000000000000000008aa88aa008855588088333880000000000dddd000000000000000000
0003300305065555cc333cccc7777777777777cccaaaaaac99a89990000000000000000089a8999008855889088338890000000008d44d800000000000000000
0066303305565555c33433cc777777777777777ccaaaaaaa99a88880000000000000000099a88880098555550983333300000000883ee3880000000000000000
3333333305555500ccc4cccc77777777777777ccaaaaaaaa88881a80000000000000000088881a80055556550333363300000000080ee0800000000000000000
033333300000550044444444c7777777777777cccaaaaaac88881050000000000000000088881050055556050333360300000000000de0000000000000000000
000033000005550044444444cc777777777cccccccaaaacc50880000000000000000000050880000050550000303300000000000000de0000000000000000000
000333000055500044444444ccccc7777ccccccccccccccc008000000000000000000000008000000005500000003000000000000000e0000000000000000000
0000333000000000cccccccc5555555555555555cccccccc0000000000000000a99999980000000a0a0000000000000000000000000000000000000000000000
0003330000555000cccccccc5555555555555555cccccccc00000000000000008aa998a900a000090aa0000000000000000000000000e0000000000000000000
0003300000055005cccccccc5555555555555555cccccccc00000000000000008a8a989a00a00a0559aa00000000000000000000000de0000000000000000000
0003333300665055ccc3cccc5555555555555555cccccccc0000000000000000999a9a990aaaa905589a00000000000000000000000de0000000000000000000
0333363355555555cc333ccc5555555555555555cccccccc00000000000000009991990009899555559900000000000000000000080ee0800000000000000000
0333360355555550cc333ccc45555555555555544444444400000000000000000001990009855955555800000000000000000000883ee3880000000000000000
0303300000005500c33433cc4455555555555544444444440000000000000000000099000955556500500000000000000000000008d44d800000000000000000
0000300000055500ccc4cccc4445555555555444444444440000000000000000000009000550096000000000000000000000000000dddd000000000000000000
00000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000b0000000000000ddd000000000000000000000000000000000000000000000700000000700000000700000000000000000000000000000000000
0000000000ddddd000000000a0ded0a0000000000000000000000000000000000000007007070000007070000007070000000000000000000000000000000000
00000000ee444ed000000000abd4dba0000000000000000000000000000000007070070700700070000700000000700000000000000000000000000000000000
0000000000ddddd000000000a0d4d0a0000000000000000000000000000000000700007000000707000000700700000000000000000000000000000000000000
000000000000b0000000000000d4d000000000000000000000000000000000000007000000700070070007077070070000000000000000000000000000000000
00000000000aaa0000000000000e0000000000000000000000000000000000000070700007070000707000700700707000000000000000000000000000000000
000000000000000000000000000e0000000000000000000000000000000000000007000000700000070000000000070000000000000000000000000000000000
0000000000aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddddd0000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000de444ee0000000000d4d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddddd0000000000a0d4d0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000b000000000000abd4dba0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaa00000000000a0ded0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000100010000000100000000000100010000000000000100000000000000000000
0000000000000000000000000000008000000000000000000000000000000000010000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0725071314070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707232407070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
3535353535353535353535353535353500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

