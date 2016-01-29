require_relative 'inode_monitor'

trap("INT") do
    puts 'Stoping Monitor....'
    exit 2
end

puts 'starting monitor'
monitor = InodeMonitor.new('test.log')
puts 'monitoring test.log'

puts 'press ctrl+c to exit'

until (a = gets.chomp) =~ /(?:ex|qu)it/i
  puts a
end
