students = File.open('./students.csv')

def create_arr_strings(csv)
	arr_of_strings = csv.read.split("\r")
	puts "Here is the array of strings:"
	puts arr_of_strings.inspect
	arr_of_strings
end

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
	puts "Here is the array of arrays:"
	puts arr_of_arr.inspect
	arr_of_arr
end

def create_arr_hashes(arr_arrays)
	hash_keys = arr_arrays.shift
	puts "Here are the hash keys: "
	puts hash_keys.inspect
	puts "Here are the values: "
	puts arr_arrays.inspect
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
	puts "Here is the array of hashes: "
	puts arr_hashes.inspect
	arr_hashes
end

arrayofstrings = create_arr_strings(students)
arrayofarrays = create_arr_arrays(arrayofstrings)
create_arr_hashes(arrayofarrays)