require 'thread'
require 'logger'
require 'aws-sdk'
#require 'aws/s3'
require 'digest/md5'

class S3sync

	def initialize(logger, options)
		@logger = logger
		@options = options
		@q = Queue.new
	end

	def files_to_queue
		Dir.glob(@options.local_dir + "/*").each do |f|
			@q << f if File.file?(f)
		end
		self
	end

	def upload_worker
		s3 = AWS::S3.new(
			:access_key_id => @options.s3_access_key_id,
			:secret_access_key => @options.s3_secret_key_id, :prefix => 'test/' )
		bucket = s3.buckets[@options.s3_bucket_name]
		until @q.empty?
			file_from_q = @q.pop
			k = bucket.objects[file_from_q]
			unless k.exists? and k.etag == Digest::MD5.file(file_from_q)
				@logger.info { "File #{file_from_q}" }
				k.write(:file => file_from_q)
			end
		end
	end
end