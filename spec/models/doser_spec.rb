require 'spec_helper_no_rails'

# Without Rails, we don't have autoloading
require 'doser'
require 'date'

describe Doser do
  subject { Doser.new(dose_class, params, pump) }

  let(:dose_class) { mock(:Dose, :create! => dose) }
  let(:pump) { mock(:pump, :dose => nil) }
  let(:dose) do
    mock(:dose, coerced_params.merge({
      :completed_at= => nil,
      :save! => nil,
    }))
  end
  let(:params) do
    {
      total_quantity: "0.001",
      number_of_cycles: "2",
      pause_between_cycles: "0.002",
    }
  end
  let(:coerced_params) do
    {
      total_quantity: 0.001,
      number_of_cycles: 2,
      pause_between_cycles: 0.002,
    }
  end

  it "saves an incomplete dose at first" do
    dose_class.should_receive(:create!).with(coerced_params)
    dose.should_not_receive(:completed_at=) # incomplete
    subject.start

    dose.stub(:completed_at=)
    dose_class.should_not_receive(:create!)
    sleep(0.005)
  end

  it "cycles the pump" do
    pump.should_receive(:dose).with(0.0005).twice
    subject.run
  end

  it "marks the dose completed" do
    dose.should_receive(:completed_at=) do |val|
      val.to_time.to_f.should be_within(0.001).of(Time.now.to_f)
    end
    dose.should_receive(:save!)

    subject.run
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

