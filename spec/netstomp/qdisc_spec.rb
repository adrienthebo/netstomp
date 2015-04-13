require 'spec_helper'

describe Netstomp::QDisc do

  subject { described_class.new('fifo', 'eth0', 'root', nil, 'fifo-params') }

  describe 'identifying the qdisc' do
    it 'sets the device and parent' do
      expect(subject.identifier).to match(/^dev eth0 root/)
    end

    it 'omits the handle when not set' do
      expect(subject.identifier).to match(/^dev eth0 root$/)
    end

    it 'sets the handle when set' do
      subject = described_class.new('fifo', 'eth0', '1:', '1:2', 'fifo-params')
      expect(subject.identifier).to match(/^dev eth0 1: handle 1:2$/)
    end
  end

  it "can generate an 'add' command" do
    expect(subject.add).to eq 'tc qdisc add dev eth0 root fifo fifo-params'
  end

  it "can generate a 'delete' command" do
    expect(subject.delete).to eq 'tc qdisc delete dev eth0 root'
  end

  describe "running a block" do
    it "doesn't execute the add and delete commands when 'noop' is true" do
      expect(subject).to_not receive(:execute).with(subject.add)
      expect(subject).to_not receive(:execute).with(subject.delete)
      subject.run(:noop => true) { }
    end

    it "executes the 'add' command, runs the block, and runs the 'delete' command when 'noop' is false" do
      expect(subject).to receive(:execute).with(subject.add, false).ordered
      expect(subject).to receive(:execute).with(subject.delete, false).ordered
      subject.run(:noop => false) { }
    end

    it "runs the 'delete' command even if an exception is thrown" do
      allow(subject).to receive(:execute).with(subject.add, false)
      expect(subject).to receive(:execute).with(subject.delete, false)
      expect {
        subject.run(:noop => false) { raise "nope" }
      }.to raise_error('nope')
    end
  end
end
