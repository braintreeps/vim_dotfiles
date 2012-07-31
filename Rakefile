task :default => :compile_command_t

desc 'compile Comamnd-T'
task :compile_command_t do
  Dir.chdir(File.dirname(__FILE__) + "/vim/bundle/Command-T") do
    sh "rake make"
  end
end

desc 'symlink files into home directory'
task :activate do
  working_dir = File.expand_path(File.dirname(__FILE__))
  home_dir = File.expand_path("~")
  dot_files = Dir.glob(File.join(working_dir,"*"))

  dot_files.each do |filename|
    next if filename =~ /Rakefile/ || filename =~ /README\.txt$/

    sym_link = File.join(home_dir,".#{File.basename(filename)}")

    rm_rf(sym_link) if File.symlink?(sym_link) || File.exist?(sym_link)
    ln_s filename, sym_link
  end
end
