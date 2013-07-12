require 'spec_helper'

describe FeederController do
  # I don't think I should have to do this, but if I don't, I get an
  # error:
  #
  #    NoMethodError: undefined method `original_path_set' for
  #    nil:NilClass
  #
  render_views

  # This should return the minimal set of attributes required to
  # create a valid Feeder.
  def valid_attributes
    {}
  end

  let(:serial) { mock(:serial) }
  before :each do
    SimpleSerialPort.stub(:new => serial)
  end

  before :each do
    # I don't think I should have to do this, but if I don't, I get an
    # error:
    #
    #     @controller is nil: make sure you set it in your test's setup
    #     method.
    #
    @controller = FeederController.new
  end

  describe "GET index" do
    it "assigns all doses as @doses in reverse order" do
      Dose.destroy_all
      dose1 = Dose.create! valid_attributes
      dose2 = Dose.create! valid_attributes
      get :index
      assigns(:doses).should eq([dose2, dose1])
    end
  end
end
