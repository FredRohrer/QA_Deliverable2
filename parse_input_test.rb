require 'minitest/autorun'
begin
require_relative 'city_sim_9006.rb'
rescue RuntimeError => e # catch the error this include throws 
end


# Unit test 1 for the method parse_input


class ParseTest < Minitest::Test

	# UNIT TESTS FOR METHOD parse_input(a)
	# Equivalence classes:
	# a has more then 1 element -> return nil
	# a has no elements -> raise the exception "Enter a seed and only a seed"
	# a[0] is a string which can be parsed into an int -> return that int
	# a[0] is a string which can't be parsed into an int -> return 0
	
	
	
	# If a is bigger then 1 raise an exception
	def test_too_big
		a = [1, 2]
		assert_raises "Enter a seed and only a seed" do
			parse_input(a)
		end 
	end
	
	# if a is empty then raise an exception 
	def test_empty
		a = []
		assert_raises "Enter a seed and only a seed" do
			parse_input(a)
		end 
	end
	
	# if a non string is passed in at a[0] then return 0
	# EDGE CASE
	def test_not_int
		a = ["foobar"]
		assert_equal 0, parse_input(a)
	end
	
	# if an int is passed then return that int
	def test_int
		a = ['123456']
		assert_equal 123456, parse_input(a)
	end
	
end