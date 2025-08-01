require_relative "node"
require_relative "custom_queue"

# A blueprint for instantiating a new BST from an array of data.
class Tree # rubocop:disable Metrics/ClassLength
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

  def delete_root
    if root.leaf?
      self.root = nil
    elsif root.parent_of_one?
      self.root = root.find_only_child
    elsif root.parent_of_two?
      self.root = delete_parent_of_two(root)
    end
  end

  def delete_parent_of_two(node)
    successor = node.right_child
    successor = successor.left_child while successor.left_child
    successor_data = successor.data
    delete(successor.data)
    node.data = successor_data
    node
  end

  def bt_height(node)
    return 0 if node.nil?

    left_height = node.left_child ? 1 + bt_height(node.left_child) : 0
    right_height = node.right_child ? 1 + bt_height(node.right_child) : 0
    [left_height, right_height].max
  end

  def sub_trees_balanced?(node)
    left_height = node.left_child ? bt_height(node.left_child) : -1
    right_height = node.right_child ? bt_height(node.right_child) : -1
    (left_height - right_height).abs <= 1
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

  # rubocop:disable all

  # Getting this to work was a war.
  def delete(value, current = root)
    return if current.nil?
    return delete_root if current == root && value == current.data

    current.left_child = delete(value, current.left_child) if value < current.data
    current.right_child = delete(value, current.right_child) if value > current.data
    if value == current.data
      if current.leaf?
        return current = nil
      elsif current.parent_of_one?
        return current.find_only_child
      elsif current.parent_of_two?
        return delete_parent_of_two(current)
      end
    end
    current
  end

  def level_order_iterative
    return if empty?

    visited_nodes = []
    discovered_nodes = CustomQueue.new
    discovered_nodes.enqueue(root)
    until discovered_nodes.empty?
      current = discovered_nodes.read
      discovered_nodes.enqueue(current.left_child) if current.left_child
      discovered_nodes.enqueue(current.right_child) if current.right_child
      visited_nodes << discovered_nodes.dequeue
    end
    if block_given?
      visited_nodes.each { |node| yield(node) }
    else
      visited_nodes.map(&:data)
    end
  end

  def level_order_recursive(
    visited_nodes = [],
    discovered_nodes = CustomQueue.new,
    current = discovered_nodes.enqueue(root),
    &block
  )
    return if empty?

    if discovered_nodes.empty?
      if block_given?
        return visited_nodes.each { |node| yield(node) }
      else
        return visited_nodes.map(&:data)
      end
    end
    discovered_nodes.enqueue(current.left_child) if current.left_child
    discovered_nodes.enqueue(current.right_child) if current.right_child
    visited_nodes << discovered_nodes.dequeue
    level_order_recursive(visited_nodes, discovered_nodes, discovered_nodes.read, &block)
  end
  
  # rubocop:enable all

  def pre_order(current = root, visited_nodes = [], &block)
    return if empty?
    return if current.nil?

    if block_given?
      yield(current)
    else
      visited_nodes << current
    end
    pre_order(current.left_child, visited_nodes, &block)
    pre_order(current.right_child, visited_nodes, &block)
    visited_nodes.map(&:data) if current == root && !block_given?
  end

  def in_order(current = root, visited_nodes = [], &block)
    return if empty?
    return if current.nil?

    in_order(current.left_child, visited_nodes, &block)
    if block_given?
      yield(current)
    else
      visited_nodes << current
    end
    in_order(current.right_child, visited_nodes, &block)
    visited_nodes.map(&:data) if current == root && !block_given?
  end

  def post_order(current = root, visited_nodes = [], &block)
    return if empty?
    return if current.nil?

    post_order(current.left_child, visited_nodes, &block)
    post_order(current.right_child, visited_nodes, &block)
    if block_given?
      yield(current)
    else
      visited_nodes << current
    end
    visited_nodes.map(&:data) if current == root && !block_given?
  end

  def height(value)
    node = find(value)
    return if node.nil?

    bt_height(node)
  end

  def depth(value, level = 0, current = root)
    return if current.nil?
    return level if value == current.data

    result = depth(value, level + 1, current.left_child) if value < current.data
    result = depth(value, level + 1, current.right_child) if value > current.data
    result
  end

  # rubocop: disable all

  def balanced?
    return false if empty?

    visited_nodes = []
    discovered_nodes = CustomQueue.new
    discovered_nodes.enqueue(root)
    until discovered_nodes.empty?
      current = discovered_nodes.read
      discovered_nodes.enqueue(current.left_child) if current.left_child
      discovered_nodes.enqueue(current.right_child) if current.right_child
      visited_nodes << discovered_nodes.dequeue
    end
    visited_nodes.all? { |node| sub_trees_balanced?(node) }
  end

  # rubocop: enable all

  def rebalance
    data = level_order_iterative
    data = data.uniq.sort
    self.root = build_tree(data)
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
