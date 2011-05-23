class GameController < ApplicationController
      before_filter :do_nothing_unless_xhr, :except=>[:index]

def index
end 

def move
   @cid=params[:cid]
   @new_game= @cid == 'play'
   @display=Game.display params[:turn]
   @turn=params[:turn]
   @next_turn= Game.next_turn(params[:turn], @new_game)
   @stats=params[:stats]
end 

def analyze_state
    (@game_is_over,@winner)= Game.is_over? params[:state]  
    @turn = params[:turn]
    if @game_is_over
         @is_tie=@winner.blank?  
       if @is_tie
          @stats_msg=Game.msg_tie
       else 
          @stats_msg= Game.computer?(@winner) ? Game.msg_computer_won : Game.msg_human_won      
       end        
    else
        if Game.computer? @turn
           @cid=Game.computer_move params[:state] 
        end
    end
    @stats=params[:stats]
end 

private 

def do_nothing_unless_xhr
    render :text=>nil unless request.xhr?
end

end