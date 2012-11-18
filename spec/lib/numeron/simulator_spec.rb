# coding: utf-8

require 'spec_helper'

describe Numeron::Simulator do
  describe '#eat_and_bite' do
    let(:answer) { '987' }
    subject { Numeron::Simulator.new.eat_and_bite(answer, input) }

    context '123' do
      let(:input) { '123' }
      it { should == {eat: 0, bite: 0} }
    end

    context '812' do
      let(:input) { '812' }
      it { should == {eat: 0, bite: 1} }
    end

    context '871' do
      let(:input) { '871' }
      it { should == {eat: 0, bite: 2} }
    end

    context '879' do
      let(:input) { '879' }
      it { should == {eat: 0, bite: 3} }
    end

    context '912' do
      let(:input) { '912' }
      it { should == {eat: 1, bite: 0} }
    end

    context '971' do
      let(:input) { '971' }
      it { should == {eat: 1, bite: 1} }
    end

    context '978' do
      let(:input) { '978' }
      it { should == {eat: 1, bite: 2} }
    end

    context '981' do
      let(:input) { '981' }
      it { should == {eat: 2, bite: 0} }
    end

    context '987' do
      let(:input) { '987' }
      it { should == {eat: 3, bite: 0} }
    end
  end
end