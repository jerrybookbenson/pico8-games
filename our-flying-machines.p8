pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- by julia


function _init()
    actors = {}
    game_over = false
    won = false
    game_over_counter = 0
    wing_pos ="up" 
    flap_counter = 0  
    flap_delay = 10        
    is_fire_pressed = false;   
    prop_counter = 0;
    prop_delay = 1;
    helicopter_direction = "up"
    helicopter_y = 8
    uni_speed = .2
    uni_jump = 2
    missile_speed = .5
    score = 0
    level = 0
    pause_counter = 0
end


function make_rainbow_wall()
    make_actor(1.5,1,187)
    make_actor(1.5,2,183)
    make_actor(1.5,3,188)
    make_actor(1.5,4,184)
    make_actor(1.5,5,190)
    make_actor(1.5,6,187)
    make_actor(1.5,7,183)
    make_actor(1.5,8,188)
    make_actor(1.5,9,184)
    make_actor(1.5,10,190)
    make_actor(1.5,11,187)
    make_actor(1.5,12,183)
    make_actor(1.5,13,188)
     
    make_actor(2.5,1,187)
    make_actor(2.5,2,183)
    make_actor(2.5,3,188)
    make_actor(2.5,4,184)
    make_actor(2.5,5,190)
    make_actor(2.5,6,187)
    make_actor(2.5,7,183)
    make_actor(2.5,8,188)
    make_actor(2.5,9,184)
    make_actor(2.5,10,190)
    make_actor(2.5,11,187)
    make_actor(2.5,12,183)
    make_actor(2.5,13,188)
    
    
    make_actor(.5,1,186)
    make_actor(.5,2,186)
    make_actor(.5,3,186)
    make_actor(.5,4,186)
    make_actor(.5,5,186)
    make_actor(.5,6,186)
    make_actor(.5,7,186)
    make_actor(.5,8,186)
    make_actor(.5,9,186)
    make_actor(.5,10,186)
    make_actor(.5,11,186)
    make_actor(.5,12,186)
    make_actor(.5,13,186)
       
end


function make_unicorn()
    uni_front_bottom=make_actor (4.5,8,154)
    uni_front_top=make_actor(4.5,7,138)
    uni_back_bottom=make_actor(3.5,8,153)
    uni_back_top=make_actor(3.5,7,137)
end


function make_helicopter()
    make_actor(14, 7, 130)
    make_actor(15, 7, 131)
    make_actor(15, 8, 147)
end


function make_actor(x,y,spr)
    a={}
    a.x = x
    a.y = y
    a.spr = spr
    add(actors,a)
  
    return a
end 



function _update()
    if (not game_over) then
        if (level == 0) then
            actors = {}
            make_unicorn()
            make_helicopter()
            make_rainbow_wall()
            pause()
        elseif (level == 1 and score < 1) then
            move_unicorn()
            move_helicopter()
        elseif (level == 1) then
            actors = {}
            make_unicorn()
            make_rainbow_wall()
            pause()
        elseif (level == 2 and score < 2) then
            move_unicorn()
            move_monsters(.1)
        elseif (level == 2) then
            actors = {}
            make_unicorn()
            make_helicopter()
            make_rainbow_wall()
            pause()
        elseif (level == 3 and score < 3) then
            move_unicorn()
            move_helicopter2()
        elseif (level ==3 ) then
            actors = {}
            make_unicorn()
            make_rainbow_wall()
            pause()
        elseif (level == 4 and score < 400) then
            move_unicorn()
            move_monsters(.3)
        else
            game_over = true
            won = true
        end 
    end
end


function pause()
    pause_counter = pause_counter + 1
    if (pause_counter == 100) then
        pause_counter = 0
        level = level + 1
    end
end

function move_monsters(speed)
    local do_spawn=flr(rnd(30)) == 1
    local monster_spr=flr(rnd(3)) + 179
    local monster_y=ceil(rnd(13))

    if (do_spawn) then
        make_actor(15, monster_y, monster_spr)
    end
    for actor in all(actors) do
        if (actor.spr == 179 or actor.spr == 180 or actor.spr == 181) then
            if (hits_unicorn(actor)) then
                actor.spr = 171
                score = score + 1
            elseif (hits_rainbow_wall(actor)) then
                del (actors, actor)
            else
                actor.x = actor.x - speed
            end
        elseif (actor.spr == 171) then
            del (actors, actor)
        end
    end
