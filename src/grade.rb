class Grade
  def initialize(grade)
    @base = grade[0, 1]
    @mod = ""
    @modifier = 0
    if grade.length > 1
      @modifier = (grade[1, 2] == '+') ? -1 : 1
      @mod = grade[1,2]
    end
  end

  def base
    @base
  end

  def modifier
    @modifier
  end

  def <=> (o)
    comp = @base <=> o.base
    return comp unless comp == 0

    @modifier <=> o.modifier
  end
end

a_plus = Grade.new("A+")
a = Grade.new("A")
a_minus = Grade.new("A-")
b_plus = Grade.new("B+")
b = Grade.new("B")
c_plus = Grade.new("C+")
d_minus = Grade.new("D-")
f = Grade.new("F")
list = [b, a_plus, b_plus, c_plus, d_minus, f, a, a_minus]
list.sort.each do |grade|
  print grade.base
  if grade.modifier == -1
    print "+"
  end
  if grade.modifier == 1
    print "-"
  end
  print "\n"
end