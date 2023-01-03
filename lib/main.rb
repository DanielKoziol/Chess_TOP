# figures classes will have their own classes created.
# methods will be problably similiar so first one here
# Bishop - will be created by Game four times.
#[0-col(a-h),0-row(1-8)]
class Pieces #to be inherited

  def in_board_proc
    Proc.new { |n| n < 8 } #to be changed to block_board for tests
  end

  def initialize (current_pos = [2,0], player = 'White')
    @current_pos = current_pos
    @player = player
    @taken = false
  end

end

class Bishop # < Pieces
  attr_reader :name, :player

  def initialize (current_pos = [2,0], player = 'White')
    @current_pos = current_pos
    @player = player
    @taken = false
    @name = 'Bishop'
  end

  def set_current_pos(move)
    @current_pos = [move]
  end

  def taken
    @current_pos = nil
    @taken = true
  end

  
  def b_list_valid_moves #catalouge of all possible moves needed for check checks
    block_board = Proc.new { |n| n < 8 }
    curr_pos = @current_pos
    val_moves = []
    x = 1
    until x > 8
      val_moves << [curr_pos[0]+x, curr_pos[1]+x] if ([curr_pos[0]+x, curr_pos[1]+x].all?(block_board))
      val_moves << [curr_pos[0]-x, curr_pos[1]+x] if ([curr_pos[0]-x, curr_pos[1]+x].all?(block_board))
      val_moves << [curr_pos[0]+x, curr_pos[1]-x] if ([curr_pos[0]+x, curr_pos[1]-x].all?(block_board))
      val_moves << [curr_pos[0]-x, curr_pos[1]-x] if ([curr_pos[0]-x, curr_pos[1]-x].all?(block_board))
      x += 1
    end
    val_moves
  end

  def free_trail(move)
    p "free trail?"
  end

  def b_val_move_value(move) #bishop specifc check - also applicable for one of the Queen's possibilities
    move[0].abs == move[1].abs 
  end
end

class Pawn (current_pos = [0,1], player = 'Black')
  attr_reader :name, :player

  @current_pos = current_pos
  @player = player
  @taken = false
  @name = 'Pawn'
end

class King
end

class Tower
end


class Game
  COORDINATE = {b: [[2, 0],[5, 0]]}
  MOVE_MAP = {a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7}
  CASTLING = ["0-0-0", "0-0"]
  #initialize -> create white figures: e.g.loop 9times Pawn, on iteration +[0,1]; create board
  attr_accessor :board_state

  def initialize (board = Board.new) #pieces = create_pieces
    @board_state = board
    @current_player = 'White'
    # @current_player / or @count_moves? or both?
    create_bishops #create_pieces
  end

  def current_player
    @current_player
  end

  def white_bish
    COORDINATE[:b]
  end
  
  def create_bishops
    xy = white_bish
    i = 0
    while i < 2
      piece = Bishop.new(xy[i])
      @board_state.update_board(xy[i].to_pos, piece)
      i += 1
    end
  end

  def names #pieces name catalogue, iterate over by taking name to coordinate hash[named by names]
p "names"
  end

  def create_pieces
    #white and black separately
    create_white_pieces("White")
    update_board#board need to be updated when creating pieces
  end

  def get_input #checks included if inside a-h and 1-8 and, hopefully, pattern check. (verify_input). Then (verify_move(board)
    loop do
      puts "input your move. eg. a2-a4"
      user_input = gets.chomp
      verified_input = input_checks(user_input)
      return verified_input if verified_input
    end
  end

  def input_checks(input)
    p "in checks"
    return input if CASTLING.include?(input)

    return input #add other checks
  end

  def input_to_move_coord(input) #add error handling - if error return "please verify your input" 
    return input if CASTLING.include?(input)
