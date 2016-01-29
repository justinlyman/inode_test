require 'fileutils'

class InodeMonitor

  def initialize(file_path)
    @file_path = file_path

    create_file unless File.exist?(@file_path)

    @file = File.open(@file_path, 'a')
    @file.sync = true
    at_exit { close_file }

    @log_path = 'inode_monitor.log'
    FileUtils.touch(@log_path) unless File.exist?(@log_path)
    @log_file = File.open(@log_path, 'a')
    @log_file.sync = true
    at_exit { @log_file.close }

    @run_thread = Thread.new { loop { check_file; Thread.stop } }
    @loop_thread = Thread.new { loop { sleep 1; break unless @run_thread.alive?; @run_thread.run } }
  end

  def check_file
    # puts 'checking file'
    create_file unless File.exist?(@file_path)
    if @file.stat.ino != File.stat(@file_path).ino
      puts 'file changed'
      update_file
      @log_file.write("file updated at #{Time.now} \n")
    end
  end

private

  def update_file
    close_file
    @file = File.open(@file_path, 'a')
    @file.sync = true
  end

  def close_file
    @file.close
  end

  def create_file
    # Create dirctory structure if it does not exist
    FileUtils.mkdir_p(File.dirname(@file_path))
    # Create file
    FileUtils.touch(@file_path)
  end
end
