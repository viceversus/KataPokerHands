class Game
  def initialize(black_hand, white_hand)
    @black_hand = Hand.new(black_hand)
    @white_hand = Hand.new(white_hand)
  end

  def winner
    winning_hand = compare_high_cards
  end

  private
    def compare_high_cards
      @black_hand.cards.each_index do |i|
        if @black_hand.high_cards[i] > @white_hand.high_cards[i]
          return :black_hand
        elsif @black_hand.high_cards[i] < @white_hand.high_cards[i]
          return :white_hand
        else
          next
        end
      end
    end
end

class Hand
  attr_reader :cards

  def initialize(hand)
    @cards = hand.map { |card| Card.new(card) }.sort.reverse
  end

  def high_cards
    @high_cards ||= @cards.map(&:value)
  end

  def multiples
    multiples = {}

    @cards.each do |card|
      if multiples[card.value]
        multiples[card.value] += 1
      else
        multiples[card.value] = 1
      end
    end

    multiples.keep_if { |key, value| value > 1 }
  end

  def straight?
    return true if high_cards.include?(14) && ((high_cards & [14, 2, 3, 4, 5]).length == 5)

    (high_cards[0] - high_cards[4] == 4) && (high_cards.uniq.length == 5)
  end

  def flush?
    @cards.map(&:suit).uniq.length == 1
  end

  def straight_flush?
    straight? && flush?
  end
end

class Card
  include Comparable

  SUITS = { 'H' => :heart,
            'D' => :diamond,
            'C' => :club,
            'S' => :spade }
  SPECIAL_CARD = { 'T' => 10,
                   'J' => 11,
                   'Q' => 12,
                   'K' => 13,
                   'A' => 14 }

  attr_reader :value, :suit

  def initialize(card)
    @value = SPECIAL_CARD[card[0]] || card[0].to_i
    @suit = SUITS[card[1]]
  end

  def <=>(other)
    value <=> other.value
  end
end