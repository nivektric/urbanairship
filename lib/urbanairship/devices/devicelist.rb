require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelInfo

      attr_writer :client
      include Urbanairship::Common

      def initialize(client)
        @client = client
      end

      def lookup(uuid)
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid,
          version: 3
        )
        response['body']['channel']
      end
    end

    class ChannelList
      include Urbanairship::Common
      include Enumerable

      def initialize(client)
        @next_page = CHANNEL_URL
        @client = client
        @channel_list = nil
        load_page
      end

      def each
        while @channel_list
          @channel_list.each do | value |
            yield value
          end
          @channel_list = nil
          if @next_page
            load_page
          end
        end
      end

      def load_page
        response = @client.send_request(
          method: 'GET',
          url: @next_page,
          version: 3,
        )
        if response['body']['next_page']
          @next_page = response['body']['next_page']
        else
          @next_page = nil
        end
        @channel_list = response['body']['channels']
      end
    end
  end
end