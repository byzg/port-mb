module AlbumsHierarchy
  extend ActiveSupport::Concern

  def hierarchy(scope = Album.select(:id, :album_id, :name).to_a, deep = 0, result = nil)
    result ||= []
    scope.delete(self)
    children = scope.find_all {|al| al.album_id == id}
    scope.delete_if {|al| children.map(&:id).include?(al.id) }
    result << { album: self, deep: deep, deepest: children.blank? }
    children.each {|album| album.hierarchy(scope, deep + 1, result)}
    result
  end

  module ClassMethods
    def hierarchy
      return @@hierarchy if defined?(@@hierarchy) && @@hierarchy.present?
      @@hierarchy = []
      all = select(:id, :album_id, :name)
      all.where(album_id: nil).each do |album|
        @@hierarchy.concat album.hierarchy(all.to_a, 0)
      end
      @@hierarchy    
    end
  end

end