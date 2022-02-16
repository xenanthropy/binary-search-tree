# frozen-string-literal: true

# Node class
class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    self.data = data
    self.left = left
    self.right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

# Tree class
class Tree
  attr_accessor :root, :array

  def initialize(array)
    self.array = array.sort.uniq
    self.root = build_tree(self.array, 0, self.array.length - 1)
  end

  def build_tree(array, start, ending)
    return nil if start > ending

    mid = (start + ending) / 2
    tree_node = Node.new(array[mid])
    tree_node.left = build_tree(array, start, mid - 1)
    tree_node.right = build_tree(array, mid + 1, ending)

    tree_node
  end

  def insert(value)
    self.root = insert_node(root, value)
  end

  def insert_node(node, data)
    if node.nil?
      node = Node.new(data)
      return node
    end

    if node.data > data
      node.left = insert_node(node.left, data)
    elsif node.data < data
      node.right = insert_node(node.right, data)
    end

    node
  end

  def delete(value)
    self.root = delete_node(root, value)
  end

  def delete_node(node, data)
    nil if node.nil?

    if node.data > data
      node.left = delete_node(node.left, data)
    elsif node.data < data
      node.right = delete_node(node.right, data)
    else
      if node.left.nil? && node.right.nil?
        return nil
      elsif !node.left.nil? && node.right.nil?
        return node.left
      elsif node.left.nil? && !node.right.nil?
        return node.right
      end

      node.data = successor(node.right)
      node.right = delete_node(node.right, node.data)
    end

    node
  end

  def successor(node)
    min_value = node.data
    unless node.left.nil?
      min_value = node.left.data
      node = node.left
    end
    min_value
  end

  def find(node = root, data)
    return 'Node not found!' if node.nil?

    if node.data < data
      find(node.right, data)
    elsif node.data > data
      find(node.left, data)
    else
      puts depth(node)
      node
    end
  end

  def level_order(node = root)
    level_array = [node]
    value_array = []
    until level_array.empty?
      node = level_array.shift
      value_array.push(node.data)
      level_array.push(node.left) unless node.left.nil?
      level_array.push(node.right) unless node.right.nil?
      yield node if block_given?
    end
    value_array unless block_given?
  end

  def inorder(node = root, value_array = [])
    return nil if node.nil?

    inorder(node.left, value_array)
    yield node if block_given?
    value_array.push(node.data)
    inorder(node.right, value_array)
    return value_array unless block_given?
  end

  def preorder(node = root, value_array = [])
    return nil if node.nil?

    yield node if block_given?
    value_array.push(node.data)
    preorder(node.left, value_array)
    preorder(node.right, value_array)
    return value_array unless block_given?
  end

  def postorder(node = root, value_array = [])
    return nil if node.nil?

    postorder(node.left, value_array)
    postorder(node.right, value_array)
    yield node if block_given?
    value_array.push(node.data)
    return value_array unless block_given?
  end

  def height(node = root)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    if left_height > right_height
      left_height + 1
    else
      right_height + 1
    end
  end

  def depth(num, node = root)
    return -1 if node.nil?

    distance = -1
    return distance + 1 if node.data == num

    distance = depth(num, node.left)
    return distance + 1 if distance >= 0

    distance = depth(num, node.right)
    return distance + 1 if distance >= 0

    distance
  end

  def balanced?(node = root)
    return true if node.nil?

    return true if balanced?(node.left) && balanced?(node.right) && (height(node.left) - height(node.right)).abs <= 1

    false
  end

  def rebalance
    sorted_array = postorder(root).uniq.sort
    self.root = build_tree(sorted_array, 0, sorted_array.length - 1)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

def run_test
  tree = Tree.new(Array.new(15) { rand(1..100) })
  tree.pretty_print
  puts "is tree balanced? #{tree.balanced?}"
  puts 'tree in level order:'
  p tree.level_order
  puts "\ntree in in-order:"
  p tree.inorder
  puts "\ntree in pre-order:"
  p tree.preorder
  puts "\ntree in post-order:"
  p tree.postorder
  tree.insert(101)
  tree.insert(102)
  tree.insert(103)
  tree.insert(104)
  tree.pretty_print
  puts "Is the tree balanced? #{tree.balanced?}"
  puts "\nrebalancing tree...\n"
  tree.rebalance
  tree.pretty_print
  puts "Is the tree balanced? #{tree.balanced?}\n"
  puts 'tree in level order:'
  p tree.level_order
  puts "\ntree in in-order:"
  p tree.inorder
  puts "\ntree in pre-order:"
  p tree.preorder
  puts "\ntree in post-order:"
  p tree.postorder
end

run_test
