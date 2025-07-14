# A blueprint for instantiating a new node for use in a balanced binary search
# tree. The Comparable module has been mixed in and its comparison method
# defined so that one node's data can easily be compared against another's.
class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

  # Enables comparison of nodes by their data. Each node's data must be of the
  # same type to be comparable.
  def <=>(other)
    return unless other.is_a?(Node)

    data <=> other.data
  end

  def leaf?
    left_child.nil? && right_child.nil?
  end

  def parent_of_one?
    [left_child, right_child].one?
  end

  def find_only_child
    return unless one_child?

    left_child || right_child
  end

  def parent_of_two?
    [left_child, right_child].all?
  end
end
