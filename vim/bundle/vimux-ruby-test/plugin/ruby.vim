if exists("g:loaded_vimux_ruby_test") || &cp
  finish
endif
let g:loaded_vimux_ruby_test = 1

if !has("ruby")
  finish
end

command RunAllRubyTests :call s:RunAllRubyTests()
command RunRubyFocusedTest :call s:RunRubyFocusedTest()
command RunRubyFocusedContext :call s:RunRubyFocusedContext()

function s:RunAllRubyTests()
  ruby RubyTest.new.run_all
endfunction

function s:RunRubyFocusedTest()
  ruby RubyTest.new.run_test
endfunction

function s:RunRubyFocusedContext()
  ruby RubyTest.new.run_context
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

  def spec_file?
    current_file =~ /spec_|_spec/
  end

  def line_number
    VIM::Buffer.current.line_number
  end

  def run_spec
    send_to_vimux("#{spec_command} '#{current_file}' -l #{line_number}")
  end

  def run_unit_test
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

    send_to_vimux("ruby #{current_file} -n #{method_name}") if method_name
  end

  def run_test
    if spec_file?
      run_spec
    else
      run_unit_test
    end
  end

  def run_context
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
        send_to_vimux("#{spec_command} #{current_file} -l #{context_line_number}")
      else
        method_name = "\"/#{Regexp.escape(method_name)}/\""
        send_to_vimux("ruby #{current_file} -n #{method_name}")
      end
    end
  end

  def run_all
    if spec_file?
      send_to_vimux("#{spec_command} '#{current_file}'")
    else
      send_to_vimux("ruby '#{current_file}'")
    end
  end

  def spec_command
    if File.exists?("Gemfile") && match = `bundle show rspec`.match(/(\d+\.\d+\.\d+)$/)
      match.to_a.last.to_f < 2 ? "bundle exec spec" : "bundle exec rspec"
    else
      system("rspec -v > /dev/null 2>&1") ? "rspec --no-color" : "spec"
    end
  end

  def send_to_vimux(test_command)
    Vim.command("call RunVimTmuxCommand(\"clear && #{test_command}\")")
  end
end
EOF
