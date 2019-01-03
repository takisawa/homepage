require 'aws-sdk-s3'

ACCESS_KEY_ID = ENV['ACCESS_KEY_ID']
SECRET_ACCESS_KEY = ENV['SECRET_ACCESS_KEY']
BUCKET_NAME = ENV['BUCKET_NAME']

DEST_DIR = '../dest/'

s3 = Aws::S3::Resource.new(region: 'ap-northeast-1',
                           access_key_id: ACCESS_KEY_ID,
                           secret_access_key: SECRET_ACCESS_KEY)
bucket = s3.bucket(BUCKET_NAME)

Dir.glob(File.join(DEST_DIR, '**', '*.html')).each do |path|
  key = path.sub(DEST_DIR, '')

  obj = s3.bucket(BUCKET_NAME).object(key)
  obj.upload_file(path)
  STDOUT.puts "#{'%-40s' % path} => #{key}"
end
