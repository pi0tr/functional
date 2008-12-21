require 'cohi'
require 'cohi/prelude'

#basic 
define(:test) {puts "this is a test"}
p test.inspect   # => #<Cohi::Function:0x297b45c @sym=:test, @func=[[nil, #<Proc:0x02940974@ex.rb:5>]]>
test[]                  # => "this is a test"

# simple pattern matching
define(:e_power, [0, X, X]) {|x, f, t| :no_power} 
define(:e_power, [X, :kW, :HP]) {|x| x*0.75 }
define(:e_power, [X, :HP, :kW]) {|x| x*(1.0/0.75) }
define(:e_power, [X, :kW, :kW]) {|x| x }
define(:e_power, [X, :HP, :HP]) {|x| x }
define(:e_power, [X, X, X]) do |x, f, t| 
  puts "I don't know how to convert from #{f} to #{t}!"
end

p e_power[0, :kW, :HP]     # => :no_power
p e_power[100, :HP, :kW]  # => 133.333333333333
p e_power[200, :kW, :HP]  # => 150.0
p e_power[300, :HP, :HP]   # => 300
e_power[400, :kW, :MW]   # => I don't know how to convert from kW to MW!

# array pattern matching
define(:reverse_list, [[]]) {[]}
define(:reverse_list, [X_XS]) {|x, xs| reverse_list[xs] + [x]}
p reverse_list[%w[sax piano bass drums]] # => ["drums", "bass", "piano", "sax"]

#eager function eval
names = %w[dizzy john charlie pat miles herbie pat stan john]
define(:cap, [X]) {|x| x.map {|w| w.capitalize}}
define(:sort_unique, [X]) {|x| x.sort.uniq}
define(:swap_case, [X]) {|x| x.map {|w| w.swapcase}}

p cap**sort_unique[names] # => "Charlie", "Dizzy", "Herbie", "John", "Miles", "Pat", "Stan"]

#currying
define(:matcher, [X,X]) {|x, y| y =~ x}
match1 = curry(matcher, /[rz]/) 
match2 = curry(matcher, /^.i/) 
p filter[match1, names]   # => ["dizzy", "charlie", "herbie"]
p filter[match2, names]   # => ["dizzy", "miles"]

#lazy evaluation
z = curry(filter, curry(matcher, /N$/)) * swap_case
p z[names] # => ["JOHN", "STAN", "JOHN"]

#functional and OO mix
p (cap * sort_unique * swap_case * z)[names].reverse # => ["Stan", "John"]

#function name clash
sort_unique = nil
#p z ** sort_unique[names]            # => ex.rb:54: undefined method `[]' for nil:NilClass (NoMethodError)
p z ** fun(:sort_unique)[names]   # => ["JOHN", "STAN"]






