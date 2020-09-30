

class String

	def colorize( color_code, weight=0 )
		if weight > 0
			return "\e[#{color_code}m\e[#{weight}m#{self}\e[0m"
		else
			return "\e[#{color_code}m#{self}\e[0m"
		end
	end

	def white; colorize( 1, 0 ) end
	def white_bold; colorize( 1, 1 ) end

	def black; colorize( 30, 0 ) end
	def black_bold; colorize( 30, 1 ) end
    def black_bg_white; colorize(7,1) end

	def red; colorize( 31, 0 ) end
	def red_bold; colorize( 31, 1 ) end

	def green; colorize( 32, 0 ) end
	def green_bold; colorize( 32, 1 ) end

	def brown; colorize( 33, 0 ) end
	def brown_bold; colorize( 33, 1 ) end

	def blue; colorize( 34, 0 ) end
	def blue_bold; colorize( 34, 1 ) end

	def magenta; colorize( 35, 0 ) end
	def magenta_bold; colorize( 35, 1 ) end

	def cyan; colorize( 36, 0 ) end
	def cyan_bold; colorize( 36, 1 ) end

	def gray; colorize( 37, 0 ) end
	def gray_bold; colorize( 37, 1 ) end

    def white_bg_white; colorize( 40, 0 ) end
    def white_bg_white_bold; colorize( 40, 1 ) end
    def white_bg_red; colorize( 41, 0 ) end
    def white_bg_red_bold; colorize( 41, 1 ) end
    def white_bg_green; colorize( 42, 0 ) end
    def white_bg_green_bold; colorize( 42, 1 ) end
    def white_bg_brown; colorize( 43, 0 ) end
    def white_bg_brown_bold; colorize( 43, 1 ) end
    def white_bg_blue; colorize( 44, 0 ) end
    def white_bg_blue_bold; colorize( 44, 1 ) end

end


def show_color_table()
	def color(index)
	  normal 	= "\e[#{index}m#{index}\e[0m"
	  bold 		= "\e[#{index}m\e[1m#{index}\e[0m"
	  "#{normal}  #{bold}  "
	end

	8.times do|index|
	  line = color(index + 1)
	  line += color(index + 30)
	  line += color(index + 90)
	  line += color(index + 40)
	  line += color(index + 100)
	  puts line
	end
end
