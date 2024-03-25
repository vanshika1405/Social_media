Rails.application.routes.draw do


 

post '/account_verifications', to: 'account_verifications#create'

patch '/verify_account/:id', to: 'account_verifications#update', as: 'verify_account'
patch '/account_verifications', to: 'account_verifications#update'


post '/refresh_token', to: 'application#refresh_token'


post '/passwords/generate_otp', to: 'passwords#generate_otp'
  post '/passwords/reset_with_otp', to: 'passwords#reset_with_otp'
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



  

  get 'posts/index_everyone/:page', to: 'posts#index_everyone', as: 'index_everyone'

  get 'posts/index_my_friends/:page', to: 'posts#index_my_friends', as: 'index_my_friends'
  get 'posts/index_only_me/:page', to: 'posts#index_only_me', as: 'index_only_me'


  get '/blocked_users', to: 'blocked_users#index'
  post 'blocked_users/block', to: 'blocked_users#block'
  delete 'blocked_users/unblock', to: 'blocked_users#unblock'


post '/posts/:id/share', to: 'posts#share_post', as: 'share_post'



post '/posts/:id/unfollow_user', to: 'posts#unfollow_user'
post '/posts/:id/unfriend_user', to: 'posts#unfriend_user'
post '/posts/:id/become_friends_again', to: 'posts#become_friends_again'


post '/posts/:id/create_reaction/:kind', to: 'posts#create_reaction', as: 'create_reaction'


  patch '/users/update', to: 'users#update'  
  post '/users/upload_profile_pic', to: 'users#upload_profile_pic'
  post '/users/upload_cover_pic', to: 'users#upload_cover_pic'

  post '/send_greetings', to: 'users#send_greetings'

end

