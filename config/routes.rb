OmgImage::Engine.routes.draw do
  get '/preview', to: 'previews#show', as: :preview
end
