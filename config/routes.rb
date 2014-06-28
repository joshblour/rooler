Rooler::Engine.routes.draw do
  resources :templates do
    post 'test', on: :member
  end
  
  resources :rules do
    post 'process', on: :member
    post 'find_matches', on: :member
  end

end
