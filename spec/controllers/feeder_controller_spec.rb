require 'spec_helper'

describe FeederController do
  # This should return the minimal set of attributes required to
  # create a valid Feeder.
  def valid_attributes
    {}
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
