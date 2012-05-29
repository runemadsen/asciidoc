class AsciiCounter
  
  def initialize
    @counts = {}
  end
  
  def increment(element)
    if @counts[element]
      @counts[element] += 1
    else
      @counts[element] = 1
    end
    @counts[element]
  end
  
  def count(element)
    @counts[element]
  end
  
end