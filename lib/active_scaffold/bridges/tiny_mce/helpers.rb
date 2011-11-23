class ActiveScaffold::Bridges::TinyMce
  module Helpers
    def self.included(base)
      base.class_eval do
        include FormColumnHelpers
        include SearchColumnHelpers
      end
    end

    module FormColumnHelpers
      def self.included(base)
        base.alias_method_chain :onsubmit, :tiny_mce
      end

      def active_scaffold_input_text_editor(column, options)
        options[:class] = "#{options[:class]} mceEditor #{column.options[:class]}".strip
        html = []
        html << send(override_input(:textarea), column, options)
        html << javascript_tag("tinyMCE.execCommand('mceAddControl', false, '#{options[:id]}');") if request.xhr? || params[:iframe]
        html.join "\n"
      end

      def onsubmit_with_tiny_mce
        if ActiveScaffold.js_framework == :jquery
          submit_js = 'tinyMCE.triggerSave();$(\'textarea.mceEditor\').each(function(index, elem) { tinyMCE.execCommand(\'mceRemoveControl\', false, $(elem).attr(\'id\')); });'
        else
          submit_js = 'tinyMCE.triggerSave();this.select(\'textarea.mceEditor\').each(function(elem) { tinyMCE.execCommand(\'mceRemoveControl\', false, elem.id); });'
        end
        [onsubmit_without_tiny_mce, submit_js].compact.join ';'
      end
    end

    module SearchColumnHelpers
      def self.included(base)
        base.class_eval { alias_method :active_scaffold_search_text_editor, :active_scaffold_search_text }
      end
    end
  end
end

ActionView::Base.class_eval { include ActiveScaffold::Bridges::TinyMce::Helpers }
