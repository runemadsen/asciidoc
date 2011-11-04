module AsciiDoc
  
  module AsciiPlugins

    Plugins = []

    def self.register(plugin)
      puts "register plugin baby: #{Plugins.size}"
      Plugins << plugin
    end

    def order_plugins
      Plugins.sort! do |x,y| 
        x_val = x.has_key?(:order) ? x[:order] : 99999999999
        y_val = y.has_key?(:order) ? y[:order] : 99999999999
        x_val <=> y_val
      end
    end

  end
  
end