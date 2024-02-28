Rails.application.routes.draw do


 

post '/account_verifications', to: 'account_verifications#create'

patch '/verify_account/:id', to: 'account_verifications#update', as: 'verify_account'


post '/refresh_token', to: 'application#refresh_token'


post 'passwords/generate_otp', to: 'passwords#generate_otp'


patch '/passwords/reset_with_otp', to: 'passwords#reset_with_otp'
patch '/passwords/new_password', to: 'passwords#new_password'



  
resources :users, only: [:show] do
  member do
    get 'followers', to: 'users#followers'
    get 'following', to: 'users#following'
  end
end

  
get '/posts/liked', to: 'posts#liked', as: 'liked_posts'
get '/comments/liked', to: 'comments#liked', as: 'liked_comments'
get '/posts/:id', to: 'posts#show', as: 'post'
get '/posts', to: 'posts#index'
  post '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update'
  post '/login', to: 'users#login'
  post '/posts', to: 'posts#create'
  post '/comments', to: 'comments#create'
  post '/likes', to: 'likes#create'
  delete '/posts/:id', to: 'posts#destroy'

  
  post '/friendships', to: 'friendships#create', as: 'create_friendship'


  patch '/friendships/:id/accept', to: 'friendships#accept', as: :accept_friendship
  delete '/friendships/:id/reject', to: 'friendships#reject', as: :reject_friendship
  delete '/posts/:id/unlike', to: 'posts#unlike', as: :unlike_post
  delete '/comments/:id/unlike', to: 'comments#unlike', as: :unlike_comment

end

