module Blorgh
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    isolate_namespace Blorgh
  end
end
