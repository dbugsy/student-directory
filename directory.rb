TIOCGWINSZ = 0x40087468
student_csv = File.open('./students.csv')

# boolean: is the value plural?
def is_plural?(value)
	(value > 1) || (value < 1)
end

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
	arr_strings.map do |row| 
		row.split(",").map { |word| word.strip }
		end
end

# This creates an array of hashes - each hash contains info for 1 student
def create_arr_hashes(arr_arrays)
	hash_keys = arr_arrays.shift.map { |key| key.to_sym  }
	arr_index = 0
	arr_hashes = []
	arr_arrays.each do |student|
			student_hash = {}
			student.each do |value|
				student_hash[hash_keys[arr_index]] = value
				arr_index += 1
				end
			student_hash[:cohort] = :March
			arr_hashes << student_hash
			arr_index = 0
			end
	arr_hashes
end

# welcome!
def prog_start
	
end

# collect name of student and return it to the program
def collect_name
	puts "Please enter full name of the student you wish to add / amend."
	print "Alternatively press enter to exit and print results.\n > "
	name = gets.chomp.split.map(&:capitalize).join(' ').strip
	name
end

# check file for student name
def name_exists?(stdname, arr_of_hashes)
	!arr_of_hashes.select { |hash| hash[:name] == stdname }.empty?
end

def collect_email(name)
	new_std_hash = {name: name}
	print "Please enter #{name}'s email address\n > "
	new_std_hash[:email] = gets.chomp.strip.downcase
	new_std_hash
end

def collect_skype(std_hash, name)
	print "Please enter #{name}'s skype name\n > "
	std_hash[:skype] = gets.chomp.strip
	std_hash
end

# This methods defines allowable input for cohort
def valid_cohort?(input_symbol)
	months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
	months.include?(input_symbol)
end

def collect_cohort(std_hash, name)
	print "Please enter #{name}'s cohort\n > "
	input = gets.chomp.strip.downcase.capitalize.to_sym
	if !input.empty?
		while !valid_cohort?(input)
			puts 'Not a valid cohort (should be a month). Please try again.'
			print "Please enter #{name}'s cohort\n > "
			input = gets.chomp.strip.downcase.capitalize.to_sym
		end
		std_hash[:cohort] = input
	else
		std_hash[:cohort] = :March
	end
	std_hash
end

def give_options
	print "Options are: email ; skype ; cohort ; or press enter to complete this entry.\n"
	print "Which field would you like to amend?\n > "
end

def make_amends(students, stdname, hash)
	students << hash
	print "#{stdname} updated.\n"
	give_options
	students
end

# prints number of students currently entered into the program
def print_current_students(students)
	str = "Currently we have #{students.length} student#{'s' if is_plural?(students.length)}\n"
	print str
end

def collect_amends(students, name)
	give_options
	# THIS MIGHT NOT WORK!
	field = gets.chomp.strip.downcase
	while !field.empty? do
		case field
		when 'cohort'
			student = students.select { |hash| hash[:name] == name }[0]
			students.delete_if { |hash| hash[:name] == name }
			students = make_amends(students, name, collect_cohort(student, name))
			field = gets.chomp.strip.downcase
		when 'skype'
			student = students.select { |hash| hash[:name] == name }[0]
			students.delete_if { |hash| hash[:name] == name }
			students = make_amends(students, name, collect_skype(student, name))
			field = gets.chomp.strip.downcase
		when 'email'
			student = students.select { |hash| hash[:name] == name }[0]
			students.delete_if { |hash| hash[:name] == name }
			students = make_amends(students, name, collect_email(name))
			field = gets.chomp.strip.downcase
		else
			puts 'Error: please enter valid option.'
			give_options
			field = gets.chomp.strip.downcase
		end
	end
	puts 'Entry completed'
	students
end

