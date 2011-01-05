module Openneo
  module Auth
    module Server
      class App
        attr_reader :key, :name
        
        def initialize(key, name)
          @key = key
          @name = name
          @party = Party.new(self)
          @passthru = !Server.config['apps_without_passthru'].include?(key)
        end
        
        def host
          "#{@key}.openneo.net"
        end
        
        def login_url
          passthru? ? "#{root_url}login?from=#{Server.config['id']}" : root_url
        end
        
        def passthru?
          @passthru
        end
        
        def remote_sign_in!(user, remote_session)
          @party.post remote_packet(user, remote_session)
        end
        
        def root_url
          "http://#{host}/"
        end
        
        def remote_packet(user, remote_session)
          packet = {
            :session_id => remote_session[:session_id],
            :source => Server.config['id'],
            :user => user.to_remote_packet_data
          }
          packet[:signature] = Server.signatory.sign(packet)
          packet
        end
        
        class Party
          include HTTParty
          
          def initialize(app)
            @app = app
          end
          
          def post(packet)
            Rails.logger.info "Sending remote auth packet to #{@app.root_url}, /users/authorize"
            Rails.logger.info packet.inspect
            output = self.class.post(
              'users/authorize',
              :base_uri => @app.root_url,
              :body => packet
            )
            unless output.to_s == "Success"
              raise RemoteAuthFailed, "Remote authorization failed: #{output.to_s.inspect}"
            end
          end
        end
      end
    end
  end
end
