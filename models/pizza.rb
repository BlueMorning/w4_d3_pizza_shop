require_relative('../db/sql_runner')

class Pizza

  attr_reader :first_name, :last_name, :topping, :quantity, :id

  def initialize( options )
    @id = options['id'].to_i if ! options.include?('i')
    @first_name = options['first_name']
    @last_name = options['last_name']
    @topping = options['topping']
    @quantity = options['quantity'].to_i
    @price = 10
  end

  def pretty_name()
    return "#{@first_name} #{@last_name}"
  end

  def total()
    return @quantity * @price
  end

  def save()
    sql = "INSERT INTO pizzas
    (
      first_name,
      last_name,
      topping,
      quantity
    )
    VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING *"
    values = [@first_name, @last_name, @topping, @quantity]
    pizza_data = SqlRunner.run(sql, values)
    @id = pizza_data.first()['id'].to_i
  end

  def update()
    sql = "UPDATE pizzas
    SET
    (
      first_name,
      last_name,
      topping,
      quantity
    ) =
    (
      $1, $2, $3, $4
    )
    WHERE id = $5"
    values = [@first_name, @last_name, @topping, @quantity, @id]
    SqlRunner.run( sql, values )
  end

  def self.delete_all()
    sql = "DELETE FROM pizzas;"
    values = []
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM pizzas
    WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def self.all()
    sql = "SELECT * FROM pizzas ORDER BY pizzas.id DESC"
    values = []
    pizzas = SqlRunner.run( sql, values )
    result = pizzas.map { |pizza| Pizza.new( pizza ) }
    return result
  end

  def self.find( id )
    sql = "SELECT * FROM pizzas WHERE id = $1"
    values = [id]
    pizza = SqlRunner.run( sql, values )
    result = Pizza.new( pizza.first )
    return result
  end

  def self.toppings()
    return ["Regina", "Napoli", "Vegan", "Quattro seasons", "Crazy", "Hawai"]
  end

  def self.generate_pizzas()

    first_names   = ["Eric", "Amy", "Joe", "Dave", "Greame", "Vishal", "Emily", "Alisson", "Robert"]
    last_names    = ["Eric", "Amy", "Joe", "Dave", "Greame", "Vishal", "Emily", "Alisson", "Robert"]
    quantity       = [10, 11, 12, 13, 14, 15]

    for i in 1..1000
      options = { "first_name" => first_names[Random.new.rand(0..8)],
                  "last_name"  => last_names[Random.new.rand(0..8)],
                  "topping"    => self.topping[Random.new.rand(0..5)],
                  "quantity"   => quantity[Random.new.rand(0..5)]
                }

      Pizza.new(options).save()
    end
  end




end
