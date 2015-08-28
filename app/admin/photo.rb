ActiveAdmin.register Photo do
  permit_params :image

  index as: :block do |photo|
    div for: photo do
      img src: photo.image.url(:medium)
    end
  end

  form do |f|
    f.inputs do
      f.input :image, as: :file
      f.input :description, as: :string
    end
    f.submit
  end

end
