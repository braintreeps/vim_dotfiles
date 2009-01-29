"-
" Copyright 2008 (c) Meikel Brandmeyer.
" All rights reserved.
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

" Prolog
if !has("ruby")
    finish
endif

try
    if !gatekeeper#Guard("g:gorilla", "1.0.0")
        finish
    endif
catch /^Vim\%((\a\+)\)\=:E117/
    if exists("g:gorilla_loaded")
        finish
    endif
    let g:gorilla_loaded = "1.0.0"
endtry

let s:save_cpo = &cpo
set cpo&vim

function! GorillaSynItem()
    return synIDattr(synID(line("."), col("."), 0), "name")
endfunction

if !exists("g:GorillaJavadocPath")
    let g:GorillaJavadocPath = "http://java.sun.com/javase/6/docs/api/"
endif

if !exists("g:GorillaBrowser")
    if has("win32") || has("win64")
        let g:GorillaBrowser = "start"
    elseif has("mac")
        let g:GorillaBrowser = "open"
    else
        let g:GorillaBrowser = "firefox -new-window"
    endif
endif

function! GorillaOmniTrampoline(findstart, base)
    if a:findstart
        let pos = getpos(".")
        normal b
        let pos2 = col(".")
        call setpos(".", pos)
        return pos2 - 1
    else
        ruby <<EOF
        base = VIM.evaluate("a:base")
        result = Gorilla.omni_complete(base)
        VIM.command("let result = " + result)
EOF
        return result
    endif
endfunction

" The Gorilla Module
ruby <<EOF
require 'net/telnet'

