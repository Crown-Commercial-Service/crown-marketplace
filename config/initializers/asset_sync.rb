if defined?(AssetSync)
  AssetSync.configure do |config|
    config.enabled = Rails.env.production? && ENV['APP_RUN_PRECOMPILE_ASSETS'] == 'TRUE'
    config.fog_provider = 'AWS'
    config.aws_iam_roles = true
    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')
    config.fog_directory = ENV.fetch('ASSETS_BUCKET', nil)
    config.fog_region = 'eu-west-2'

    config.add_local_file_paths do
      Dir.chdir(Rails.public_path) do
        packs_dir = Webpacker.config.public_output_path.relative_path_from(Rails.public_path)
        Dir[File.join(packs_dir, '/**/**')]
      end
    end
  end
end
