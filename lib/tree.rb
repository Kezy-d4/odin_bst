require_relative "node"

# A blueprint for instantiating a new BST from an array of data.
class Tree
  private

  attr_accessor :root
  attr_reader :processed_array

  def initialize(array)
    @processed_array = array.uniq.sort
    @root = build_tree(processed_array)
  end

  def build_tree(array)
    return if array.empty?

    mid_idx = array.length / 2
    root = Node.new(array[mid_idx])
    return root if array.length == 1

    root.left_child = build_tree(array[0..(mid_idx - 1)])
    root.right_child = build_tree(array[(mid_idx + 1)..])
    root
  end

  public

  def pretty_print(node = root, prefix = "", is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
