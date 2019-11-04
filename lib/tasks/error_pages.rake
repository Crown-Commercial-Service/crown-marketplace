task :error_pages, :remote_site do |_t, args|
  ['404', '422', '500', 'maintenance'].each do |page|
    site = args[:remote_site]
    uri = URI("#{site}/errors/#{page}.html")
    final_destination = "public/#{page}.html"

    html_file = Tempfile.new('page')
    sh "curl #{uri} --output #{html_file.path}"
    out_file = Tempfile.new('page-inline')

    command = "npx juice --web-resources-relative-to #{site}/ --apply-style-tags false " \
             '--remove-style-tags false --preserve-media-queries false'

    sh "#{command} #{html_file.path} #{out_file.path}"

    header = '<!-- STOP: please do not edit these directly, see the errors controller -->'
    sh "echo '#{header}' > #{final_destination}"
    sh "cat #{out_file.path} >> #{final_destination}"
  end
end
