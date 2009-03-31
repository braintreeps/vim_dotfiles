if !has("ruby")
  finish
end

command RunRubyFocusedUnitTest :call <SID>RunRubyFocusedUnitTest()
command RunAllRubyTests :call <SID>RunAllRubyTests()

function! s:RunRubyFocusedUnitTest()
  ruby RubyFocusedUnitTest.new.run_test
endfunction

function! s:RunAllRubyTests()
  ruby RubyFocusedUnitTest.new.run_all
endfunction

ruby << EOF
module VIM
  class Buffer
    class << self
      include Enumerable

      def each(&block)
        (0...VIM::Buffer.count).each do |index|
          yield self[index]
        end
      end

      def create(name, opts={})
        location = opts[:location] || :below
        VIM.command("#{location} new #{name}")
        buf = VIM::Buffer.current
        if opts[:text]
          buf.text = opts[:text]
        end
        buf
      end
    end

    def text=(content)
      content.split("\n").each_with_index do |line,index|
        self.append index, line
      end
    end

    def method_missing(method, *args, &block)
      VIM.command "#{method} #{self.name}"
    end
  end
end

class RubyFocusedUnitTest
  DEFAULT_OUTPUT_BUFFER = "rb_test_output"

  def write_output_to_buffer(test_command)
    if buffer = VIM::Buffer.find { |b| b.name =~ /#{DEFAULT_OUTPUT_BUFFER}/ }
      buffer.bdelete! 
    end

    test_output = `#{test_command}`

    VIM::Buffer.create DEFAULT_OUTPUT_BUFFER, :location => :below, :text => test_output
    VIM::command("setlocal buftype=nowrite")
  end

  def current_file
    VIM::Buffer.current.name
  end

  def line_number
    VIM::Buffer.current.line_number 
  end

  def run_spec
    write_output_to_buffer("spec #{current_file} -l #{line_number}")
  end

  def run_unit_test
    method_name = nil

    (line_number + 1).downto(0) do |line_number|
      if VIM::Buffer.current[line_number] =~ /def (test_\w+)/ 
        method_name = $1
        break
      elsif VIM::Buffer.current[line_number] =~ /test ("|')([^"']+)("|')/ 
        method_name = "test_" + $2.split(" ").join("_")
        break
      end
    end

    write_output_to_buffer("ruby #{current_file} -n #{method_name}") if method_name
  end

  def run_test
    if current_file =~ /spec_|_spec/
      run_spec
    else
      run_unit_test
    end
  end

  def run_all
    write_output_to_buffer("ruby #{current_file}")
  end
end
EOF

