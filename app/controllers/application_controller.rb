class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    redirect to '/recipes'
  end

  get '/recipes' do
    @recipes = Recipe.all

    if @recipes.empty?
      "<h1>You have no recipes</h1>
      <a href=\"/recipes/new\">create one here</a>"
    else
      erb :index
    end
  end

  post '/recipes' do
    recipe = Recipe.create(
      :name => params[:name],
      :ingredients => params[:ingredients],
      :cook_time => params[:cook_time])
    redirect "/recipes/#{recipe.id}"
  end

  get '/recipes/new' do
    erb :new
  end

  get '/recipes/:id' do
    begin
      @recipe = Recipe.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      "<p>Bad recipe ID: \"#{params[:id]}\"<p>"
    else
      erb :recipe
    end
  end

  patch '/recipes/:id' do
    begin
      recipe = Recipe.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      "<p>Bad recipe ID: \"#{params[:id]}\"<p>"
    else
      recipe.name = params[:name]
      recipe.ingredients = params[:ingredients]
      recipe.cook_time = params[:cook_time]
      recipe.save

      redirect "/recipes/#{recipe.id}"
    end
  end

  get '/recipes/:id/edit' do
    begin
      @recipe = Recipe.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      "<p>Bad recipe ID: \"#{params[:id]}\"<p>"
    else
      erb :edit
    end
  end

  delete '/recipes/:id/delete' do
    begin
      recipe = Recipe.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound => e
      "<p>Bad recipe ID: \"#{params[:id]}\"<p>"
    else
      recipe.destroy
      redirect "/recipes"
    end
  end

end