module Gorilla
    PROMPT = "Gorilla=>"
    PROMPT_B = /^#{PROMPT}\s*/
    PROMPT_C = /^#{PROMPT} /

    module Cmd
        def Cmd.bdelete()
            VIM.command("bdelete")
        end

        def Cmd.expand(str)
            return VIM.evaluate("expand('" + str + "')")
        end

        def Cmd.getpos(p)
            return VIM.evaluate("getpos('#{p}')").split(/\n/)
        end

        def Cmd.setpos(p, cursor)
            VIM.command("call setpos('#{p}', [#{cursor.join(",")}])")
        end

        def Cmd.getreg(r)
            return VIM.evaluate("getreg('#{r}')")
        end

        def Cmd.setreg(r, val)
            VIM.command("call setreg('#{r}', '#{val}')")
        end

        def Cmd.input(str)
            return VIM.evaluate("input('" + str + "')").chomp
        end

        def Cmd.map(mode, remap, options, key, target)
            cmd = mode
            cmd = remap ? cmd + "map" : cmd + "noremap"
            cmd = options != "" ? cmd + " " + options : cmd
            cmd = cmd + " " + key
            cmd = cmd + " " + target
            VIM.command(cmd)
        end

        def Cmd.new()
            VIM.command("new")
        end

        def Cmd.normal(cmd)
            VIM.command("normal " + cmd)
        end

        def Cmd.resize(size)
            VIM.command("resize " + size.to_s)
        end

        def Cmd.set(option)
            VIM.set_option(option)
        end

        def Cmd.set_local(option)
            VIM.command("setlocal " + option)
        end

        def Cmd.setfiletype(type)
            VIM.command("setfiletype " + type)
        end
    end

    def Gorilla.setup_maps()
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>lw",
                ":ruby Gorilla.lookup_word(Gorilla.namespace_of($curbuf), Gorilla::Cmd.expand('<cword>'))<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>li",
                ":ruby Gorilla.lookup_word()<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>fd",
                ":ruby Gorilla.find_doc()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>gw",
                ":ruby Gorilla.go_word(Gorilla.namespace_of($curbuf), Gorilla::Cmd.expand('<cword>'))<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>gi",
                ":ruby Gorilla.go_word()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>sw",
                ":ruby Gorilla.show_word(Gorilla.namespace_of($curbuf), Gorilla::Cmd.expand('<cword>'))<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>si",
                ":ruby Gorilla.show_word()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>jw",
                ":ruby Gorilla.javadoc_word(Gorilla.namespace_of($curbuf), Gorilla::Cmd.expand('<cword>'))<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>ji",
                ":ruby Gorilla.javadoc_word()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>et",
                ":ruby Gorilla.send_sexp(true)<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>es",
                ":ruby Gorilla.send_sexp(false)<CR>")
        Cmd.map("v", false, "<buffer> <silent>", "<LocalLeader>eb",
                ":ruby Gorilla.send_block()<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>ef",
                ":ruby Gorilla.send_file()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>rf",
                ":ruby Gorilla.require_file()<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>me",
                ":ruby Gorilla.expand_macro(true)<CR>")
        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>m1",
                ":ruby Gorilla.expand_macro(false)<CR>")

        Cmd.map("n", false, "<buffer> <silent>", "<LocalLeader>sr",
                ":ruby Gorilla::Repl.start()<CR>")
    end

    def Gorilla.with_saved_register(reg, &block)
        s = Cmd.getreg(reg)
        begin
            r = yield
        ensure
            Cmd.setreg(reg, s)
        end
        return r
    end

    def Gorilla.with_saved_position(&block)
        s = Cmd.getpos(".")
        begin
            r = yield
        ensure
            Cmd.setpos(".", s)
        end
        return r
    end

    def Gorilla.yank(r, how)
        Gorilla.with_saved_register(r) do
            VIM.command(how)
            Cmd.getreg(r)
        end
    end

    def Gorilla.connect()
        return Net::Telnet.new("Host" => "127.0.0.1", "Port" => 10123,
                               "Telnetmode" => false, "Prompt" => PROMPT_C)
    end

    def Gorilla.namespace_of(buf)
        len = buf.length
        i = 1
        while i < len
            if buf[i] =~ /^\((clojure\.core\/)?(in-)?ns\s+'?([a-z][a-z0-9._-]*)/
                return $3
            end
            i += 1
        end

        return "user"
    end

    def Gorilla.with_connection(&block)
        result = nil
        t = Gorilla.connect()
        begin
            result = yield(t)
        ensure
            t.close
        end
        return result
    end

    def Gorilla.one_command_in_ns(ns, cmd)
        Gorilla.with_connection() do |t|
            t.waitfor(PROMPT_C)
            Gorilla.command(t, "(clojure.core/in-ns '" + ns + ")")
            Gorilla.command(t, cmd)
        end
    end

    def Gorilla.one_command(cmd)
        return Gorilla.one_command_in_ns("user", cmd)
    end

    def Gorilla.command(t, cmd)
        result = t.cmd(cmd + " " + 0x00.chr)
        return result.sub(/^Gorilla=> /, "")
    end

    def Gorilla.print_in_buffer(buf, msg)
        msg.split(/\n/, -1).each { |l| buf.append(buf.length, l) }
    end

    def Gorilla.show_result(res)
        Cmd.new()
        Cmd.set_local("buftype=nofile")
        Cmd.set_local("bufhidden=delete")
        Cmd.set_local("noswapfile")
        Cmd.map("n", true, "<buffer> <silent>", "q", ":bd<CR>")
        Gorilla.print_in_buffer($curbuf, res)
        Cmd.normal("ggdd")
        Cmd.resize([$curbuf.length, 3].max)
    end

    def Gorilla.omni_complete(base)
        klass, stem = base.split(/\//)
        stem = stem.nil? ? "" : stem
        ns = Gorilla.namespace_of($curbuf)
        cmd = "(de.kotka.gorilla/get-static-info #{klass})"
        completions = Gorilla.one_command_in_ns(ns, cmd).split(/\n/)
        completions.pop
        completions = completions.select { |c| !c.nil? && c =~ /^#{stem}/ }
        completions = completions.map { |c| "{ 'word': '#{klass + "/" + c}', 'abbr': '#{c}' }" }
        return "[" + completions.join(",") + "]"
    end

    def Gorilla.word_or_input(args)
        ns, word = args

        word = word.nil? ? ns : word
        word = word.nil? ? Cmd.input("Symbol? ") : word

        if word =~ /\// then
            ns, word = word.split(/\//)
        end
        ns = (ns.nil? or ns == word) ? "user" : ns

        return [ns, word]
    end

    def Gorilla.lookup_word(*args)
        ns, word = Gorilla.word_or_input(args)
        Gorilla.show_result(Gorilla.lookup_doc_in_ns(ns, word))
    end

    DOCS = {}

    def Gorilla.lookup_doc_in_ns(ns, word)
        pair = [ns, word]

        return DOCS[pair] if DOCS.has_key?(pair)

        ds = Gorilla.one_command_in_ns(pair[0], "(clojure.core/doc " + pair[1] + ")")
        DOCS[pair] = ds

        return ds
    end

    def Gorilla.find_doc()
        ns = Gorilla.namespace_of($curbuf)
        pattern = Cmd.input("Pattern to look up? ")

        Gorilla.show_result(Gorilla.one_command_in_ns(ns,
                        "(clojure.core/find-doc \"#{pattern}\")"))
    end

    def Gorilla.extract_sexp(toplevel)
        flags = toplevel ? 'bWr' : 'bW'
        sexp = ""
        Gorilla.with_saved_position() do
            if VIM.evaluate("searchpairpos('(', '', ')', '#{flags}', 'GorillaSynItem() !~ \"clojureParen\\\\d\"') != [0, 0]") then
                sexp = Gorilla.yank('l', 'normal "ly%')
            end
        end
        return sexp
    end

    def Gorilla.send_sexp(toplevel)
        sexp = Gorilla.extract_sexp(toplevel)
        return if sexp == ""

        ns = Gorilla.namespace_of($curbuf)
        Gorilla.show_result(Gorilla.one_command_in_ns(ns, sexp))
    end

    def Gorilla.send_block()
        txt = Gorilla.yank("l", "'<,'>yank l")
        return if txt == ""
        Gorilla.show_result(Gorilla.one_command_in_ns(Gorilla.namespace_of($curbuf), txt))
    end

    def Gorilla.send_file()
        txt = Gorilla.yank("l", "normal ggVG\"ly")
        return if txt == ""
        Gorilla.show_result(Gorilla.one_command(txt))
    end

    def Gorilla.expand_macro(total)
        level = total ? "" : "-1"
        sexp = Gorilla.extract_sexp(false)
        return if sexp == ""

        ns = Gorilla.namespace_of($curbuf)
        sexp = "(macroexpand#{level} '#{sexp})"
        Gorilla.show_result(Gorilla.one_command_in_ns(ns, sexp))
    end

    def Gorilla.go_word(*args)
        ns, word = Gorilla.word_or_input(args)

        sexp = "(de.kotka.gorilla/go-word-position (clojure.core/resolve '#{word}))"
        file, line = Gorilla.one_command_in_ns(ns, sexp).chomp.split(/ /)

        file = VIM.evaluate("findfile('#{file}')")
        if file != "" then
            VIM.command("edit +#{line} #{file}")
        end
    end

    def Gorilla.show_word(*args)
        ns, word = Gorilla.word_or_input(args)

        cmd = "(de.kotka.gorilla/show #{word})"
        Gorilla.show_result(Gorilla.one_command_in_ns(ns, cmd))
    end

    def Gorilla.javadoc_word(*args)
        ns, word = Gorilla.word_or_input(args)

        cmd = "(de.kotka.gorilla/get-javadoc-path #{word})"
        path = Gorilla.one_command_in_ns(ns, cmd)

        url = VIM.evaluate("g:GorillaJavadocPath") + path

        browser = VIM.evaluate("g:GorillaBrowser")
        system(browser + " " + url.chomp)
    end

    def Gorilla.check_completeness(text)
        cmd = "(de.kotka.gorilla/check-completeness \"#{text}\")"
        Gorilla.show_result(Gorilla.one_command(cmd))
    end

    def Gorilla.require_file()
        ns = Gorilla.namespace_of($curbuf)
        return if ns == "user"
        cmd = "(clojure.core/require :reload '#{ns})"
        Gorilla.show_result(Gorilla.one_command(cmd))
    end

    class Repl
        @@id = 1
        @@repls = {}

        def Repl.by_id(id)
            return @@repls[id]
        end

        def Repl.start()
            Cmd.new()
            Cmd.set_local("buftype=nofile")
            Cmd.setfiletype("clojure")

            id = Repl.new($curbuf).id

            Cmd.map("i", false, "<buffer> <silent>", "<CR>",
                    "<Esc>:ruby Gorilla::Repl.by_id(#{id}).enter_hook()<CR>")
            Cmd.map("i", false, "<buffer> <silent>", "<C-Up>",
                    "<C-O>:ruby Gorilla::Repl.by_id(#{id}).up_history()<CR>")
            Cmd.map("i", false, "<buffer> <silent>", "<C-Down>",
                    "<C-O>:ruby Gorilla::Repl.by_id(#{id}).down_history()<CR>")
        end

        def initialize(buf)
            @history = []
            @history_depth = []
            @buf = buf
            @conn = Gorilla.connect()
            @id = @@id

            @@id = @@id.next
            @@repls[id] = self

            @conn.waitfor(PROMPT_C)

            Gorilla.print_in_buffer(@buf, "Clojure\nGorilla=> ")

            Cmd.normal("G$")
            VIM.command("startinsert!")
        end
        attr :id

        def print_stacktrace()
            stacktrace = Gorilla.command(@conn, "(.printStackTrace *e *err*)")
            Gorilla.show_result(stacktrace)
            delete_last()
            Gorilla.print_in_buffer(@buf, PROMPT + " ")
        end

        def repl_command(cmd)
            case cmd.chomp
            when ",close" then close()
            when ",st" then print_stacktrace()
            else return false
            end
            return true
        end

        def get_command()
            l = @buf.length
            cmd = @buf[l]
            while cmd !~ PROMPT_B
                l -= 1
                cmd = @buf[l] + "\n" + cmd
            end
            return cmd.sub(PROMPT_B, "")
        end

        def enter_hook()
            delim = nil
            pos = nil

            cmd = get_command()

            return if repl_command(cmd)

            cmde = cmd.gsub(/\\/, "\\\\").gsub(/"/, "\\\"")
            cmde = "(de.kotka.gorilla/check-completeness \"" + cmde + "\")"
            if Gorilla.one_command(cmde).chomp == "true" then
                send(cmd)
            else
                # This is a hack to enter a new line and get indenting...
                @buf.append(@buf.length, "")
                Cmd.normal("G")
                Cmd.normal("ix")
                Cmd.normal("==x")
                VIM.command("startinsert!")
            end
        end

        def send(cmd)
            @history_depth = 0
            @history.unshift(cmd)

            result = Gorilla.command(@conn, cmd).split(/\n/)

            while result.length > 0
                l = result.shift
                Gorilla.print_in_buffer(@buf, l)
            end

            Gorilla.print_in_buffer(@buf, PROMPT + " ")
            Cmd.normal("G")
            VIM.command("startinsert!")
        end

        def delete_last()
            Cmd.normal("gg")
            n = @buf.length
            while @buf[n] !~ PROMPT_B
                @buf.delete(n)
                n -= 1
            end
            @buf.delete(n)
        end

        def up_history()
            if @history.length > 0 && @history_depth < @history.length
                cmd = @history[@history_depth]
                @history_depth += 1

                delete_last()
                Gorilla.print_in_buffer(@buf, PROMPT + " " + cmd)
            end
            Cmd.normal("G$")
        end

        def down_history()
            if @history_depth > 0 && @history.length > 0
                @history_depth -= 1
                cmd = @history[@history_depth]

                delete_last()
                Gorilla.print_in_buffer(@buf, PROMPT + " " + cmd)
            elsif @history_depth == 0
                delete_last()
                Gorilla.print_in_buffer(@buf, PROMPT + " ")
            end
            Cmd.normal("G$")
        end

        def close()
            @conn.close
            @@repls[@id] = nil
            Cmd.bdelete()
            VIM.command("stopinsert")
        end
    end
end
EOF

" Epilog
let &cpo = s:save_cpo
