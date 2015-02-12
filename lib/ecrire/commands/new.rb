require 'pathname'
require 'fileutils'

require 'ecrire/commands/base'

module Ecrire
  module Commands
    class New < Ecrire::Commands::Base
      attr_reader :path
      def initialize(options = {}, *args)
        if args[0].nil?
          puts 'Please specify a blog name.'
          puts 'Example: ecrire new blog.domain.com'
          exit
        end
        @path = Pathname.new(Dir.pwd)
        @path += args[0]
      end

      def run!
        if Dir.exist?(@path)
          ask_to_overwrite!
          FileUtils.rm_rf(@path)
        end
        generate!
      end

      def generate!
        Dir.mkdir @path
        Dir.chdir @path
        template = File.expand_path '../../template/*', __FILE__
        FileUtils.cp_r(Dir[template], @path)
        secrets!
      end

      def ask_to_overwrite!
        puts "You are about to overwrite #{@path} with a new theme."
        puts "Are you sure? [y/n]"
        confirm = STDIN.gets.chomp
        if confirm != 'y'
          exit
        end
      end

      def secrets!
        File.open(Dir.pwd + '/secrets.yml', 'w') do |file|
          secrets = Hash.new
          secrets['production'] = secrets['development'] = secrets['defaults'] = Hash.new
          secrets['defaults']['secret_key_base'] = SecureRandom.hex(64)
          file.write(secrets.to_yaml)
        end
      end
    end
  end
end
