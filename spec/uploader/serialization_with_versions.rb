require 'spec_helper'

describe CarrierWave::Uploader do

  before :all do

    class SerializationSpec_Avatar_Uploader < CarrierWave::Uploader::Base
      version :famous do

      end
    end

    class SerializationSpec_Avatar
      extend CarrierWave::Mount

      attr_accessor :name
      mount_uploader :picture, SerializationSpec_Avatar_Uploader
    end

  end

  let(:cache) do
    ActiveSupport::Cache.lookup_store(:memory_store)
  end

  describe 'ActiveSupport cache' do
    it "stores an uploader" do

      image = cache.fetch "key" do
        image = SerializationSpec_Avatar.new
        image.name = "hal"
        image.picture = File.open(file_path('test.jpg'))
        image
      end

      path = image.picture.famous.to_s

      uploader_const = "Uploader#{SerializationSpec_Avatar.uploaders[:picture].versions[:famous][:uploader].object_id}"
      SerializationSpec_Avatar.uploaders[:picture].send :remove_const, uploader_const

      cached_instance = cache.fetch "key" do
        # not reached
      end

      cached_instance.name.should == "hal"
      cached_instance.picture.should be_a SerializationSpec_Avatar_Uploader
      cached_instance.picture.famous.should be_a SerializationSpec_Avatar_Uploader
      cached_instance.picture.famous.to_s.should == path
    end
  end
end
