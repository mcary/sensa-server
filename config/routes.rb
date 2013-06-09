Sensa::Application.routes.draw do
  post "feed" => "feeder#feed"
  post "starve" => "feeder#starve"
  post "dose" => "feeder#dose"
  post "cancel/:id" => "feeder#cancel", :as => :cancel_dose
  root to: "feeder#index"
end
