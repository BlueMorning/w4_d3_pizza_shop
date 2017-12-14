require( 'sinatra' )
require( 'sinatra/contrib/all' ) if development?
require( 'pry-byebug' )
require_relative('./models/pizza')


# Route to display all the pizza orders
get('/pizzas') do
  @pizzas = Pizza.all()
  erb(:index)
end

#Get the form to create a new pizza
get('/pizzas/new') do
  @toppings = Pizza.toppings()
  erb(:new)
end

# Route to display a pizza order
get('/pizzas/:id') do
  @pizza = Pizza.find(params[:id].to_i)
  erb(:show)
end


#Get the form back to create a new pizza orders
post('/pizzas') do
  @pizza = Pizza.new(params)
  @pizza.save()
  erb(:create)
end

#Edit a pizza order
get('/pizzas/:id/edit') do
  @toppings = Pizza.toppings()
  @pizza    = Pizza.find(params['id'])
  erb(:edit)
end

#Update a pizza order
post('/pizzas/:id') do
  @pizza = Pizza.new(params)
  @pizza.update()
  erb(:show)
end

#Update a pizza order
post('/pizzas/:id/delete') do
  @pizza = Pizza.new(params)
  @pizza.delete
  redirect '/pizzas'
end
