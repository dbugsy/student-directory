TIOCGWINSZ = 0x40087468
def valid_months(input_symbol)
	months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
	months.include?(input_symbol)
end

def get_winsize
  str = [0, 0, 0, 0].pack('SSSS')
  if STDIN.ioctl(TIOCGWINSZ, str) >= 0
    rows, cols, xpixels, ypixels = str.unpack("SSSS")
    #rows, cols, xpixels, ypixels
    cols
  else
    puts "Unable to get window size"
  end
end

# amend input_students - break it into smaller methods, and allow input of cohort
def append_fields(hash)
	enterNewField = true
	while enterNewField
		print "Do you want to add another field to #{hash[:Name]}'s information? (y/n)\n"
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

def cleanup(string)
	string.strip!
	string.capitalize!
	string
end

def get_info
	x = gets.chomp.split(":").map{|field| cleanup(field)}
	x
end

def input_students
	months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
	print "Please enter the name and cohort of the students\nUse the format: Name : Cohort. Cohort defaults to March.\n"
	print "To finish, just hit return twice\n"
	# create an empty array
	students = []
	# get first name
	name_and_cohort = get_info
	# while the name is not empty repeat this code
	while !name_and_cohort.empty? do
		# add the student hash to the array
		name_and_cohort << "March" if name_and_cohort[1].nil?
		#if !months.include?(name_and_cohort[1].to_sym)
		if !valid_months(name_and_cohort[1].to_sym)
			puts "Unrecognised cohort (should be a month)."
			print "Now we have #{students.length} students\nPlease enter the name of the next student\n"
			name_and_cohort = get_info
			next
		end
		students << {:Name => name_and_cohort[0], :Cohort => name_and_cohort[1].to_sym}
		append_fields(students[-1])
		
		print "Now we have #{students.length} students\nPlease enter the name of the next student\n"
		name_and_cohort = get_info
	end
	#return the array of students
	students
end

def print_header()
	puts "The students of my cohort at Makers Academy".center(get_winsize)
	puts "-----------".center(get_winsize)
end

def print_hash(hash)
	hash.each do |key, value|
		print "#{key} : #{value}\t"
	end
	print "\n"
end

def hash_to_string(hash)
	string=""
	hash.each do |key, value|
		string << "#{key} : #{value}  "
	end
	string
end	

def print_validation(hash)
	hash[:Name].split('')[0] == "A" && hash[:Name].length<12
end


def print_list(list)
	max_index = list.length-1;
	i=0

	while i<=max_index
		if print_validation(list[i])
			centered_string =  "#{i+1}. #{hash_to_string(list[i])}"
			puts centered_string.center(get_winsize)
		end 
		i +=1

	end
end


def print_footer(list)
	puts "Overall, we have #{list.count} students.".center(get_winsize)
end

def extract_from(students, cohort_sym)
	results = students.select do |student|
		student[:Cohort]==cohort_sym
	end
	results
end

students = input_students
print "Which cohort would you like to filter by?\n> "
cohort_sym= (cleanup(gets.chomp)).to_sym

print_header
#get cohort choice
chosen_students = extract_from(students,cohort_sym)
print_list(chosen_students)
print_footer(students)