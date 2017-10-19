#!/bin/ruby

MAX_LINE=20
WIDTH=78

# credits to Ruby Cookbook for this function
def wrap(s, width=WIDTH)
	s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end

def getTag(name, section="1", tag="DESCRIPTION")

	ret=""
	found=false
	printed=0

	original_stderr = STDERR.clone
	STDERR.reopen(File.new('/dev/null', 'w'))

	"#{ `man #{section} #{name}` }".each_line { |line|

		if !line[/^#{tag}/] && !found
			next
		elsif !found
			found=true
			next
		end

		break if printed >= MAX_LINE || line[/^[[:space:]]*-.*/] || line[/^[A-Z]/]
		line.gsub!(/^[[:space:]]+/, "")
		line.gsub!(/[[:space:]]+/, " ")
		printed+=1
		ret+=line
	}

	STDERR.reopen(original_stderr)
	return ret == "" ? nil : ret;

end

# example: ./manparser.rb ls 1 DESCRIPTION
puts wrap("#{ getTag(ARGV[0], ARGV[1], ARGV[2]) }")
