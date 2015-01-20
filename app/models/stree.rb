require 'tree'
class Stree
  # init
  def initialize(init_sprint)
    name = init_sprint.id
    content = get_content(init_sprint)
    @root = Tree::TreeNode.new(name, content)
  end
  # add node
  def add(sprint)
    name = sprint.id
    parent = sprint.parent
    content = get_content(sprint)
    new_node = Tree::TreeNode.new(name, content)
    parent_node = find(parent)
    parent_node << new_node
  end
  # get content
  def get_content(sprint)
    content = {name: sprint.name, desc: sprint.desc, start: sprint.start, end: sprint.end, 
      hours: sprint.hours, happy: sprint.happy}
  end
  # find a node
  def find(id)
    find_helper(@root, id)
  end
  def find_helper(node, id)
    if node == nil
      return nil
    end
    if node.name == id
      return node
    else
      children = node.children
      if children.empty?
        return nil
      end
      children.each { |c|
        res = find_helper(c, id)
        if res
          return res
        end
      }
      return nil
    end
  end
  # print
  def print
    @root.print_tree
  end
  def root
    @root
  end
  # return json
  def to_json
    @root.to_json
  end
end
