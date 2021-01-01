# NB: gnu readline is vegetable on windows
#     wait for a god-made cross-platform pty.rb
#     or i just write it by myself someday
#     (maybe refer to julia's implementation using libev)
require "readline"

Readline.completion_append_character = " "
Readline.completion_proc = proc { |str|
  binaries = ENV['PATH'].split(?;).flat_map { |path|
    path = path.tr('\\', ?/)
    ENV['PATHEXT'].split(?;).flat_map { |ext|
      Dir[File.join(path, "#{str}*#{ext.downcase}")].map { |full_path|
        File.basename(full_path, '.*')
      }
    }
  }
  files = Dir[str+'*'].grep(/^#{Regexp.escape(str)}/)
  binaries + files
}

def which str
  ENV['PATH'].split(?;).each { |path|
    path = path.tr('\\', ?/)
    ENV['PATHEXT'].split(?;).each { |ext|
      file = File.join(path, "#{str}#{ext.downcase}")
      return file if File.exist? file
    }
  }
  return nil
end

RUSH_BINDING = TOPLEVEL_BINDING.dup
BUILTIN = ['alias']
ALIAS_MAP = {}

loop do
  buf = Readline.readline("> ", true)
  break if buf.nil? or buf == 'exit'

  run_it = -> {
    first, rest = buf.split(?\s, 2)
    if which first
      buf.gsub!(/`\w+`?/) { |e| eval e[/\w+/], RUSH_BINDING }
      system buf
    else
      pp eval buf, RUSH_BINDING
    end
  }

  first, rest = buf.split(?\s, 2)
  if BUILTIN.include? first
    a, b = rest.split(?=, 2)
    ALIAS_MAP[a] = b.undump rescue b
  else
    if ALIAS_MAP.key? first
      first = ALIAS_MAP[first]
    end
    buf = [first, rest].join ?\s
    run_it.()
  end
rescue Interrupt
  puts '^C'
rescue SystemExit
  break
rescue Exception => e
  puts "#{e.class}: #{e}"
end
