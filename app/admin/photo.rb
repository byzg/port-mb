ActiveAdmin.register Photo do
  config.clear_sidebar_sections!
  permit_params :description, :album_id, :image, :name

  index as: :block do |photo|
    # a href: edit_admin_photo_path(photo) do
    span for: photo do
      resource_selection_cell photo
      img src: photo.image.url(:medium)
      div photo.description, class: :description
    end
    # end
  end

  form partial: 'form'

  controller do
    def new
      @albums = Album.deepest.map {|a| [a.name, a.id]}
      super
    end

    def create
      # r = Photo.last
      # render json: { image_url: r.image.url(:grid), id: r.id, album_id: r.album_id }
      params[:photo][:image] = params[:photo][:image][0]
      super do |format|
        format.html do
          redirect_to edit_admin_photo_path(resource) and return if resource.valid?
        end
        format.json do
          render json: { image_url: resource.image.url(:grid), id: resource.id, album_id: resource.album_id }
        end
      end
    end

    def update
      super {|format| format.json { head :ok } }
    end

    def destroy
      super {|format| format.js { head :ok } }
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
