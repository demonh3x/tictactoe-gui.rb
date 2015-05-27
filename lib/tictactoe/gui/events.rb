module Tictactoe
  module Gui
    module Events
      def register(event, handler)
        handlers(event) << handler
      end

      def handlers(event)
        @handlers ||= {}
        @handlers[event] ||= []
      end

      def notifier(event)
        lambda do |*arguments|
          handlers(event).each {|handler| handler.call(*arguments)}
        end
      end

      module ClassMethods
        def receives_handlers_for(*event_names)
          event_names.each do |event_name| 
            define_method(event_name) {|handler| register(event_name, handler) }
          end
        end
      end

      def self.included(receiver)
        receiver.extend ClassMethods
      end
    end
  end
end
