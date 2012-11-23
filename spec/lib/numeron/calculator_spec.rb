# coding: utf-8

require 'spec_helper'

describe Numeron::Calculator do
  let(:calc) { Numeron::Calculator.new }
  describe '#input' do
    it "0e0b" do
      calc.input('123', 0, 0)
      calc.possibilities.should have(7 * 6 * 5).items
    end

    it "0e1b" do
      calc.input('123', 0, 1)
      calc.possibilities.should have(252).items
    end

    it "0e2b" do
      calc.input('123', 0, 2)
      calc.possibilities.should have(63).items
      calc.input('231', 0, 2)
      calc.possibilities.should have(21).items
    end

    it "0e3b" do
      calc.input('123', 0, 3)
      calc.possibilities.should =~ %w(231 312)
      calc.input('231', 0, 3)
      calc.possibilities.should =~ %w(312)
    end

    it "1e0b" do
      calc.input('123', 1, 0)
      calc.possibilities.should have(126).items
    end

    it "1e1b" do
      calc.input('123', 1, 1)
      calc.possibilities.should have(42).items
    end

    it "1e2b" do
      calc.input('123', 1, 2)
      calc.possibilities.should =~ %w(132 321 213)
    end

    it "2e0b" do
      calc.input('123', 2, 0)
      calc.possibilities.should have(21).items
    end
  end

  describe "#shuffle" do
    it "0e3b" do
      calc.input('123', 0, 3)
      calc.shuffle
      calc.possibilities.should =~ %w(123 132 213 231 312 321)
    end

    it "2e0b" do
      calc.input('123', 2, 0)
      calc.shuffle
      # 12?, 13?, 21?, 23?, 31?, 32? が3パターン, ? = [0, 4, 5, 6, 7, 8, 9]
      # => 6 * 3 * 7=  126
      calc.possibilities.should have(126).items
    end

    it "1e1b" do
      calc.input('123', 1, 1)
      calc.shuffle
      calc.possibilities.should have(126).items
    end

    it "1e0b" do
      calc.input('123', 1, 0)
      calc.shuffle
      calc.possibilities.should have(378).items
    end

    it "mays[0] is 3 and shuffle" do
      calc.mays[0] = [3]
      calc.shuffle
      # 3が利用されているのは確定
      calc.mays[0].should =~ (0..9).to_a
      calc.mays[1].should =~ (0..9).to_a
      calc.mays[2].should =~ (0..9).to_a

      calc.possibilities.should have(216).items
    end

    context 'using slash' do
      it 'slash 2' do
        calc.slash(2)
        calc.possibilities.should have(48).items
        calc.shuffle
        calc.possibilities.should have(48).items
      end

      it '1e1b, slash 2, shuffle' do
        calc.input('123', 1, 1)
        calc.possibilities.should have(42).items
        calc.slash(2)
        calc.possibilities.should =~ %w(021 102 243 324)
        calc.shuffle
        # 数字の組み合わせは 012 or 234のみなので、 (3 * 2 * 1) * 2 = 12パターン
        calc.possibilities.should =~ %W(021 012 201 210 102 120 243 234 342 324 432 423)
      end
    end
  end

  describe '#slash' do
    # slashを使った場合は、解の可能性は 6 * (10 - n) * (n - 1)に絞られる
    # 正しくは、 s! * (10 - n) * (n - s + 2) (sはカードの枚数、 nはslash number, s!はsの階乗)
    it 'slash 2' do
      calc.slash(2)
      calc.possibilities.should have(48).items
    end

    it 'slash 3' do
      calc.slash(3)
      calc.possibilities.should have(84).items
    end

    it 'slash 4' do
      calc.slash(4)
      calc.possibilities.should have(108).items
    end

    it 'slash 5' do
      calc.slash(5)
      calc.possibilities.should have(120).items
    end

    it 'slash 6' do
      calc.slash(6)
      calc.possibilities.should have(120).items
    end

    it 'slash 7' do
      calc.slash(7)
      calc.possibilities.should have(108).items
    end

    it 'slash 8' do
      calc.slash(8)
      calc.possibilities.should have(84).items
    end

    it 'slash 9' do
      calc.slash(9)
      calc.possibilities.should have(48).items
    end
  end

  describe '#change' do
    it '0, true' do
      calc.change(0, true)
      calc.mays[0].should == (5..9).to_a
    end

    it '1, false' do
      calc.change(1, false)
      calc.mays[1].should == (0..4).to_a
    end

    it '234(0e3b), change(0, false)' do
      calc.input('234', 0, 3) # answer 342
      calc.change(0, false) # answer 142
      calc.mays[0].should =~ [0, 1]
      calc.mays[1].should =~ [2, 4]
      calc.mays[2].should =~ [2, 3]
      calc.possibilities.should =~ %w(023 042 043 123 142 143)
    end

    it '345(0e3b), change(0, false), shuffle' do
      calc.input('345', 0, 3) # answer 453
      calc.change(0, false) # 253
      calc.mays[0].should == [0, 1, 2]
      calc.mays[1].should == [5]
      calc.mays[2].should == [3, 4]
      calc.possibilities.should =~ %w(054 053 153 154 253 254)
      calc.shuffle
      calc.mays[0].should =~ [0, 1, 2, 3, 4, 5]
      calc.mays[1].should =~ [0, 1, 2, 3, 4, 5]
      calc.mays[2].should =~ [0, 1, 2, 3, 4, 5]
      # 5確定なので、 3 * 5 * 4 = 60 (5の位置3箇所) * (5を除く可能性数) * (5を除く可能性数 - 1つ前の数値)
      calc.possibilities.should have(60).items
    end

    it '456(0e3b), change(0, false)' do
      calc.input('456', 0, 3) # answer 564
      calc.change(2, false)
      calc.mays[0].should == [5]
      calc.mays[1].should == [6]
      calc.mays[2].should == [0, 1, 2, 3]
      calc.possibilities.should =~ %w(560 561 562 563)
    end

    it '1e2b, 0, false' do
      calc.input('123', 1, 2) # 132
      calc.change(0, false) # 432
      calc.mays[0].should == [0, 4]
      calc.mays[1].should == [1, 2, 3]
      calc.mays[2].should == [1, 2, 3]
      calc.possibilities.should =~ %w(012 013 021 023 031 032 412 413 421 423 431 432)
    end
  end

  describe '#high_and_low' do
    it 'simple' do
      calc.high_and_low([true, false, true])
      calc.mays[0].should =~ [5, 6, 7, 8, 9]
      calc.mays[1].should =~ [0, 1, 2, 3, 4]
      calc.mays[2].should =~ [5, 6, 7, 8, 9]
      calc.possibilities.should have(100).items
    end

    it '345(0e3b), high_and_low' do
      calc.input('345', 0, 3) # 4 5 3
      calc.high_and_low([false, true, false])
      calc.mays[0].should =~ [4]
      calc.mays[1].should =~ [5]
      calc.mays[2].should =~ [3]
      calc.possibilities.should == %w(453)
    end

    it '345(1e2b), high_and_low' do
      calc.input('354', 1, 2) # 4 5 3
      calc.high_and_low([false, true, false])
      calc.mays[0].should =~ [3, 4]
      calc.mays[1].should =~ [5]
      calc.mays[2].should =~ [3, 4]
      calc.possibilities.should == %w(453)
    end

    it '345(0e1b), high_and_low' do
      calc.input('354', 0, 1) # 4 6 2
      calc.high_and_low([false, true, false])
      calc.mays[0].should =~ [0, 1, 2, 4]
      calc.mays[1].should =~ [6, 7, 8, 9]
      calc.mays[2].should =~ [0, 1, 2, 3]

      # [4] * [6, 7, 8, 9] * [0, 1, 2] + [0, 1, 2] * [6, 7, 8, 9] * [3] = 4 * 3 * 2 = 24
      calc.possibilities.should have(24).items
    end
  end

  describe '#target' do
    it 'simple' do
      calc.target(0, 0)
      calc.mays[0].should =~ [0]
      calc.mays[1].should =~ (1..9).to_a
      calc.mays[2].should =~ (1..9).to_a
      calc.possibilities.should have(72).items
    end

    it 'target(0, nil)' do
      calc.target(0)
      calc.mays[0].should =~ (1..9).to_a
      calc.mays[1].should =~ (1..9).to_a
      calc.mays[2].should =~ (1..9).to_a
      calc.possibilities.should have(504).items
    end

    it '123(0e3b), target(1, 1)' do
      calc.input('123', 0, 3)
      calc.target(1, 1)
      calc.mays[0].should =~ [3]
      calc.mays[1].should =~ [1]
      calc.mays[2].should =~ [2]
      calc.possibilities.should =~ %w(312)
    end
  end

  describe "scenario" do
    it "1e0b, 1e2b" do
      calc.input('348', 1, 0)
      calc.input('123', 1, 2)
      calc.possibilities.should == ['321']
    end

    it "0e1b, 0e1b 0e0b 1e0b 1e2b" do
      calc.input('123', 0, 1)
      calc.input('210', 0, 1)
      calc.input('340', 0, 0)
      calc.input('562', 1, 0)
      calc.input('892', 1, 2)
      calc.possibilities.should == %w(982)
    end

    it "3eat is 571" do
      calc.input('123', 0, 1)
      calc.input('245', 0, 1)
      calc.input('367', 0, 1)
      calc.input('890', 0, 0)
      calc.input('416', 0, 1)
      calc.possibilities.should =~ ['571', '751']
    end

    it "0e1b, 0e1b" do
      calc.input('123', 0, 1)
      calc.input('245', 0, 1)
      calc.possibilities.should have(75).items
    end

    it "0e1b, 0e1b 2" do
      calc.input('123', 0, 1)
      calc.input('235', 0, 1)
      calc.possibilities.should have(78).items
    end

    it "0e1b, 0e1b 3" do
      calc.input('123', 0, 1)
      calc.input('145', 0, 1)
      calc.possibilities.should have(90).items
    end

    it "0e1b, 0e1b 4" do
      calc.input('123', 0, 1)
      calc.input('456', 0, 1)
      calc.possibilities.should have(96).items
    end

    it "0e1b, 2e0b" do
      calc.input('123', 0, 1)
      calc.input('245', 2, 0)
      calc.possibilities.should have(11).items
    end
  end
end