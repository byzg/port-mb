require 'spec_helper'

describe Album do
  
  it '.hierarchy' do
    create(:album, name: 'al1')
    create(:album, name: 'al2')
    create(:album, name: 'al11', album_id: 1)
    create(:album, name: 'al12', album_id: 1)
    create(:album, name: 'al21', album_id: 2)
    create(:album, name: 'al121', album_id: 4)
    create(:album, name: 'al122', album_id: 4)
    wish_hash = {
      al1: {
        al11: {},
        al12: {
          al121: {},
          al122: {}
        }
      },
      al2: { al21: {} }
    }
    handle = Proc.new do |hash|
      Hash[hash.map {|k, v| [k.name.to_sym, handle.call(v)] }]
    end
    result_hash = handle.call(Album.hierarchy)
    expect(result_hash).to eq wish_hash
  end

end