require 'spec_helper_no_rails'

# Without Rails, we don't have autoloading
require 'doser'
require 'date'

describe Doser do
  subject { Doser.new(dose_class, params, pump, logger) }

  let(:dose_class) { mock(:Dose, :create! => dose) }
  let(:pump) { mock(:pump, :dose => nil) }
  let(:logger) { mock(:logger, :error => nil) }
  let(:dose) do
    mock(:dose, coerced_params.merge({
      :update_attributes! => nil
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
    dose.should_not_receive(:update_attributes!) # incomplete
    subject.start

    dose.stub(:update_attributes!)
    dose_class.should_not_receive(:create!)
    sleep(0.005)
  end

  it "cycles the pump" do
    pump.should_receive(:dose).with(0.0005).twice
    subject.run
  end

  it "marks the dose completed" do
    dose.should_receive(:update_attributes!) do |val|
      val[:finished_at].to_time.to_f.should be_within(0.001).of(Time.now.to_f)
      val[:status].should == :completed
    end

    subject.run
  end

  describe "for cancel" do
    before :each do
      dose_class.stub(:find => dose)
    end

    it "cancels an in-progress dose" do
      subject.start
      dose.should_receive(:update_attributes!).
        with(hash_including(:finished_at, status: :cancelled))
      pump.should_receive(:off)
      subject.cancel
    end
  end

  context "with invalid params" do
    let(:params) do
      {
        total_quantity: "; truncate table foo_3RtZ; -- ",
        number_of_cycles: "---\nhi: there\n", # quadrillion
        pause_between_cycles: "-1",
      }
    end

    pending "generates form validation errors" do
      subject.run
    end

    it "does something reasonable" do
      subject.run
    end
  end

  context "on exception" do
    let(:ex) { Exception.new("Test Error!") }
    before :each do
      pump.stub!(:dose).and_raise(ex)
    end

    it "logs an error" do
      logger.should_receive(:error).with("Exception while dosing: Test Error!")
      logger.should_receive(:error).
        with(%r{Exception: Test Error!\n  .*app/models/doser.rb:\d}m)
      lambda { subject.run }.should raise_error
    end
  end
end
