require File.dirname(__FILE__) + '/server/app.rb'

module Openneo
  module Auth
    module Server
      class << self
        def [](key)
          apps[key]
        end
        
        def apps
          unless @apps
            app_data = config['apps']
            unless app_data
              raise UnconfiguredError, "No server.apps key in #{config_path}"
            end
            @apps = {}
            app_data.each do |key, name|
              @apps[key] = App.new(key, name)
            end
          end
          @apps
        end
        
        def config
          unless @config
            @config = YAML.load_file(config_path)
            unless @config
              raise UnconfiguredError, "Could not load config at #{config_path}"
            end
            @config = @config['server']
            unless @config
              raise UnconfiguredError, "No \"server\" key in #{config_path}"
            end
          end
          @config
        end
        
        def signatory
          @signatory ||= Openneo::Auth::Signatory.new(config['secret'])
        end
        
        private
        
        def config_path
          @config_path ||= Rails.root.join('config', 'openneo_auth.yml')
        end
      end
      
      class RemoteAuthFailed < RuntimeError;end
      class UnconfiguredError < RuntimeError;end
    end
  end
end