end


function move_unicorn()
    if(wing_pos=="down" and flap_counter == flap_delay)then
        uni_front_bottom.spr=154
        uni_back_bottom.spr=153
        uni_back_top.spr=137
        wing_pos="up"
        flap_counter = 0
    elseif (flap_counter == flap_delay) then
        uni_front_bottom.spr=152
        uni_back_bottom.spr=151
        uni_back_top.spr=135
        wing_pos="down"
        flap_counter = 0
    else   
        flap_counter  = flap_counter + 1
    end
    
    local speed = uni_speed

    if (btn(4) and not is_fire_pressed) then
        is_fire_pressed = true
        speed = 2
    end
    if (not btn(4)) then
        is_fire_pressed=false
    end
    
    if (btn(3)) then
        uni_back_bottom.y=uni_back_bottom.y + speed
        uni_back_top.y= uni_back_top.y+ speed
        uni_front_bottom.y=uni_front_bottom.y + speed
        uni_front_top.y=uni_front_top.y+ speed
    end
    if (btn(2)) then
        uni_back_bottom.y=uni_back_bottom.y - speed
        uni_back_top.y= uni_back_top.y- speed
        uni_front_bottom.y=uni_front_bottom.y- speed
        uni_front_top.y=uni_front_top.y- speed
    end

    if (uni_back_bottom.y > 14) then
        uni_back_bottom.y = 14
        uni_back_top.y = 13
        uni_front_bottom.y = 14
        uni_front_top.y = 13
    end

    if (uni_back_top.y < .7) then
        uni_back_bottom.y = 1.7
        uni_back_top.y = .7
        uni_front_bottom.y = 1.7
        uni_front_top.y = .7
    end

end

function move_helicopter()
    if ((prop_counter%(prop_delay * 8)) == 0) then
        local change_direction = flr(rnd(4)) == 1
        if (change_direction or helicopter_y < 1 or helicopter_y > 12) then
            if (helicopter_direction == "down") then
                helicopter_direction = "up" 
            else
                helicopter_direction = "down"
            end
        end
    
        if (helicopter_direction == "up") then
            helicopter_y = helicopter_y - .5
        else
            helicopter_y = helicopter_y + .5
        end
    end
    spin_prop()
end


function spin_prop() 
    local fire_missile = flr(rnd(10)) == 1
    
    for actor in all(actors) do
        
        if (actor.spr == 131 and prop_counter%prop_delay ==0) then
            actor.spr = 133
            actor.y = helicopter_y
        elseif (actor.spr == 133 and prop_counter%prop_delay ==0) then
            actor.spr= 163
            actor.y = helicopter_y
        elseif (actor.spr == 163 and prop_counter%prop_delay ==0) then
            actor.spr=165
            actor.y = helicopter_y
        elseif (actor.spr == 165 and prop_counter%prop_delay ==0) then
            actor.spr=131
            actor.y = helicopter_y
        elseif (actor.spr == 130 and prop_counter%prop_delay ==0) then
            actor.spr = 132
            actor.y = helicopter_y
        elseif (actor.spr == 132 and prop_counter%prop_delay ==0) then
            actor.spr= 162
            actor.y = helicopter_y
        elseif (actor.spr == 162 and prop_counter%prop_delay ==0) then
            actor.spr=164
            actor.y = helicopter_y
        elseif (actor.spr == 164 and prop_counter%prop_delay ==0) then
            actor.spr=130
            actor.y = helicopter_y
        elseif (actor.spr == 147) then
            actor.y = helicopter_y + 1
            if (fire_missile) then
                actor.spr = 182
                make_actor (actor.x - 1, actor.y, 134)
            end
        elseif (actor.spr == 182) then
            actor.spr = 147
        elseif (actor.spr == 134) then
            if (actor.x < 0) then
                del (actors, actor)
            elseif (hits_unicorn(actor)) then
                actor.spr = 171
                score = score + 1
            elseif (hits_rainbow_wall(actor)) then
                del (actors, actor)
            else
                actor.x = actor.x - missile_speed
            end
        elseif (actor.spr == 171) then
            del (actors, actor)
        end
    end
    prop_counter = prop_counter + 1
