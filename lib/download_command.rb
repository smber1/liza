
class DownloadCommand
  def initialize args
    @bucket_name = args[:bucket]
    @dir = args[:dir]
  end

  def execute
    download_all
  end

  private 

  attr_reader :bucket_name, :dir

  def download_all
    bucket.objects.each do |obj|
      download obj
    end
  end

  def download obj
    File.open(file_path(obj.key), 'wb') do |file|
      obj.read do |chunk|
        file.write(chunk)
      end
    end
  end

  def file_path filename
    File.join dir, friendly_filename(filename)
  end

  def friendly_filename filename
    filename.gsub(/\//,'-')
  end

  def s3
    @s3 ||= AWS::S3.new
  end

  def bucket
    @bucket ||= s3.buckets[bucket_name]
  end
end