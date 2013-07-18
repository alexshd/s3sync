#!/home/alex/.rvm/rubies/ruby-2.0.0-p247/bin/ruby
require './optparse_s3.rb'
require './s3sync.rb'



options = OptparseS3.parse(ARGV)

logger = Logger.new(STDOUT)
sync = S3sync.new(logger, options).files_to_queue

workers = (1..options.threads.to_i).map do |a|
	Thread.new do
		sync.upload_worker()
	end
end

workers.each do |worker|
	logger.info { "Worker - #{worker.status}" }
	worker.join
end

