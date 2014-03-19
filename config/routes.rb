Rooler::Engine.routes.draw do
  resources :templates do
    post 'test', on: :member
  end
  
  resources :rules do
    post 'check', on: :member
  end

end
