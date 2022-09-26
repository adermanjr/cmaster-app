Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root   'static_pages#home'
  get    '/inscrever',            to: 'usuarios#new'
  get    '/inscrever',            to: 'usuarios#create'
  get    '/login',                to: 'sessions#new'
  post   '/login',                to: 'sessions#create'
  delete '/logout',               to: 'sessions#destroy'
  get    '/faleconosco',          to: 'mensagens#new'
  post   '/faleconosco',          to: 'mensagens#create',       as: 'create_message'
  post   '/filter_by',            to: 'pombos#filter_by',       as: 'filter_by'
  get    '/familia',              to: 'pombos#familia'
  post   '/familia',              to: 'pombos#familia_create',  as: 'familia_create'
  
  resources :usuarios do
    member do
      get  :endereco
      post :salvar_endereco
      get  :editar_assinatura
      post :assinar
      get  :detalhar_assinatura
      post :cancelar_assinatura
      post :cancel_paypal
      post :reativar_paypal
      post :reenviar_email_ativacao
      post :alterar_tipo
      post :plano_avaliacao
      get  :visualizar_contrato
      post :aceitar_contrato
      post :update_language
    end
    collection do
      get  :show_modal
    end
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  resources :pombals do
    collection do
      post :gerar_aplicacao
    end
    member do
      get  :show_modal_aplicacao
    end
  end
  resources :tratamentos do
    collection do
      post   :gerar_aplicacao
      delete :destroy_pombal_tratamento
      get    :show_modal
    end
    member do
      get  :show_modal_aplicacao
    end
  end
  
  resources :pombos do
    collection do
      get  :autocomplete
      get  :show_modal
      post :gerar_aplicacao
      get  :show_modal_aplicacao
      post :create_titulo
      delete :destroy_titulo
      get :show_modal_parents
      post :save_parents
    end
  end
  
  resources :competicaos do
    collection do
      get :atualiza_combo_clube
      get :modal_result
    end
    member do
      get :esquadrao
      get :esquadrao_order
    end
  end
  
  resources :provas do
    collection do
      get  :show_modal_result
      post :create_result
      delete :destroy_result
      get :recupera_desc
    end
    member do
      post  :filter_by
      get  :modal_nao_chegaram
      get  :preparar_importacao
      post  :importados
      get :modal_pp
      post :save_pp
    end
  end
  
  resources :equipes do
    member do
      get :show_modal
      post :assoc_pombo
      delete :desassoc_pombo
    end
  end
  
  resources :preparos
  resources :clubes
end
