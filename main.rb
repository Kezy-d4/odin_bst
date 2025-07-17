require_relative "lib/tree"

puts "New tree:"
tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
puts "Tree is balanced?: #{tree.balanced?}"
puts "Data in level order:"
p tree.level_order_iterative
puts "Data in order:"
p tree.in_order
puts "Data in pre order:"
p tree.pre_order
puts "Data in post order:"
p tree.post_order

puts
puts "Unbalancing the tree..."
puts "— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —"
tree.insert(150)
tree.insert(125)
tree.insert(200)
tree.insert(155)
puts "New tree:"
tree.pretty_print
puts "Tree is balanced?: #{tree.balanced?}"

puts
puts "Rebalancing the tree..."
puts "— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —"
tree.rebalance
puts "New tree:"
tree.pretty_print
puts "Tree is balanced?: #{tree.balanced?}"
puts "Data in level order:"
p tree.level_order_iterative
puts "Data in order:"
p tree.in_order
puts "Data in pre order:"
p tree.pre_order
puts "Data in post order:"
p tree.post_order
