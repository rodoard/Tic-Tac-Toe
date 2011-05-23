class Game

DISPLAY={
human:'X',
computer:'O'
}

STATS_MSG={
  tie:"Tie Game!",
  computer_won: "Computer won!",
  human_won: "You won!"
}

WINNS_OFF_CENTER=[]

["1 2 3", "7 8 9",
 "1 4 7",  "3 6 9"
].each {|w|  WINNS_OFF_CENTER << w.split.to_set}

WINNS_FROM_CENTER=[]

["4 5 6", "2 5 8",
 "1 5 9", "3 5 7"
].each {|w|  WINNS_FROM_CENTER << w.split.to_set}

STRATEGIC={
 center: "5",
 corners: "1 3 7 9"

}

def self.msg_tie
  stats_msg :tie
end 

def self.msg_computer_won
     stats_msg :computer_won
end 

def self.msg_human_won
    stats_msg :human_won 
end 

def self.display(turn)
    DISPLAY[:"#{turn}"]    
end 

def self.is_over?(state)
    winner=winner? state
    over=state[:available].blank? || !winner.blank?
    [over,winner]
end 

def self.next_turn(turn,new_game=false)
    (new_game || computer?(turn)) ? human : computer
end 

def self.computer_move(state)
    is_first_move=state[:computer].blank?
    if is_first_move then
       #get center
       return center if available?(state,center)
       srand
       #otherwise get a corner
       return corners.split[rand 4]    
    else 
       own_center=state[:computer].match center
       
       #play to win
       win=force_win?(own_center,state)
       return win if win
       #no opportunities
       #handle threats       
       
       #force a draw on any side 
       #with two Xs in a row
       hset=to_set state[:human]
       if own_center                    
          draw=force_draw?(wins_off_center,hset,state)
          return draw if draw
       else 
          draw=force_draw?(wins_from_center,hset,state)
          return draw if draw
       end 
         
       #ward off double attack
       is_second_move=state[:computer].split().size==1
       if  is_second_move && own_center      
          parry=ward_off_double_attack(state[:human].split(),state) 
          return parry if parry
       end 
       
       ##no immediate threats no opportunities  random move
       srand 
       max=state[:available].size
       return state[:available].values[rand(max)]
    end
    
end 

def self.computer?(turn)
    turn == computer
end 

def self.human
    "human"
end

private

def self.ward_off_double_attack(hmoves,state)
    if hmoves.size == 2
       hset= hmoves.to_set    
       wins_from_center.each do |w|
         if (w & hset).size == 0            
            w_arr=w.to_a
            hsum=hmoves.inject(0) {|sum,m| m.to_i+sum}
            wfirst=w_arr.first
            wlast=w_arr.last
            unless (hsum==6 && choice=wfirst) || 
                   (hsum==14 && choice=wlast)
              random =Time.now.usec 
              unless (random).odd?
                choice=wfirst
              else
                choice=wlast
              end 
            end  
            return choice
         end 
      end 
    end   
end 

def self.force_win?(own_center,state) 
    cset=to_set state[:computer]
    if own_center then
       win=force_draw?(wins_from_center,cset,state) 
    else 
       win=force_draw?(wins_off_center,cset,state) 
    end
    return win if win  
end

def self.force_draw?(wins,hset,state)
    wins.each do |w|
         if (w & hset).size == 2 then
            choice=(w - hset).first
            return choice if available?(state,choice)
         end
   end
   nil
end 


def self.available?(state,choice)
   state[:available].values.include? choice
end 

def self.wins_from_center
   WINNS_FROM_CENTER
end 

def self.wins_off_center
   WINNS_OFF_CENTER
end 

def self.center
   STRATEGIC[:center]
end 

def self.corners
   STRATEGIC[:corners]
end 

def self.to_set(moves)
    moves.split.to_set
end 

def self.winner?(state)
    hset=to_set state[:human]   
    cset=to_set state[:computer]
    (wins_from_center + wins_off_center).each do |win|
      return computer if win.subset? cset
      return human if win.subset? hset
    end 
    nil
end 

def self.stats_msg(cat)
    STATS_MSG[cat]
end 

def self.computer
    "computer"
end 

end 