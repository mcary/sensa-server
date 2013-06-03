require 'spec_helper'

describe Doser do
  subject { Doser.new(params, pump) }

  let(:dose) { Dose.first }
  let(:pump) { mock(:pump, :dose => nil) }
  let(:params) do
    {
      total_quantity: "0.01",
      number_of_cycles: "2",
      pause_between_cycles: "0.02",
    }
  end

  before :all do
    # In case non-transactional tests left something, clear the table
    Dose.destroy_all
  end

  it "saves an incomplete dose" do
    expect { subject }.to change { Dose.count }.by(1)

    dose.completed_at.should be_nil
    dose.total_quantity.should == 0.01
    dose.number_of_cycles.should == 2
    dose.pause_between_cycles.should == 0.02
    dose.completed_at.should be_nil # incomplete
  end

  it "cycles the pump" do
    pump.should_receive(:dose).with(0.005).twice
    subject.run
  end

  it "marks the dose completed" do
    subject.run
    dose.reload.completed_at.to_f.should be_within(0.1).of(DateTime.now.to_f)
  end

  context "with invalid params" do
    let(:params) do
      {
        total_quantity: "; truncate table foo_3RtZ; -- ",
        number_of_cycles: "---\nhi: there\n", # quadrillion
        pause_between_cycles: "-1",
      }
    end

    pending "raises/handles it" do
      subject.run
    end

    it "does something reasonable" do
      subject.run
    end
  end
end

