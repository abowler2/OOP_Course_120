module Trunkable
  def has_a_trunk?(doors)
    doors == 4 ? true : false
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color 
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    "I have #{@@number_of_vehicles} vehicles."
  end

  def speed_up(number)
    @current_speed += number
    puts "You accelerate by #{number} mph."
  end

  def brakes(number)
    @current_speed -= number
    puts "You decelerate by #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_car_off
    @current_speed = 0
    puts "Time to shut the vehicle off."
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.gas_mileage(miles, gallons)
    puts "#{miles / gallons} miles per gallon of gas."
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle

  NUMBER_OF_DOORS = 4

  include Trunkable

  def to_s
    "My car is a #{year} #{color} #{model}."
  end

end

class MyTruck < Vehicle

  NUMBER_OF_DOORS = 2

  def to_s
    "My truck is a #{year} #{color} #{model}."
  end
end

infiniti = MyCar.new(2013, 'silver', 'JX35')
truck = MyTruck.new(2010, 'black', 'Ford F150')
#truck.speed_up(25)
#truck.current_speed
#truck.speed_up(20)
#truck.current_speed
#truck.brakes(20)
#truck.current_speed
#truck.brakes(25)
#truck.current_speed
#truck.shut_car_off
#truck.current_speed
#truck.spray_paint('red')
#puts infiniti.color
#puts infiniti.year
#MyCar.gas_mileage(50, 2)
#puts infiniti
#puts Vehicle::number_of_vehicles
#puts infiniti.has_a_trunk?(4)
#puts MyCar.ancestors
puts infiniti.age
