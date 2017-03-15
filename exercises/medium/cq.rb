class CircularQueue
  def initialize(size)
    @buffer = Array.new(size, nil)
    @next_position = 0
    @oldest_element = 0
  end

  def enqueue(element)
    unless @buffer[@next_position].nil?
      @oldest_element = increment(@next_position)
    end

    @buffer[@next_position] = element
    @next_position = increment(@next_position)
  end

  def dequeue
    value = @buffer[@oldest_element]
    @buffer[@oldest_element] = nil
    @oldest_element = increment(@oldest_element) unless value.nil?
    value
  end

  private

  def increment(position)
    (position + 1) % @buffer.size
   end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

# should return 'true' 15 times