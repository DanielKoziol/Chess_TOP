# frozen_string_literal: false

require_relative 'main'

describe Board do
  subject(:new_board) {described_class.new}
  let(:mock_bishop) {instance_double(Bishop)}
  let(:mock_pawn) {instance_double(Pawn)}

  context 'when the board is update with Bishop beforehand' do
   before do
     new_board.update_board(3, mock_bishop)
   end
  
   it 'gets Bishop piece (from)3' do
     result = new_board.get_piece(3)
     expect(result).to eq(mock_bishop)
   end

   it 'updates the board from Bishop to Pawn' do
    c_state = new_board.instance_variable_get(:@board)
    expect{ new_board.update_board(3, mock_pawn) }.to change { c_state[3] }.from(mock_bishop).to(mock_pawn)
   end
  end

  it 'it updates board with bishop if place is nil' do
    #expect(new_board).to receive(:current_pos)
    b_state = new_board.instance_variable_get(:@board)
    expect{ new_board.update_board(3, mock_bishop) }.to change { b_state[3] }.to(mock_bishop)
  end

end

describe Game do 
  let(:mock_board) {instance_double(Board)}
  subject(:new_game) {described_class.new(mock_board)}

  before do 
    allow(mock_board).to receive(:update_board)
  end
  it 'creates Bishop twice' do 
    expect(Bishop).to receive(:new).twice.with(instance_of(Array))
    new_game
  end

  it 'sends Bishop, calling :update_board, twice' do 
    expect(mock_board).to receive(:update_board).twice.with(instance_of(Integer), instance_of(Bishop))
    new_game
  end

  it 'checks coordinates of new Bishops' do
    expect(new_game.white_bish).to eq([[2,0], [5,0]])
    new_game
  end

describe '#verify move' do
    subject(:ver_move) {described_class.new}
    let(:mock_bishop) {instance_double(Bishop, player: 'White')}
    let(:taken_pawn) {instance_double(Pawn, player: 'Black')}
    let(:valid_move) {[[2,0],[4,2]]}
    let(:invalid_move) {[[2,0],[2,1]]}

  context 'when the place is taken by black pawn' do
   before do 
    pos = [4,2].to_pos
    ver_move.board_state.update_board(pos, taken_pawn)
   end

   it 'correctly picks black pawn from the board' do
    piece = ver_move.get_piece_f_board([4,2])
    expect(piece).to eq(taken_pawn)
   end

   it 'accepts move to take piece' do
    move = ver_move.verify_move(valid_move)
    expect(move).to eq(true)
   end
  end

  context 'when the place is free it accepts the valid move' do
    it 'returns true' do
    move = ver_move.verify_move(valid_move)
    expect(move).to eq(true)
    end
  end

  context 'when the place is free it doesnt accept invalid move' do
    it 'returns true' do
      wrong_move = ver_move.verify_move(invalid_move)
      expect(wrong_move).not_to eq(true)
    end
  end


end

describe '#get input' do
  subject(:board_move) {described_class.new}
  let(:mock_bishop) {instance_double(Bishop)}
  let(:mock_pawn) {instance_double(Pawn)}
  let(:valid_input) {'e2-e4'}
  let(:valid_coord) {[[4,1],[4,3]]}
  let(:invalid_input) {'z9-55'}
  #let(:new_board) {Board.new} jak to zrobic?
  
  context 'when invalid input given' do
    before do
      allow(board_move).to receive(:gets).and_return(invalid_input)
    end

    xit 'loops correctly ' do
    end
  end

  context 'when valid input given' do
    before do
      allow(board_move).to receive(:gets).and_return(valid_input)
    end

    it 'calls gets and returns coordinates when the input is correct' do
      expect(board_move).to receive(:puts)
      move = board_move.input_to_move_coord(board_move.get_input)
      expect(move).to eq(valid_coord)
    end
  end
end

describe '#get_move' do
  subject(:get_move_game) {described_class.new}
  #let(:mock_bishop) {instance_double(Bishop, player: 'White')}
  let(:taken_pawn) {instance_double(Pawn, player: 'Black')}
  let(:valid_input) {'c2-e4'}
  let(:castling) {'0-0'}
  let(:valid_move) {[[2,0],[4,2]]}
  let(:invalid_move) {[[2,0],[2,1]]}

 context 'when move is given to pos with Bishop' do
  before do 
   #pos = [2,0].to_pos
   #get_move_game.board_state.update_board(pos, mock_bishop)
   allow(get_move_game).to receive(:gets).and_return(valid_input)
  end

  it 'returns valid move' do
    move = get_move_game.get_move
    expect(move).to eq(valid_move)
  end

 end

end

end
