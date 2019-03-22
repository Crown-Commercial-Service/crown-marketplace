require 'rails_helper'
require 'FMcalculator/calculator'

RSpec.describe FMCalculator::Calculator do
  subject(:calculator) do
  end

  before(:all) do
    # args  Service ref, uom_vol, occupants, tuoe involved, london_location, CAFM, helpdesk
    $calc = FMCalculator::Calculator.new("G1",23000,125, 'Y','Y','Y','N')
  end

  describe 'Routine Cleaning '
    it "Routing Cleaning" do
      $x1 = $calc.sumunitofmeasure("G1",23000,125, 'Y','Y','Y','N')
      puts $x1
      expect($x1).to eq(899962)
    end

  describe 'Lifts, Hoists & Conveyancing'
      it  'Lifts, Hoists & Conveyancing' do
      $x2 = $calc.sumunitofmeasure("C5",54,0, 'Y','Y','Y','N')
      puts $x2
      expect($x2).to eq(36423)
    end

  describe 'Voice Announcement System'
  it "Voice Announcement System" do
    $x3 = $calc.sumunitofmeasure("C19",0,0, 'Y','Y','Y','N')
    puts $x3
    expect($x3).to eq(0)
  end

  describe 'Portable Applicance Testing'
  it "Portable Applicance Testing" do
    $x4 = $calc.sumunitofmeasure("E4",450,0, 'N','N','M','Y')
    puts $x4
    expect($x4).to eq(900)
  end

describe 'Classified Waste'
  it "Classified Waste" do
    $x5 = $calc.sumunitofmeasure("K1",75,0, 'N','N','N','Y')
    puts $x5
    expect($x5).to eq(17651)
  end

  describe 'Handyman Services'
  it "Handyman Services" do
    $x6 = $calc.sumunitofmeasure("H4",2350,0, 'N','N','N','Y')
    puts $x6
    expect($x6).to eq(116470)
  end

  describe 'Cleaning of external areas'
  it "Cleaning of external areas" do
    $x7 = $calc.sumunitofmeasure("G5",56757,0, 'N','N','N','N')
    puts $x7
    expect($x7).to eq(359342)
  end



  describe 'General Waste'
  it "General Waste" do
    $x8= $calc.sumunitofmeasure("K2",125,0, 'N','N','N','N')
    puts $x8
    expect($x8).to eq(67954)
  end

  describe 'Feminine Hygene Waste'
  it "Feminine Hygene Waste" do
    $x9 = $calc.sumunitofmeasure("K7",680,0, 'N','N','N','N')
    puts $x9
    expect($x9).to eq(38626)
  end



    describe 'Routine Cleaning '
    it "Routing Cleaning" do
      $y1 = $calc.benchmarkedcostssum("G1",23000,125, 'Y','Y','Y','N')
      puts 'ROUTINE CLEANING '
      puts $y1
      expect($y1).to eq(392404)
    end

    describe 'Lifts, Hoists & Conveyancing'
    it  'Lifts, Hoists & Conveyancing' do
      $y2 = $calc.benchmarkedcostssum("C5",54,0, 'Y','Y','Y','N')
      puts $y2
      expect($y2).to eq(36423
                     )
    end

    describe 'Voice Announcement System'
    it "Voice Announcement System" do
      $y3 = $calc.benchmarkedcostssum("C19",0,0, 'Y','Y','Y','N')
      puts $y3
      expect($y3).to eq(0)
    end

    describe 'Portable Applicance Testing'
    it "Portable Applicance Testing" do
      $y4 = $calc.benchmarkedcostssum("E4",450,0, 'N','N','M','Y')
      puts $y4
      expect($y4).to eq(900)
    end

    describe 'Classified Waste'
    it "Classified Waste" do
      $y5 = $calc.benchmarkedcostssum("K1",75,0, 'N','N','N','Y')
      puts $y5
      expect($y5).to eq(17651)
    end

    describe 'Handyman Services'
    it "Handyman Services" do
      $y6 = $calc.benchmarkedcostssum("H4",2350,0, 'N','N','N','Y')
      puts $y6
      expect($y6).to eq(116470)
    end

    describe 'Cleaning of external areas'
    it "Cleaning of external areas" do
      $y7 = $calc.benchmarkedcostssum("G5",56757,0, 'N','N','N','N')
      puts $y7
      expect($y7).to eq(359342)
    end

    describe 'General Waste'
    it "General Waste" do
      $y8 = $calc.benchmarkedcostssum("K2",125,0, 'N','N','N','N')
      puts $y8
      expect($y8).to eq(67954)
    end

    describe 'Feminine Hygene Waste'
    it "Feminine Hygene Waste" do
      $y9 = $calc.benchmarkedcostssum("K7",680,0, 'N','N','N','N')
      puts $y9
      expect($y9).to eq(38626)
    end


  describe 'Sum'
  it 'Sum' do
    $sum = $x1 + $x2 + $x3 + $x4 + $x5 + $x6 + $x7 + $x8 + $x9
    puts $sum
    expect($sum).to eq(1537328)
  end

    describe 'Bench Sum'
    it 'Sum' do
      $sum = $y1 + $y2 + $y3 + $y4 + $y5 + $y6 + $y7 + $y8 + $y9
      puts $sum
      expect($sum).to eq(1029770)
    end


  end


