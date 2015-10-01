ActiveAdmin.register Album do
  config.clear_sidebar_sections!
  permit_params :album_id, :cover_id, :name, :priority
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil).includes(:cover)}
  
  index { render partial: 'index' }

  controller do
    before_filter :get_hierarchy, only: [:new, :index]

    def cover_edit
      
    end

    def cover_update
    end

    def destroy
      super {|format| format.js { head :ok } }
    end

    private

    def get_hierarchy
      @hierarchy = Album.hierarchy
    end
  end

end