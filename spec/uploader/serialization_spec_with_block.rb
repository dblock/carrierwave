require 'spec_helper'

describe CarrierWave::Uploader do

  before :all do

    class SerializationSpec_Avatar
      extend CarrierWave::Mount

      attr_accessor :name, :value
      mount_uploader :picture do

      end

      def marshal_dump
        [ name, value ]
      end

      def marshal_load(data)
        @name, @value = data
      end
    end

  end

  let(:cache) do
    ActiveSupport::Cache.lookup_store(:memory_store)
  end

  describe 'ActiveSupport cache' do
    it "stores an uploader" do

      cache.fetch "key" do
        image = SerializationSpec_Avatar.new
        image.name = "name"
        image.value = "value"
        image.picture
        image
      end

      uploader_const = "Uploader#{SerializationSpec_Avatar.uploaders[:picture].object_id}"
      SerializationSpec_Avatar.send :remove_const, uploader_const

      cached_instance = cache.fetch "key" do
        # not reached
      end

      cached_instance.name.should == "name"
      cached_instance.value.should == "value"
      cached_instance.picture.should_not be_nil
    end
  end
end
