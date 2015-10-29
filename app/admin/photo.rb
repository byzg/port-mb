ActiveAdmin.register Photo do
  config.clear_sidebar_sections!
  permit_params :description, :album_id, :image, :name
  config.per_page = 3 if Rails.env.development?

  index do
    render partial: 'index'
  end

  form partial: 'form'

  controller do
    before_filter :get_hierarchy, only: [:new, :index]

    def create
      # render json: Photo.last
      params[:photo][:image] = params[:photo][:image][0]
      super do |format|
        format.html do
          redirect_to edit_admin_photo_path(resource) and return if resource.valid?
        end
        format.json do
          render json: resource
        end
      end
    end

    def update
      super do |format|
        responce = if resource.invalid?
          render json: { errors: resource.errors.full_messages }
        else
          head :ok
        end
        format.json { responce }
      end
    end

    def destroy
      super {|format| format.js { head :ok } }
    end

    private

    def get_hierarchy
      @hierarchy = Album.hierarchy
    end
  end

  collection_action :albumable, method: :put do
    ActiveRecord::Base.connection.execute(<<-EOQ)
      UPDATE photos
        SET album_id = CASE id
          #{params[:photos].map {|param| "WHEN '#{param[:id]}' THEN #{param[:album_id]}"}.uniq.join(' ')}
          END
        WHERE id IN(#{params[:photos].map {|param| "'#{param[:id]}'"}.uniq.join(', ')});
    EOQ
    head :ok
  end

end