def collect_input(students)
	student_name = collect_name
	while !student_name.empty? do
		if !name_exists?(student_name, students)
			students << collect_cohort(collect_skype(collect_email(student_name), student_name), student_name)
			print_current_students(students)
			student_name = collect_name
		else name_exists?(student_name, students)
			puts "#{student_name} already exists:"
			print "#{students.select{|hash| hash[:name] == student_name}[0].to_s}"
			print "\nAmend? (y/n)\n > "
			amend = gets.chomp.strip.downcase
			if amend == 'y'
				students = collect_amends(students, student_name)
				print_current_students(students)
				student_name = collect_name
			elsif amend == 'n'
				puts 'Entry cancelled'
				print_current_students(students)
				student_name = collect_name
			end
		end
	end
	puts 'Entry completed.'
	students
end

# the header will display at the top of the final results
def print_header(cohort_sym)
	puts "The students of #{cohort_sym.to_s} cohort at Makers Academy".center(get_winsize)
	puts "-----------".center(get_winsize)
end

# changes the hash to string for easier formatting
def hash_to_string(hash)
	string=""
	hash.each do |key, value|
		string << "#{key} : #{value}  "
	end
	string
end	

# prints the entire student array, indexed for readability
def print_list(list)
	max_index = list.length;
	i=1
	while i<=max_index
	print "#{i}. #{hash_to_string(list[i-1])}".center(get_winsize)
	print "\n"
	i +=1
	end
end

# selects only the students from the cohort the user wants to print
def extract_from(students, cohort_sym)
	if !cohort_sym == :Nofilter
		results = students.select do |student|
			student[:cohort] == cohort_sym
			end
	else 
		results = students
	end
	results
end

def write_all_CSV(students)
	print "Would you like to save this to the CSV (y/n)?\nWARNING! This will overwrite original file!!"
	input = gets.strip.downcase
	if input[0] == "y"
		csv = File.open('./edited_students.csv', 'w')
		tempstring = ""
		students[0].to_a.map {|arr| tempstring << arr[0].to_s
								tempstring << ", "
								}
		newcsv = tempstring[0..-3]
		newcsv << "\r"
		students.map do |hash|
			string = ""
			hash.map { |arr| string << arr[1].to_s
						string << ", "}
			newcsv << string[0..-3]
			newcsv << "\r"
			end
		csv.write(newcsv)
	end
end

def compile_results(students)
	print "\n\nCompiling results...\n\n"
	print_list(extract_from(students, :Nofilter))
	write_all_CSV(students)
	print "Which cohort would you like to filter by (press enter for no filter)?\n> "
	input = gets.chomp.strip.downcase.capitalize.to_sym
	if !input.empty?
		while !valid_cohort?(input) do
		print "Not a valid cohort (should be a month). Please try again.\n >" 
		input = gets.chomp.strip.downcase.capitalize.to_sym
		end
		cohort_sym = input
		print_header(cohort_sym)
		print_list(extract_from(students, cohort_sym))
		puts "Showing #{extract_from(students, cohort_sym).count} student#{'s' if is_plural?(extract_from(students, cohort_sym).count)}."
		puts "A total of #{students.count} student#{'s' if is_plural?(students.count)} were entered."
		write_all_CSV(extract_from(students, cohort_sym))
	else
		cohort_sym = :Nofilter
	end
	print "\n"
	print " Thank you for using Student Directory ".center(get_winsize)
	print " ---------- Goodbye! ---------- ".center(get_winsize)
	print "\n"
end



# begin by creating student directory 'students'

students = create_arr_hashes(create_arr_arrays(create_arr_strs(student_csv)))

puts "\e[H\e[2J"

print "\n\n"
print " WELCOME TO STUDENT DIRECTORY! ".center(get_winsize, '*')
print "\n\n"
print "-------- Current Students --------".center(get_winsize)
print "\n\n"
print_list(students)
print "\n"
print "----------------------------------".center(get_winsize)
print "\n\n"

compile_results(collect_input(students))




