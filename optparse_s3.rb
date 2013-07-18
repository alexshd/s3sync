require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'
require 'logger'

class OptparseS3
  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.threads = 2
    options.local_dir = "."
    options.s3_bucket_name
    options.s3_access_key_id
    options.s3_secret_key_id
    options.log_level = Logger::INFO
    options.verbose = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Mandatory argument.
      opts.on("-t", "--threads THREADS",
              "Number of Threads to run") do |thr|
        options.threads = thr if thr != nil
      end

      opts.on("-d", "--directory [DIR]",
              "Directory to SYNC") do |dir|
        options.local_dir = dir
      end

      opts.on("-b", "--bucket DATA", "Bucket Name") do |name|
        options.s3_bucket_name = name
      end

      opts.on("--access_key DATA", "Access Key ID") do |id_a|
        options.s3_access_key_id = id_a
      end

      opts.on("--secret_key DATA", "Secret Key ID") do |id_s|
        options.s3_secret_key_id = id_s
      end

      opts.on("--log-level LEVEL", "Log level") do |level|
	      options.log_level = Logger.const_get(level.upcase)
      end

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts OptionParser::Version.join('.')
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end  # parse()

end