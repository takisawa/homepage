require 'erb'
require 'fileutils'

TEMPLATE_DIR = '../templates/'
PARTS_DIR = '../parts/'
DEST_DIR = '../dest/'
LAYOUT_PATH = '../layouts/layout.html.erb'

b = binding

Dir.glob(File.join(PARTS_DIR, '**', '*.html')).each do |path|
  var_name = File.basename(path, '.html')
  b.local_variable_set(var_name, File.read(path))
  STDOUT.puts "Set variable: #{var_name}"
end

erb_layout = ERB.new(File.read(LAYOUT_PATH))

Dir.glob(File.join(TEMPLATE_DIR, '**', '*.html.erb')).each do |path|
  page_body = ERB.new(File.read(path)).result(b)
  b.local_variable_set('page_body', page_body)
  html = erb_layout.result(b)

  key = path.sub(TEMPLATE_DIR, '')
  key = key.sub('.erb', '')
  dest_path = File.join(DEST_DIR, key)
  p dest_path
  FileUtils.mkdir_p(File.dirname(dest_path))
  File.open(dest_path, 'w') {|f| f.write(html) }
end
