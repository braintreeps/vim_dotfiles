task :default => :compile_command_t

desc 'compile Comamnd-T'
task :compile_command_t do
  Dir.chdir(File.dirname(__FILE__) + "/vim/bundle/Command-T") do
    sh "rake make"
  end
end
