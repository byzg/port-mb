ActiveAdmin.register Album do
  permit_params :album_id, :cover_id, :name, :priority
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil)}
  
  index { render partial: 'index' }

  controller do
    before_filter :get_hierarchy, only: [:new, :index]
    def index
      super
    end

    private

    def get_hierarchy
      @hierarchy = Album.hierarchy
    end
  end

end