#maybe include get_input method here? input = get_input and remove paramter
#error catching included here if any error then re-start    
    y1 = get_col(input[0])
    y2 = get_col(input[-2])
    x1 = input[1].to_i
    x2 = input[-1].to_i
    #how to indicate which Piece is moving? e3-e4  #.downcase
    [[y1, x1-1],[y2, x2-1]] 
  end

  def get_col(letter)
    MOVE_MAP[letter.to_sym]
  end

  def get_move
    move = input_to_move_coord(get_input)
    #verified_move = []
    if CASTLING.include?(move)
      verified_move = verify_castling(move)
    else
      verified_move = verify_move(move)
    end

    return move if verified_move
  end

  def no_piece
    p "no such piece!"
    false
  end

  def verify_move(move)
    piece = get_piece_f_board(move[0])
    piece1 = get_piece_f_board(move[1])
    return no_piece if piece.nil?

    [piece.player == current_player,
     piece.b_list_valid_moves.include?(move[1]),
     #piece.free_trail(move),
     (!piece1.nil? ? piece1.player != self.current_player : true)].all?(true)
    #not nil
    #not same colour unless valid rozszada
    #nothing in between target unless knight
  end

  def move_logic
     move = get_move
     # move_from = move[0]
     # move_to = move[1]
     return castling(move) if CASTLING.include?(input)

     return move_branch(move) if board_free_or_take(move)
     
     return take_branch(move)
  end

  def move_branch(move) #anything else to check?
    #en passant check - add taking to move if passed
    p "move!"
    make_move(move[0], move[1])
  end

  def take_branch(move)
    p "take!"
    take(move[1])
    make_move(move[0], move[1])
  end

  def verify_castling?(move)
  #implement with King class?
  end

  def castling(move)
    #move == '0-0' - short, else long
    p "castling!"
  end

  def castling_short #implement with King class?
    piece1 = get_piece_f_board([0,4])
    piece2 = get_piece_f_board([0,7])
    check_board_free([0,5].to_pos) && check_board_free([0,6].to_pos)
    piece1.name == 'King' && piece2.name == 'Tower' && piece1.colour == piece2.colour
  end

  def castling_long  #implement with King class?
    piece1 = get_piece_f_board([0,4])
    piece2 = get_piece_f_board([0,0])
    check_board_free([0,1].to_pos) && check_board_free([0,2].to_pos) && check_board_free([0,3].to_pos) 
    piece1.name == 'King' && piece2.name == 'Tower' && piece1.colour == piece2.colour
  end

  def move_in_board(move) #NOT NEEDED? checks if after move inside board - probably valid for all figures - part of Game class
    current_pos = @current_pos
    (current_pos[0] + move[0]).between?(0, 7) && (current_pos[1] + move[1]).between?(0, 7)
  end

  def board_free_or_take(move_to) # to be moved to Board class. Reads [move] coordinates. If .nil proceeds with move. Else checks colour for Take
    return true if @board_state.check_board_free(move_to.to_pos) # calls Board func with move-arg /how to call it.... Board should be init in Game
  
    false
  end 

  def take(move_to)
    piece_taken = get_piece_f_board(move_to)#board update with make_move?
    piece_taken.taken
  end

  def take_valid(move_to)
    piece = get_piece_f_board(move_to)
    piece.colour == current_player
    #checks colour of self and of target piece
  end

  def get_piece_f_board(move)
    pos = move.to_pos
    @board_state.get_piece(pos)
  end

  def make_move(move_from, move_to)
    piece = get_piece_f_board(move_from)
    update_board(move_to.to_pos, piece)
    piece.set_current_pos(move_to) # !need to ensure Piece is calling itself
  end

  def print_b
    @board_state.print_board
  end

end

class Array
  BOARD_TABLE = (0..7).to_a.product((0..7).to_a)

  def to_pos
    BOARD_TABLE.index(self)
  end

end

class Board #with Board communicating only with "pos"(integers represnting coordinates)

  #BOARD_TABLE = (0..7).to_a.product((0..7).to_a)
  attr_accessor :board

  def initialize(board = create_board)
    @board = board
  end

  def create_board
    Array.new(64)
  end

  def check_board_free(pos)
    board[pos].nil?
  end


  def update_board(new_pos, piece, current_pos = nil)
    @board[current_pos] = nil unless current_pos.nil?
    #p new_pos
    #p piece
    @board[new_pos] = piece unless piece.nil? #nil if the piece is taken
  end

  def get_piece(pos)
    @board[pos]
  end

  #def coordinates(x_y) # returns index of the given coordinates of the move / add coordinates to Array class ->
    #-> BOARD_TABLE.index(self) // or add before a = self -> index(a)
   # BOARD_TABLE.index(x_y)
  #end

  def print_board #preety print board?
    x = 6
    until x < 0
      y = 0
      line = []
      until y > 7
        piece = get_piece([y, x].to_pos)
        state = piece.nil? ? nil : piece.name
        line << state
        y += 1
      end
      print "#{line} \n"
      x -= 1
    end
    #method to print row after row (loop to append 8 elemtns and print them)
  end

end

gra = Game.new
gra.print_b
p "konik"
p gra.get_piece_f_board([2,0]).name
p [3,0].to_pos
