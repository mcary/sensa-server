Sensa::Application.routes.draw do
  post "feed" => "feeder#feed"
  post "starve" => "feeder#starve"
  post "dose" => "feeder#dose"
  root to: "feeder#index"
end
