module ActiveScaffold
  module Helpers
    module ListColumnHelpers
      def active_scaffold_column_dragonfly(column, record)
        attachment = record.send("#{column.name}")
        return nil unless attachment.present?
        content = if attachment.image?
          image_tag(attachment.thumb(column.options[:thumb] || ActiveScaffold::Bridges::Dragonfly::Lib::DragonflyBridgeHelpers.thumbnail_style).url, :border => 0)
        else
          attachment.name
        end
        link_to(content, attachment.remote_url, {'data-popup' => true, :target => '_blank'})
      end
    end
  end
end