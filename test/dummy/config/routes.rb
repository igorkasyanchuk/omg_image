Rails.application.routes.draw do
  mount OmgImage::Engine => "/omg_image"

  root 'home#index'
end
