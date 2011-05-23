module GameHelper

GAME={
O_IMG:'o.gif',
X_IMG:'x.gif',
BLANK_IMG:'blank.gif'
}

def cell_image(display='B')
  case display
  when 'O'
    GAME[:O_IMG]
  when 'X'
    GAME[:X_IMG]
  else 
    GAME[:BLANK_IMG]
  end  
end 

def computer_turn?(turn)
    Game.computer? turn
end 

def winner_is_computer?(winner)
    Game.computer? winner
end

end
