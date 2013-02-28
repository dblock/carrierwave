# encoding: utf-8
module CarrierWave
  module Uploader
    module Marshalling
      extend ActiveSupport::Concern

      def marshal_dump
      end

      def marshal_load(data)
      end

    end
  end
end
