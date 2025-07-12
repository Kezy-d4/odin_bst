# A blueprint for instantiating a new BST from an array of data.
class Tree
  private

  attr_accessor :root

  public

  def initialize(array)
    @root = build_tree(array)
  end
end
