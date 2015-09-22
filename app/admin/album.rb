ActiveAdmin.register Album do
  permit_params :album_id, :cover_id, :name, :priority
  scope :all
  scope('По иерархии', default: true) {|scope| scope.where(album_id: nil)}
  
  index do |album|
    render partial: 'index'
  end

end