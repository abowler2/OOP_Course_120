class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# To avoid problems with this code in the future
# remove the attr_accessor so no one can access and then alter the database