end


function move_helicopter2()
    if ((prop_counter%(prop_delay * 8)) == 0) then
        local change_location = flr(rnd(5)) == 1
        local change_magnitude = rnd(10) - 5
        if (change_location) then
            helicopter_y = helicopter_y + change_magnitude 
            if (helicopter_y < 1 or helicopter_y > 12) then
                helicopter_y = helicopter_y - (2 * change_magnitude)
            end
        end
    end
    spin_prop()
end


function hits_unicorn(bad_actor) 
    return ((bad_actor.x >  uni_back_bottom.x -.7  
        and bad_actor.x < uni_back_bottom.x +.7  
        and bad_actor.y > uni_back_bottom.y - .7  
        and bad_actor.y < uni_back_bottom.y +.7) 
        or (bad_actor.x >  uni_back_top.x -.7  
        and bad_actor.x < uni_back_top.x +.7  
        and bad_actor.y > uni_back_top.y - .7  
        and bad_actor.y < uni_back_top.y +.7)
        or (bad_actor.x >  uni_front_top.x -.7  
        and bad_actor.x < uni_front_top.x +.7  
        and bad_actor.y > uni_front_top.y - .7  
        and bad_actor.y < uni_front_top.y +.7)
        or (bad_actor.x >  uni_front_bottom.x -.7  
        and bad_actor.x < uni_front_bottom.x +.7  
        and bad_actor.y > uni_front_bottom.y - .7  
        and bad_actor.y < uni_front_bottom.y +.7))
end


function hits_rainbow_wall(bad_actor)
    if (bad_actor.x <=.5) then
        for actor in all(actors) do
            if (actor.spr ~= bad_actor.spr and actor.x == .5 and (bad_actor.y < actor.y + .7 and bad_actor.y > actor.y - .7)) then
                game_over = true
                return false
            end
        end
    elseif (bad_actor.x <= 1.5) then
        
        for actor in all(actors) do
            if (actor.spr ~= bad_actor.spr and actor.x == 1.5 and (bad_actor.y < actor.y + .7 and bad_actor.y > actor.y - .7)) then
                del (actors, actor)
                return true
            end
        end
    elseif (bad_actor.x <= 2.5) then
        for actor in all(actors) do
            if (actor.spr ~= bad_actor.spr and actor.x == 2.5 and (bad_actor.y < actor.y + .7 and bad_actor.y > actor.y - .7)) then
                del (actors, actor)
                return true
            end
        end
    end
    return false
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
  print ("SCORE: "..score.." ", 0, 120, 7)
  if (game_over) then
    check_restart()
    if (won) then
        print ("OUR UNICORN HERO!",28, 40, 7)
    else
        print ("WE AWAIT ANOTHER...",28, 40, 7)
    end
    game_over_counter = game_over_counter + 1
    if (game_over_counter == 20 and not won) then   
        for actor in all(actors) do
            if (actor.spr == 186) then
                del(actors, actor)
            end
        end
        make_actor(.5,1,170)
        make_actor(.5,2,170)
        make_actor(.5,3,170)
        make_actor(.5,4,170)
        make_actor(.5,5,170)
        make_actor(.5,6,170)
        make_actor(.5,7,170)
        make_actor(.5,8,170)
        make_actor(.5,9,170)
        make_actor(.5,10,170)
        make_actor(.5,11,170)
        make_actor(.5,12,170)
        make_actor(.5,13,170)
    end

    elseif (pause_counter > 0) then
        if (level == 0) then
            print ("***** UNICORN HERO *****",28, 40, 7)
        elseif (level == 1) then
            print ("ZOMBIES",55, 40, 7)
        elseif (level == 2) then
            print ("IT TELEPORTS",50, 40, 7)
        elseif (level == 3) then
            print ("ZOMBIE APOCOLYPSE",45, 40, 7)
        end
    end
