require_relative "lib/tree"

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
tree.insert(7)
tree.insert(322)
tree.pretty_print
