ActiveAdmin.register Album do
  config.clear_sidebar_sections!
  permit_params :album_id, :cover_id, :name, :priority, :description
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil).includes(:cover)}
  
  index { render partial: 'index' }
  show { render partial: 'children' }
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :description
      f.input :parent, as: :select, collection: albumable_options(Album.new)
    end
    f.submit
  end

  controller do
    before_filter :get_hierarchy, only: [:new, :index, :show, :create, :edit, :update]
    before_filter :get_breadcrumbs, only: :show

    def show
      @collection = resource.children
      @collection = resource.photos if @collection.empty?
      super
    end

    def destroy
      super do |format|
        format.json { render json: { status: 'OK' } }
        format.html { redirect_to admin_albums_path }
      end
    rescue ActiveRecord::RecordNotDestroyed
      key = 'activerecord.errors.messages.forbidden_destroy_cover'
      return render json: { errors: I18n.t(key) }
    end

    def update
      super do
        errors = resource.errors.full_messages
        return render json: if errors.empty?
          { status: 'OK' }
        else
          { errors: resource.errors.full_messages }
        end
      end
    end

    private

    def get_hierarchy
      @hierarchy = Album.hierarchy
    end

    def get_breadcrumbs
      @breadcrumbs = resource.breadcrumbs.to_json
    end
  end

  member_action :cover_edit, method: :get do    
    album = Album.find(params[:id])
    render json: album.children_photos
  end

end