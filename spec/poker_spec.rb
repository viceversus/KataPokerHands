require_relative '../poker.rb'

describe Game do
  before do
    # game1 = Game.new(%w(2H 3D 5S 9C KD), %w(2C 3H 4S 8C AH))
    # game2 = Game.new(%w(2H 4S 4C 2D 4H), %w(2S 8S AS QS 3S))
    # Game.new(%w(2H 3D 5S 9C KD), %w(2C 3H 4S 8C KH))
    # Game.new(%w(2H 3D 5S 9C KD), %w(2C 3H 4S 8C AH))
    # Game.new(%w(2H 3D 5S 9C KD), %w(2D 3H 5C 9S KH))
  end

  context '#winner' do
    context 'when only high card' do
      it 'returns the correct winner when one player wins with a high card' do
        game = Game.new(%w(2H 3D 5S 9C KD), %w(2C 3H 4S 8C AH))
        game.winner.should eq :white_hand
      end

      it 'returns the correct winner when top card is a tie' do
        game = Game.new(%w(2H 3D 5S 9C AD), %w(2C 3H 4S 8C AH))
        game.winner.should eq :black_hand
      end
    end

    context 'when pair' do
    end
  end
end

describe Hand do
  context "on initialization" do
    it "creates 5 cards" do
      hand = Hand.new(%w(2H 3D 5S 9C KD))
      hand.cards.each do |card|
        card.should be_an_instance_of Card
      end
    end
  end

  context '#high_cards' do
    let(:hand) { Hand.new(%w(2H 3D 5S 9C KD)) }
    let(:hand2) { Hand.new(%w(2C 3H 4S 8C AH)) }

    it 'returns a set of cards starting from highest value' do
      hand.high_cards.should eq [13, 9, 5, 3, 2]
      hand2.high_cards.should eq [14, 8, 4, 3, 2]
    end
  end

  context '#multiples' do
    it 'returns card values mapping to number of multiples' do
      hand = Hand.new(%w(2H 3D 5S KC KD))
      hand.multiples.should eq({ 13 => 2 })
    end

    it 'returns proper values for 2 pair' do
      hand = Hand.new(%w(2H 5D 5S KC KD))
      hand.multiples.should eq({ 13 => 2, 5 => 2 })
    end

    it 'returns proper values for 3 of a kind' do
      hand = Hand.new(%w(2H 5D KS KC KD))
      hand.multiples.should eq({ 13 => 3 })
    end

    it 'returns proper values for full house' do
      hand = Hand.new(%w(5H 5D KS KC KD))
      hand.multiples.should eq({ 13 => 3, 5 => 2 })
    end

    it 'returns proper values for 4 of a kind' do
      hand = Hand.new(%w(2H KD KS KC KD))
      hand.multiples.should eq({ 13 => 4 })
    end
  end

  context '#pair?' do
    it 'returns value if pair exists' do
      hand = Hand.new(%w(2H 3D 5S KC KD))
      hand.pair?.should 13
    end
  end

  context '#straight?' do
    it 'returns true if straight' do
      hand = Hand.new(%w(2H 3D 4S 5C 6D))
      hand.straight?.should eq true
    end

    it 'returns false if not straight' do
      hand = Hand.new(%w(2H 3D 4S 5C 7D))
      hand.straight?.should eq false
    end

    it 'returns true if wheel straight' do
      hand = Hand.new(%w(2H 3D 4S 5C AH))
      hand.straight?.should eq true
    end
  end

  context '#flush?' do
    it 'returns true if flush' do
      hand = Hand.new(%w(2H 3H 4H 5H TH))
      hand.flush?.should eq true
    end

    it 'returns false if not flush' do
      hand = Hand.new(%w(2H 3C 4H 5H TH))
      hand.flush?.should eq false
    end
  end

  context '#straight_flush?' do
    it 'returns true if straight and flush' do
      hand = Hand.new(%w(2H 3H 4H 5H 6H))
      hand.straight_flush?.should eq true
    end

    it 'returns false if not straight or flush' do
      hand = Hand.new(%w(2H 3C 4H 5H 6D))
      hand2 = Hand.new(%w(2H 3H 4H 5H TH))
      hand.straight_flush?.should eq false
    end
  end
end

describe Card do
  before do
    @card = Card.new('2H')
    @card2 = Card.new('5D')
    @special_card = Card.new('KC')
    @special_card2 = Card.new('TS')
  end

  context "on initialization" do
    it 'sets the value properly on a number card' do
      @card.value.should eq 2
      @card2.value.should eq 5
    end

    it 'sets the value properly on a special card' do
      @special_card.value.should eq 13
      @special_card2.value.should eq 10
    end

    it 'sets the suit properly' do
      @card.suit.should eq :heart
      @card2.suit.should eq :diamond
      @special_card.suit.should eq :club
      @special_card2.suit.should eq :spade
    end
  end

  context "comparing values" do
    it 'returns 1 if card is higher than other' do
      @card2 <=> @card
    end

    it 'returns -1 if card is lower than other' do
      @card <=> @card2
    end

    it 'returns 0 if card is same as other' do
      @card <=> @card
    end
  end
end