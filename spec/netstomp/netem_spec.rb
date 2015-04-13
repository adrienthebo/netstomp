require 'spec_helper'
require 'netstomp/qdisc'

describe Netstomp::Netem do

  it 'creates a qdisc instance with the qdisc field populated' do
    subject = described_class.new('eth0', 'root', nil, 'netem-params')
    expect(subject).to be_a_kind_of(Netstomp::QDisc)
    expect(subject.qdisc).to eq 'netem'
  end

  describe 'corrupt' do
    subject { described_class.corrupt('eth0', 'root', nil, 5) }

    it 'creates a netem instance with a "corrupt" param' do
      expect(subject.params).to eq "corrupt 5%"
    end
  end

  describe 'duplicate' do
    subject { described_class.duplicate('eth0', 'root', nil, 5) }

    it 'creates a netem instance with a "duplicate" param' do
      expect(subject.params).to eq "duplicate 5%"
    end
  end

  describe 'loss' do
    it "creates a netem instance with a 'loss' param" do
      subject = described_class.loss('eth0', 'root', nil, 5)
      expect(subject.params).to eq 'loss random 5%'
    end

    it "can use an optional 'correlation' param" do
      subject = described_class.loss('eth0', 'root', nil, 5, 25)
      expect(subject.params).to eq 'loss random 5% correlation 25%'
    end
  end
end
