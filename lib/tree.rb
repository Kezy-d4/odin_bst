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

  # Recursively builds a balanced binary search tree from a sorted array.
  # @param array [Array] A sorted array of unique elements.
  # @return [Node, nil] The root node of the built tree if the array is not empty, or nil if it is.
  def build_tree(array)
    return if array.empty?

    mid_idx = array.length / 2
    root = Node.new(array[mid_idx])
    return root if array.length == 1

    left_sub_array = array[0..(mid_idx - 1)]
    right_sub_array = array[(mid_idx + 1)..]
    root.left_child = build_tree(left_sub_array)
    root.right_child = build_tree(right_sub_array)
    root
  end

  public

  # Inserts a node into the BST whose data contains the given value. No
  # insertion is performed in the case of attempting to insert a duplicate
  # value.
  # @param value [Obj] The value to insert.
  # @param current [Node] The current node in the traversal, initially root.
  # @return [Node] The root of the tree following any insertion.
  def insert(value, current = root)
    return self.root = Node.new(value) if empty?
    return Node.new(value) if current.nil?

    current.left_child = insert(value, current.left_child) if value < current.data
    current.right_child = insert(value, current.right_child) if value > current.data
    current
  end

  # Searches the tree for the node containing the given value.
  # @param value [Obj] The value to search for.
  # @return [Node, nil] The node containing the given value or nil if not found.
  def find(value, current = root)
    return if current.nil?
    return current if value == current.data

    node = find(value, current.left_child) if value < current.data
    node = find(value, current.right_child) if value > current.data
    node
  end

  def empty?
    root.nil?
  end

  # Prints a visual representation of the BST to the console.
  # @return [nil]
  def pretty_print(node = root, prefix = "", is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
