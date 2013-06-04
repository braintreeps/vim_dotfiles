if exists("g:loaded_vimux_ruby_test") || &cp
  finish
endif
let g:loaded_vimux_ruby_test = 1

if !has("ruby")
  finish
end

if !exists("g:vimux_ruby_cmd_unit_test")
  let g:vimux_ruby_cmd_unit_test = "ruby"
endif
if !exists("g:vimux_ruby_cmd_all_tests")
  let g:vimux_ruby_cmd_all_tests = "ruby"
endif
if !exists("g:vimux_ruby_cmd_context")
  let g:vimux_ruby_cmd_context = "ruby"
endif

command RunAllRubyTests :call s:RunAllRubyTests()
command RunAllRailsTests :call s:RunAllRailsTests()
command RunRubyFocusedTest :call s:RunRubyFocusedTest()
command RunRailsFocusedTest :call s:RunRailsFocusedTest()
command RunRubyFocusedContext :call s:RunRubyFocusedContext()

function s:RunAllRubyTests()
  ruby RubyTest.new.run_all(false, Vim.evaluate('g:vimux_ruby_cmd_all_tests'))
endfunction

function s:RunAllRailsTests()
  ruby RubyTest.new.run_all(true, Vim.evaluate('g:vimux_ruby_cmd_all_tests'))
endfunction

function s:RunRubyFocusedTest()
  ruby RubyTest.new.run_test(false, Vim.evaluate('g:vimux_ruby_cmd_unit_test'))
endfunction

function s:RunRailsFocusedTest()
  ruby RubyTest.new.run_test(true, Vim.evaluate('g:vimux_ruby_cmd_unit_test'))
endfunction

function s:RunRubyFocusedContext()
  ruby RubyTest.new.run_context(Vim.evaluate('g:vimux_ruby_cmd_context'))
endfunction

ruby << EOF
module VIM
  class Buffer
    def method_missing(method, *args, &block)
      VIM.command "#{method} #{self.name}"
    end
  end
end

class RubyTest
  def current_file
    VIM::Buffer.current.name
  end

  def rails_test_dir
    current_file.split('/')[0..-current_file.split('/').reverse.index('test')-1].join('/')
  end

  def spec_file?
    current_file =~ /spec_|_spec/
  end

  def line_number
    VIM::Buffer.current.line_number
  end

  def run_spec
    send_to_vimux("#{spec_command} #{current_file}:#{line_number}")
  end

  def run_unit_test(rails=false, ruby_command='ruby')
    method_name = nil

    (line_number + 1).downto(1) do |line_number|
      if VIM::Buffer.current[line_number] =~ /def (test_\w+)/
        method_name = $1
        break
      elsif VIM::Buffer.current[line_number] =~ /test "([^"]+)"/ ||
            VIM::Buffer.current[line_number] =~ /test '([^']+)'/
        method_name = "test_" + $1.split(" ").join("_")
        break
      elsif VIM::Buffer.current[line_number] =~ /should "([^"]+)"/ ||
            VIM::Buffer.current[line_number] =~ /should '([^']+)'/
        method_name = "\"/#{Regexp.escape($1)}/\""
        break
      end
    end

    send_to_vimux("#{ruby_command} #{"-I #{rails_test_dir} " if rails}#{current_file} -n #{method_name}") if method_name
  end

  def run_test(rails=false, ruby_command='ruby')
    if spec_file?
      run_spec
    else
      run_unit_test(rails, ruby_command)
    end
  end

  def run_context(ruby_command='ruby')
    method_name = nil
    context_line_number = nil

    (line_number + 1).downto(1) do |line_number|
      if VIM::Buffer.current[line_number] =~ /(context|describe) "([^"]+)"/ ||
         VIM::Buffer.current[line_number] =~ /(context|describe) '([^']+)'/
        method_name = $2
        context_line_number = line_number
        break
      end
    end

    if method_name
      if spec_file?
        send_to_vimux("#{spec_command} #{current_file}:#{context_line_number}")
      else
        method_name = Regexp.escape(method_name)
        send_to_vimux("#{ruby_command} #{current_file} -n /'#{method_name}'/")
      end
    end
  end

  def run_all(rails=false, ruby_command='ruby')
    if spec_file?
      send_to_vimux("#{spec_command} '#{current_file}'")
    else
      send_to_vimux("#{ruby_command} #{"-I #{rails_test_dir} " if rails}#{current_file}")
    end
  end

  def spec_command
    if File.exists?('./.zeus.sock')
      'zeus rspec'
    elsif File.exists?('./bin/rspec')
      './bin/rspec'
    elsif File.exists?("Gemfile") && (match = `bundle show rspec-core`.match(/(\d+\.\d+\.\d+)$/) || match = `bundle show rspec`.match(/(\d+\.\d+\.\d+)$/i))
      match.to_a.last.to_f < 2 ? "bundle exec spec" : "bundle exec rspec"
    else
      system("rspec -v > /dev/null 2>&1") ? "rspec --no-color" : "spec"
    end
  end

  def send_to_vimux(test_command)
    Vim.command("call VimuxRunCommand(\"clear && #{test_command}\")")
  end
end
EOF
