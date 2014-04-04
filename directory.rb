TIOCGWINSZ = 0x40087468

# This method is purely a learning exercise to try to replace .chomp method
def new_chomp(string)
	string.gsub!("\n", "")
end

# This methods defines allowable input for cohort
def valid_months(input_symbol)
	months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
	months.include?(input_symbol)
end

# Check whether student list has any contents
def has_student?(student_list)
	!student_list.empty?
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

# method to collect multiple entries from user, until another_field != Y
def collect_more_fields(hash)
	enterNewField = true
	while enterNewField
		print "Do you want to add another field to #{hash[:Name]}'s information? (y/n)\n"
		print " > "
		another_field = gets.chomp.to_s.upcase
		if another_field == "Y"
			print "What is the name of the field?\n"
			new_field = gets.chomp
			print "What is the value?\n"
			new_val = gets.chomp
			hash[new_field.to_sym]=new_val
		else
			enterNewField = false
		end
	end
end

# cleanup a string to remove whitespace and capitalize
def cleanup(string)
	string.strip!
	string.capitalize!
	string
end

# standard method to collect input from user
def get_info
	x = new_chomp(gets)
	x.split(":").map{|field| cleanup(field)}
end

# boolean: is the value plural?
def is_plural?(value)
	value > 1
end

# prints number of students currently entered into the program
def print_current_students(students)
	str = "Currently we have #{students.length} student#{'s' if is_plural?(students.length)}\nPlease enter the name of the next student\n"
	print str
end

# welcome!
def prog_start
	print "\n\n"
	print " WELCOME TO STUDENT DIRECTORY! ".center(get_winsize, '*')
	print "\n\n"
end

# collect the name and cohort of a student
def collect_name_cohort
	
	print "Please enter the name and cohort of the students"
	print "\nUse the format: Name : Cohort. Cohort defaults to March.\n"
	print "To finish, just hit return twice, or Ctrl-C to exit without saving\n"
	print " > "
	# create an empty array
	students = []
	# get first name
	name_and_cohort = get_info
	# while the name is not empty repeat this code
	while !name_and_cohort.empty? do
		# add the student hash to the array
		name_and_cohort << "March" if name_and_cohort[1].nil?
		#check if entered cohort is valid, and if not start again.
		if !valid_months(name_and_cohort[1].to_sym)
			puts "Unrecognised cohort (should be a month)."
			print_current_students(students)
			name_and_cohort = get_info
			next
		end
		# creates the hash and adds it to array students
		students << {:Name => name_and_cohort[0], :Cohort => name_and_cohort[1].to_sym}
		# now pass to collect_more_fields to see what else user would like to enter
		collect_more_fields(students[-1])
		# show user how many students are currently entered
		print_current_students(students)
		# ask for the next student
		name_and_cohort = get_info
	end
	# return to start if no students entered, also remind user how to exit
	if !has_student?(students)
		puts " No students! Starting again! ".center(get_winsize, "*")
		puts "------ Press Ctrl-C to exit ------".center(get_winsize)
		prints "\n\n"
	end
	#return the array of students
	students
end

# the header will display at the top of the final results
def print_header()
	puts "The students of #{cohort_sym.to_s} cohort at Makers Academy".center(get_winsize)
	puts "-----------".center(get_winsize)
end

# this prints individual students hash, in a readable format.
def print_hash(hash)
	hash.each do |key, value|
		print "#{key} : #{value}\t"
	end
	print "\n"
end

# changes the hash to string for easier formatting
def hash_to_string(hash)
	string=""
	hash.each do |key, value|
		string << "#{key} : #{value}  "
	end
	string
end	

# this is where we have the rules specified in the exercises
# specifically, in order to print, the student name must start with A
# and should be less than 11 characters long
def print_validation(hash)
	hash[:Name].split('')[0] == "A" && hash[:Name].length<12
end

# prints the entire student array, indexed for readability
def print_list(list)
	max_index = list.length-1;
	i=0

	while i<=max_index
		# checks if student passes the rules in print_validation
		if print_validation(list[i])
			centered_string =  "#{i+1}. #{hash_to_string(list[i])}"
			puts centered_string.center(get_winsize)
		end 
		i +=1

	end
end

# selects only the students from the cohort the user wants to print
def extract_from(students, cohort_sym)
	results = students.select do |student|
		student[:Cohort]==cohort_sym
	end
	results
end

# creates empty student array
students =[]

# STARTING EXECUTABLE CODE HERE
prog_start

while !has_student?(students)
	students = collect_name_cohort
end

#get cohort choice
print "Which cohort would you like to filter by?\n> "
cohort_sym = (cleanup(gets.chomp)).to_sym
puts "The students of #{cohort_sym.to_s} cohort at Makers Academy".center(get_winsize)
puts "-----------".center(get_winsize)
print_header
chosen_students = extract_from(students,cohort_sym)
print_list(chosen_students)
puts "Showing #{chosen_students.count} student#{'s' if is_plural?(chosen_students.count)}."
"A total of #{students.count} were entered.".center(get_winsize)

