command RunRubyFocusedUnitTest :call <SID>RunRubyFocusedUnitTest()

function! s:RunRubyFocusedUnitTest()
  ruby RubyFocusedUnitTest.new.run_test
endfunction

ruby << EOF
class RubyFocusedUnitTest
  def run_test
    @file_name = VIM::Buffer.current.name
    @line_number = VIM::Buffer.current.line_number 

    if @file_name =~ /spec/
      VIM::command("!spec #{@file_name} -l #{@line_number}")
      return
    end

    lines = File.read(@file_name).split("\n")

    method_name = nil

    (@line_number + 1).downto(0) do |line_number|
      if lines[line_number] =~ /def (test_\w+)/ 
        method_name = $1
        break
      elsif lines[line_number] =~ /test "([\w\s]+)"/ 
        method_name = "test_" + $1.split(" ").join("_")
        break
      end
    end

    if method_name
      VIM::command("!ruby #{@file_name} -n #{method_name}")
    end
  end
end
EOF

