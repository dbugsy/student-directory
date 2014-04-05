TIOCGWINSZ = 0x40087468
student_csv = File.open('./students.csv')

# get properties of current terminal window
def get_winsize
  str = [0, 0, 0, 0].pack('SSSS')
  if STDIN.ioctl(TIOCGWINSZ, str) >= 0
    rows, cols, xpixels, ypixels = str.unpack("SSSS")
    #rows, cols, xpixels, ypixels
    cols
  end
end

#This creates an array of strings from the csv
def create_arr_strs(csv)
	arr_of_strings = csv.read.split("\r")
	arr_of_strings
end

# This creates an array of arrays from an array of strings
def create_arr_arrays(arr_strings)
	arr_of_arr = []
	arr_strings.each do |row| 
		raw_arr = row.split(",")
		clean_arr = []
		raw_arr.each do |string| 
			clean_str = string.strip
			clean_arr << clean_str
			end
		arr_of_arr << clean_arr
		end
	arr_of_arr
end

# This creates an array of hashes - each hash contains info for 1 student
def create_arr_hashes(arr_arrays)
	raw_hash_keys = arr_arrays.shift
	hash_keys = []
	raw_hash_keys.each { |key| hash_keys << key.to_sym  }
	arr_hashes = []
	arr_index = 0
	student_info = arr_arrays.each do |array|
			student_hash = {}
			hash_value = array.each do |value|
				student_hash[hash_keys[arr_index]] = value
				arr_index += 1
				end
			arr_hashes << student_hash
			arr_index = 0
			end
	arr_hashes
end

# welcome!
def prog_start
	print "\n\n"
	print " WELCOME TO STUDENT DIRECTORY! ".center(get_winsize, '*')
	print "\n\n"
end

# collect name of student and return it to the program
def collect_name
	puts "Please enter the name of the student you wish to add / amend."
	name = gets.chomp
	name
end

# check file for student name
def name_exists?(stdname, arr_of_hashes)
	names = []
	arr_of_hashes.each { |hash| names << hash[:name]}
	print names.inspect
	names.include?(stdname)
end

# begin by creating student directory 'students'

students = create_arr_hashes(create_arr_arrays(create_arr_strs(student_csv)))

prog_start
student_name = collect_name

name_exists?(student_name, students)