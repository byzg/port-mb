ActiveAdmin.register Album do
  config.clear_sidebar_sections!
  permit_params :album_id, :cover_id, :name, :priority, :description
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil).includes(:cover)}

  # breadcrumb do
  #   session[:breadcrumbs] = []
  #   session[:breadcrumbs] << link_to(resource.name, admin_album_path(resource)).html_safe
  # end
  
  index { render partial: 'index' }
  show { render partial: 'children' }
  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :parent, as: :select, collection: albumable_options(Album.new)
    end
    f.submit
  end

  controller do
    before_filter :get_hierarchy, only: [:new, :index, :show]
    before_filter :get_breadcrumbs, only: :show

    def show
      @collection = resource.children
      @collection = resource.photos if @collection.empty?
      super
    end

    def destroy
      super {|format| format.js { head :ok } }
    rescue 
      Rails.logger.info $!
      Rails.logger.info $!.backtrace.join("\n")
    end

    def update
      super {|format| format.json { head :ok } }
    end

    private

    def get_hierarchy
      @hierarchy = Album.hierarchy
    end

    def get_breadcrumbs

    end
  end

  member_action :cover_edit, method: :get do    
    album = Album.find(params[:id])
    render json: album.children_photos
  end

end