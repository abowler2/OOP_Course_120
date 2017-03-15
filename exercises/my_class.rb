module Greeting
  def greeting(greet)
    puts "#{greet}"
  end
end

class MyClass
  include Greeting
end



me = MyClass.new
me.greeting('Hello')