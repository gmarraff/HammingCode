class HammingCode
  attr_accessor :sec, :word, :hword, :calc_group, :two_multiples, :scomposition, :data_dim

  WORD_VALID = 0
  WORD_NOT_VALID = 1
  WORD_NOT_MULTIPLE = 2
  def initialize(word)
    self.word = word
    self.sec = []
    self.hword = []
    self.scomposition = {}
    self.calc_group = {}
    self.two_multiples = []
  end
  def check
    if self.word.match(/\D/)
      WORD_NOT_VALID
    elsif !two_multiple(self.word.length.to_i)
      WORD_NOT_MULTIPLE
    else
      WORD_VALID
    end
  end
  def work!
    self.word = self.word.split('')
    word_dim = self.word.length
    hamm_dim = calculate_k(word_dim, 1)
    self.data_dim = word_dim + hamm_dim
    split_multiples
    get_composition
    make
  end
  def get_sec
    ret = ''
    self.sec.each {|s| ret += s.to_s}
    ret
  end
  def get_full_word
    ret = ''
    self.hword.each {|h| ret += h.to_s}
    ret
  end
  protected
  #calculate the sec code and make the full word with parity bit
  def make
    self.two_multiples.reverse_each do |tm|
      xor = 0
      self.hword.each_with_index do |d, index|
        xor = xor^d.to_i if !self.scomposition[index.to_s].nil? and self.scomposition[index.to_s].include?tm
      end
      self.sec << xor
      self.hword[tm] = xor
    end
    self.hword.reverse!
  end

  #get the composition of the non-two multiples indexes
  def get_composition
    self.two_multiples.reverse_each do |tm|
      i = self.data_dim
      while i > 1 do
        if !two_multiple(i.to_i)
          self.scomposition[i.to_i.to_s] = [] if self.scomposition[i.to_i.to_s].nil?
          if self.calc_group[i.to_i.to_s].to_i - tm >= 0 and self.calc_group[i.to_i.to_s].to_i != 0
            self.calc_group[i.to_i.to_s] -= tm
            self.scomposition[i.to_i.to_s] << tm
          end
        end
        i -= 1
      end
    end
  end

  #divide the index of the data in multiples of two and not
  def split_multiples
    k = 0
    for i in 1..self.data_dim do
      if !self.two_multiple(i.to_i)
        self.hword[i] = self.word[k]
        self.calc_group[i.to_s] = i
        k += 1
      else
        self.two_multiples << i
      end
    end
  end

  #check if a number is a 2 multiple
  def two_multiple(num)
    k = 0
    is = false
    while 2**k <= num
      is = true if 2**k == num
      k += 1
    end
    is
  end

  #caluclate the length of the SEC word
  def calculate_k(wd, incr)
    k = Math.log2(wd) + incr.to_i
    k = calculate_k(wd, incr.to_i+1) if (2**k)-1 < wd + k
    k
  end
end