Rails.application.routes.draw do
  resources :children, only: [:index] if Rails.env.staging? || Rails.env.development?
  resources :metrics, only: [:index]
  post 'autoresponse' => 'autoresponse#autoresponse'
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root 'pages#index'
  get '/info', to: redirect('https://mn.gov/dhs/p-ebt/'), as: 'info'
  get '/schools' => 'schools#index'
  get '/:locale' => 'pages#index'

  if ENV['CLOSED'] != '1'
    scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
      get 'early' => 'pages#early', as: 'early'
      get 'how' => 'pages#how', as: 'how'
      get 'card' => 'pages#card', as: 'card'
      get 'done' => 'pages#done', as: 'done'

      resources :steps, controller: :forms, only: (Rails.env.production? ? %i[show] : %i[show index]) do
        collection do
          FormNavigation.controllers.uniq.each do |controller_class|
            { get: :edit, put: :update }.each do |method, action|
              match "/#{controller_class.to_param}",
                    action: action,
                    controller: controller_class.controller_path,
                    via: method
            end
          end
        end
      end

      delete '/steps/children/:id' => 'children#destroy', as: 'remove_child'
    end
  end
  mount Cfa::Styleguide::Engine => '/cfa'
  match '*path', to: redirect { |_path, req| req.flash[:error] = 'There has been a problem on our end.'; '/en' }, via: :all
end
