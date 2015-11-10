module AlbumsHierarchy
  extend ActiveSupport::Concern
  HIERARCHY_ATTRS = [:id, :album_id, :name]
  def hierarchy(scope = nil, deep = 0, result = nil)
    scope ||= Album.select(*HIERARCHY_ATTRS).to_a
    result ||= []
    scope.delete(self)
    children = scope.find_all {|al| al.album_id == id}
    scope.delete_if {|al| children.map(&:id).include?(al.id) }
    result << { album: self.as_json(only: HIERARCHY_ATTRS), deep: deep, deepest: children.blank? }
    children.each {|album| album.hierarchy(scope, deep + 1, result)}
    result
  end

  module ClassMethods
    def hierarchy
      return @@hierarchy if defined?(@@hierarchy) && @@hierarchy.present?
      @@hierarchy = []
      all = select(*HIERARCHY_ATTRS)
      all.where(album_id: nil).each do |album|
        @@hierarchy.concat album.hierarchy(all.to_a, 0)
      end
      @@hierarchy    
    end
  end

end