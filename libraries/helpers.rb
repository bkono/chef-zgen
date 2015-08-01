module Zgen
  module Helpers
    attr_accessor :active_user

    def user_home
      node['etc']['passwd'][active_user]['dir']
    end

    def zgen_home
      "#{user_home}/.zgen"
    end

    def zgen_repo 
      "#{zgen_home}/repo"
    end

    def zgen_users
      @zgen_users ||= begin
        users = []
        users << node['current_user']
        users << node['zgen']['users']
        users.flatten.compact!
      end
    end
  end
end