end

function check_restart() 
    if (btn(5,0)) then
        _init()
    end
end


__gfx__
555555550000aa004444444411111111111111110000000011111111111111110000000000000000767777770000000000000000000008875555555555555555
555555550000aa004444444411111111171111110000000011111111111111110000000000030000667677670077770000000000000888875dddddd5ddddddd5
555555558000a0004444444411177711777111110000000011117771111711110000000000333000776367767777777000000000000000075dddddd5ddddddd5
55555555880aa0004444444411777777777111110000000017177777177771110000000000333000776367777777777700000000000000075dddddd5ddddddd5
55555555888aa8804444444417777777777711110000000077777777777777110000000003333300763336760077777077777777000000075555555555555555
55555555000aa0004444444411777777777771110000000077777777777777110000000003333300733333760007700000000000000000075dddddd5ddddddd5
5555555500aa00004444444411171177771111110000000077777777777777110000000003343300763436760000000000000000000000075dddddd5ddddddd5
5555555500aa00004444444411111117177111110000000017777777777771110000000000040000777477770000000000000000000000075555555555555555
000000000000000000000000000000000000000000000000cc7777777c777ccccccccccc1111111111111111cccccccc777777771111111199999999aa000000
000000000000000000000000000000000000000000000000cccccccccccccccccccccccc1177777777777111cccccccc7777777711111111989898980a000000
000000000000777000000000000000000000000000000000cccccccccccccccccccccccc1177777777777111cccccccc7777777711111111989898990aa00000
000000000000770000000000000000000000000000000000ccccccccccccccccccccc6cc1177777777777111cccccccc77777777111111119988998900aaa000
0000000000a7700000a7777000a7700000a7777000000000ccccccccccccccccccc7777c1117777777771111cccccccc7777777711111111988999890000a000
000000000000000000000000000077000000000000000000cccccccccccccccccc7766771111777777711111cccccccc7777777711111111999989990000aa00
0000000000000000000000000000777000000000000000000000000000000000c76777661111111111111111cccccccc77777777111111119898989900000aa0
0000000000000000000000000000000000000000000000000000000000000000777767771111111111111111cccccccc777777771111111198999988000000aa
77777777400000000000000444444444cccccccccccccccc5544554555445545ccccccc77ccccccccccccccccccccccc000000005555555555555555aaa000a0
7766677744000000000000444444444455555555cccccc555545555555545555cccccc7777cccccccccccccccccccccc000000005ddd5dd555555555a00aaa00
77777777444000000000044444444444ccc5cccccccccccc5555555555555555cccccc7666cccccccccccccccccccccc000000005ddd5dd5555555550a000000
77677767444400000000444444444444eeeee11ccceeeeee4445555544455555cccc7766777ccccccccccccc777ccccc000000005ddd5dd55555555500a00000
77666767444440000004444444444444eeeeee11cc55ccee4555555555455555cc776677767c7cccccccc7cc677767cc000000005555555555555555000a0000
77777777444444000044444444444444eeeee11cccccccce5555444555554445cc777777776777ccccc777c77777677c000000005ddd5dd5555555550000aa00
77767666444444400444444444444444ccbccbcccccccccc5555555555555555c66767676677676cc77777776676766c000000005ddd5dd55555555500000aa0
77777777444444444444444444444444bbbbbbbbcccccccc4555555545555555777777777776777c7777777777777777000000005555555555555555000000aa
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000011111111111111111111111111111111000000000000000000000000000000000000000000000000
11111111000000000000000000000000000000000000000011111111171111111111117111111111000000000000000000000000000000000000000900000000
1111111100000000000000000000c000000000000000000011111111111111111111111111111111000000000000000000000000000000000000000000000000
1117777700033333000000000cccc000000000000008880011111111111111111111111111111111000000000000000000000000000000000000000000000000
117777110c53333300c20000011cc000000000000066888011111111111111111111111111111111000000000000000000000000000000000000000000000000
177771110553333322220000ccccc000000cc3330888888811111111111111111111111111111111000000000000000000000000000000000000000000000000
777771115553333322222222cccccccc333333330888888817111111111111111111111111111171000000000000000000000000000000000000000000000000
77771111000070700700007007000700070000070070007011111111111111111111111111111111000000000000000000000000000000000000000000000000
7777111188558888cccccccc11117777777777770000000011111111555555555555555555555555555555550000000000000000000000000000000000000000
777711118855888877777777717188888888888800000000111111115aa55aa5555aaa5555aaa555555555550000000000000000000000000000000000000000
1777111188558888cccacccc111177777787877700000000111111115aa55aa5555aaa5555aaa55555a55a550000000000000000000000000000000000000000
177771115555555577aaa77771718888878887880000000011111111555555555555555555555555555555550000000000000000000000000000000000000000
1177771155555555cccacccc11117777788888770000000011111111555555555555555555555555555555550000000000000000000000000000000000000000
111777778855888877777777888888888788878800000000111111115aa55aa5555aaa5555aaa55555a55a550000000000000000000000000000000000000000
1111111188558888cccccccc777777777778777700000000111111115aa55aa5555aaa5555aaa555555555550000000000000000000000000000000000000000
11111111885588880000000088888888888888880000000011111111555555555555555555555555555555550000000000000000000000000000000000000000
00000000000000000000000000000000555555550000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000055555555000000000000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
00000000000000000000000055555555777777770000000000000000000000000000000000000000455575540000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa000000000000aa0000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000a00000000000000000
0000000000000555000000000000000000000000000000000000000000000000000000000000000000000000000000000aa0a000000a0aa00000000000000000
00000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaa0000aaaa000000000000000000
000000000000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a0000a0a0000000000000000000
000000000055555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00aa000000000000000000000
000000000555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00a0000000000000000000000
0000000055555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa00000000000000000000000
bbbbbbbbb00000000000000ccccccccc000000000ccccc0000000700000000000000000000000000000000000000000000000000000000000000000000000000
0000b0000000000000000000000c000000000000000c0000ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
0000b0000000000000000000000c000000000000000c000000000700000000000000000000000000000000000000000000000000000000000000000000000000
0000b00e0000000000000000e00c00c000000000e00c00c000000000000000000009000000000000000900000000000000009000000000000000900000000000
0bbbb0e00bb0000000000cc00e0cccc000000cc00e0cccc000000000000000000009000000000000000900000000000000009000000000000000900000000000
0000b0eee0b0000000000c0eee0c000000000c0eee0c0000000000000000000000e900000000700000d900000000000000009d000007000000009d0000000000
00000b00be000000000000ec00c00000000000ec00c0000000000000000000000becee00000077000bdcdd000000000000ddcdb00077000000ddcdb000000000
000000bb0ee0000000000ee0cc00000000000ee0cc00000000000000000000000beeee00000077700bdddd000000000000ddddb00777000000ddddb000000000
00000000666666660000000000000700000000000000000000000000000000000bdd0000000007770bdd0000000000000000ddb0777000000000ddb000000000
000000006666666600000000ccccccc0000000000000000000000000000000000bdd0000000000770bdd0000000000000000ddb0770000000000ddb000000000
00000000666666660000000000000700000000000000000000000000000000000bdd0000000000770bdd0000000000000000ddb0770000000000ddb000000000
0000000066666666000000000000000000000000000000000000000000bbddd77ddd000000bbdddddddd0000000000000000ddddddddbb000000ddd77dddbb00
0000000066666666000000000000000000000000000000000000000000bbddd777dd000000bbdddddddd0000000000000000ddddddddbb000000dd777dddbb00
0000000066666666000000000000000000000000000000000000000000b0d007770d000000b0d000000d0000000000000000d000000d0b000000d077700d0b00
0000000066666666000000000000000000000000000000000000000000b0d007700d000000b0d000000d0000000000000000d000000d0b000000d007700d0b00
00000000666666660000000000000000000000000000000000000000000060070006000000006000000600000000000000007000000700000000700070070000
0000b0000000000000000000000c0000000000000ccccc0000000000777777770000000000000000000000000000e00000000000000000000000000000000000
0000b0000000000000000000000c000000000000000c0000000000007777777700000000000000000880088000e0e0e000000000000000000000000000000000
0000b0000000000000000000000c000000000000000c00000000000077777777000000000000000088008888000eee0000000000000000000000000000000000
0b00b00e0000000000000000e00c00c000000000e00c00c000000000777777770000000000000000880008880eee0eee00000000000000000000000000000000
0bbbb0e00bb0000000000cc00e0cccc000000cc00e0cccc00000000077777777000000000000000088800080000eee0000000000000000000000000000000000
0b00b0eee0b0000000000c0eee0c000000000c0eee0c0000000000007777777700000000000000000888080000e0e0e000000000000000000000000000000000
00000b00be000000000000ec00c00000000000ec00c0000000000000777777770000000000000000008880000000e00000000000000000000000000000000000
000000bb0ee0000000000ee0cc00000000000ee0cc00000000000000777777770000000000000000000800000000000000000000000000000000000000000000
00000000000000000000000000050000000000000000000000000000ccccccccaaaaaaaa000000000000000022222222bbbbbbbbeeeeeeee9999999988888888
0000000000000000000000a000111100000bb0000000000000000000ccccccccaaaaaaaa000000000880880022222222bbbbbbbbeeeeeeee9999999988888888
00000000000000000000a0a001000010008bb8000008000000000000ccccccccaaaaaaaabbbbbbbb8888888022222222bbbbbbbbeeeeeeee9999999988888888
000000000000000000c777a000111100006336000a88000b00000000ccccccccaaaaaaaacccccccc8888888022222222bbbbbbbbeeeeeeee9999999988888888
00000000000000000777a7a0500a8005b06bb60b888000b000000000ccccccccaaaaaaaadddddddd8888888022222222bbbbbbbbeeeeeeee9999999988888888
00000000000000000000aa00055bb5500bb33bb00088880000000000ccccccccaaaaaaaaeeeeeeee0888880022222222bbbbbbbbeeeeeeee9999999988888888
000000000000000000000aa05008a005b003300b0080080000000000ccccccccaaaaaaaa000000000088800022222222bbbbbbbbeeeeeeee9999999988888888
0000000000000000000000000050050000b00b000080080000000000ccccccccaaaaaaaa000000000008000022222222bbbbbbbbeeeeeeee9999999988888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009999999900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009898989800000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009898989900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009988998900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009889998900000000000330000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009999899900000000003883300000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009898989900000000333333330000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009899998800000000800333330000000000000000
00000000000000000000000000000000000000000000000000000000000333333333330000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000003333333333000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000003333333330000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000003333000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000033000033000000000000000033000000000000000000000000000000330000000000000000000
00000000000000000000000000000000000000000000000000388330033300000000000000388330000000000000000000000000003883300000000000000000
00000000000000000000000000000000000000000000000033333333333330000000000033333333333333333333333300000000333333333333300000000000
00000000000000000000000000000000000000000000000080033333333333000000000080033333333333333330000000000000800333333333330000000000
99999999999999999999999999999999999999990000000008888833333333330000000008888833333333330000000000000000088888333333333300000000
98989898989898989898989898989898989898980000000080003330000333330000000080003330000333330000000000000000800033300333333300000000
98989899989898999898989998989899989898990000000000330330000033333300000000330330000033333300000000000000003303300033333333000000
99889989998899899988998999889989998899890000000033000003003330003333000033000003003330003333000000000000330000030003333333330000
98899989988999899889998998899989988999890000000000000000030900000033300000000000030900000033300000000000000000000333333300333000
99998999999989999999899999998999999989990000000000000000090090000000300000000000090090000000300000000000000000000900333300003000
98989899989898999898989998989899989898990000000000000000009000000000300000000000009000000000300000000000000000000090003300003000
98999988989999889899998898999988989999880000000000000000000000000003300000000000000000000003300000000000000000000000000333033000
__gff__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000007f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00030001196000f6100f6200d6201f62020620196201a6301a6501f6301f6301d6301963010620136100a60001600026000860003600026000260006600036000260000000000000000000000000000000000000
