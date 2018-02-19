require 'minitest/autorun'
begin
require_relative 'city_sim_9006.rb'
rescue RuntimeError => e # catch the error this include throws
end 

class RunTest < Minitest::Test

	# UNIT TESTS FOR METHOD Run.initilize(r, id)
	# Equivalence classes: 
	# rand is a Random and id is an int ->
	# run.rand = r, run.id = id, run.books = 0, run.toys = 0, run.classes = 0,
	# run.loc is either 'Hospital', 'Cathedral', 'Hillman', or 'Museum' depending on the r variable
	# rand is not valid -> raises an exception 'rand is invalid'
	
	
	# If the inputs are correct then the local variables are correct (see above).
	# Everything is initialized to zero, later methods will alter books, toys and classes.
	def test_vars
		r = Random.new(1234)
		test_run = Run.new(r, 5)
		
		assert_equal r, test_run.rand
		assert_equal 5, test_run.id
		assert_includes ['Hospital', 'Cathedral', 'Hillman', 'Museum'], test_run.loc
		assert_equal 0, test_run.books
		assert_equal 0, test_run.toys
		assert_equal 0, test_run.classes
	end 
	
	# Testing if two runs are given the same rand that they start with the same loc.
	# This ensures repeatability for testing.
	def test_repeatable
		r1 = Random.new(42)
		r2 = Random.new(42)
		
		run1 = Run.new(r1, 1)
		run2 = Run.new(r2, 2)
		assert_equal run1.loc, run2.loc
	end 
	
	# Testing if an invalid Random is passed in for r. This shouldn't happen as 
	# Run is an internal class but just in case.
	# EDGE CASE
	def test_input_invalid 
		assert_raises "rand is invalid" do 
			test = Run.new("Foo", 42)
		end
	end
	
	# UNIT TESTS FOR METHOD Run.get_valid_paths(l)
	# Equivalence classes:
	# l = 'Hospital' -> returns [ ['Foo St.', 'Hillman'], ['Fourth Ave.', 'Cathedral'] ]
	# l = 'Cathedral' -> returns [ ['Fourth Ave.', 'Monroeville'], ['Bar St.', 'Museum'] ]
	# l = 'Museum' -> returns [ ['Bar St.', 'Cathedral'], ['Fifth Ave.', 'Hillman'] ]
	# l = 'Hillman' -> returns [ ['Fifth Ave.', 'Downtown'], ['Foo St.', 'Hospital'] ]
	# l = None of the above -> returns nil
	
	# If 'Hospital' is given for l, then the valid routes are returned.
	# From Hospital we can travel down Fourth Ave. to Cathedral or 
	# we can travel down Foo St. to Hillman
	def test_valid_paths_hos
		r = Random.new(5)
		test_run = Run.new(r, 5)	
		test_run.stub :loc, 'Hospital' do 
			test = [ ['Foo St.', 'Hillman'], ['Fourth Ave.', 'Cathedral'] ]
			assert_equal test_run.get_valid_paths, test
		end 
	end
	
	# If 'Cathedral' is given for l, then the valid routes are returned.
	# From Cathedral we can travel down Fourth Ave. to Monroeville or 
	# we can travel down Bar St. to Museum.
	def test_valid_paths_cath
		r = Random.new(5)
		test_run = Run.new(r, 5)
		test_run.stub :loc, 'Cathedral' do
			test = [ ['Fourth Ave.', 'Monroeville'], ['Bar St.', 'Museum'] ]
			assert_equal test_run.get_valid_paths, test
		end
	end
	
	# If 'Museum' is given for l, then the valid routes are returned
	# From Museum we can travel down Fifth Ave. to Hillman or 
	# we can travel up Bar St. to Cathedral
	def test_valid_paths_mus
		r = Random.new(5)
		test_run = Run.new(r, 5)
		test_run.stub :loc, 'Museum' do 
			test = [ ['Bar St.', 'Cathedral'], ['Fifth Ave.', 'Hillman'] ]
			assert_equal test_run.get_valid_paths, test
		end
	end
	
	# If 'Hillman' is given for l, then the valid routes are returned
	# From Hillman we can travel down Fifth Ave. to Downtown or 
	# we can travel up Foo St. to Hospital
	def test_valid_paths_hil
		r = Random.new(5)
		test_run = Run.new(r, 5)	
		test_run.stub :loc, 'Hillman' do 
			test = [ ['Fifth Ave.', 'Downtown'], ['Foo St.', 'Hospital'] ]
			assert_equal test_run.get_valid_paths, test
		end
	end 
	
	# If an invalid location is given for l, then nil is returned. Would only happen
	# if this method was called when we were at one of the end location.
	# EDGE CASE
	def test_valid_paths_invalid
		r = Random.new(5)
		test_run = Run.new(r, 5)	
		test_run.stub :loc, 'foobar' do
			assert_nil test_run.get_valid_paths
		end 
	end
	
	
	# RUN TEST FOR METHOD Run.step(l)
	# Equivalence classes: 
	# l = a valid location -> returns a valid location after printing its routes
	
	# Tests the output of steps with two stubs. One stub changes get_valid_paths to 
	# a dummy set of valid paths with only one path. The other stub replaces the loc
	# of this Run so it is a dummy location 
	def test_run_step
		test = Run.new(Random.new(5), 5)
		
		test.stub :get_valid_paths, [['True St.', 'Trueplace']] do
			test.stub :loc, 'foo' do # a stub within a stub 
				assert_output("Driver 5 heading from foo to Trueplace via True St.\n") {
					new_loc = test.step
					assert_equal 'Trueplace', new_loc
				}
			end 
		end 
	end
	
	
	# UNIT TEST FOR METHOD Run.count_stuff
	# Equivalence classes:
	# self.loc = 'Hillman' -> @books is incremented by 1 and 'Hillman'
	# self.loc = 'Museum' -> @toys is incremented by 1
	# self.loc = 'Cathedral' and @classes = 0 -> @classes = 1
	# self.loc = anything else -> nothing happens
	
	# Testing that books is incremented by 1 when count_stuff is called and loc = 'Hillman'
	# self.loc is overwritten with a stub to be 'Hillman'
	def test_books_inc
		test = Run.new(Random.new(2131), 2)
		test.stub :loc, 'Hillman' do 
			(0..5).each { |x|
				assert_equal x, test.books
				test.count_stuff
			}
		end 
		
	end 
	
	# Testing that toys is incremented by 1 when count_stuff is called and loc = 'Museum'
	# self.loc is overwritten with a stub to be 'Museum'
	def test_toys_inc
		test = Run.new(Random.new(1123), 2)
		test.stub :loc, 'Museum' do 
			(0..5).each { |x|
				assert_equal x, test.toys
				test.count_stuff
			}
		end 
	end 
	
	# Testing that when count_stuff is called and loc = Cathedral that when count_stuff is called
	# classes becomes 1. self.loc is overwritten with a stub to be 'Cathedral'
	# EDGE CASE
	def test_classes_zero 
		test = Run.new(Random.new(1), 2)
		test.stub :loc, 'Cathedral' do 
			assert_equal 0, test.classes
			test.count_stuff
			assert_equal 1, test.classes
		end 
	end 
	
	# Testing that when classes is not zero and loc = Cathedral
	# that classes is doubled each call. Uses a small helper method
	# to set classes to 1 so as to not overlap with the above test.
	# Stubs self.loc to set it to Cathedral
	def test_classes_not_zero
		test = Run.new(Random.new(1), 2)
		test.classes_1 # call a small method to not rely on the test above working
		test.stub :loc, 'Cathedral' do 
			[1, 2, 4, 8, 16].each { |x|					
				assert_equal x, test.classes
				test.count_stuff
			}
		end 
		
	end 
	
	
	# UNIT TESTS FOR METHOD end_print
	# Equivalence classes:
	# SUCCESS CASES: 3 lines are printed out and the Driver number is correct 
	# and the couresponding noun is properly plural or singular
	# FAILURE CASES: The id is wrong or the singluar or plural is wrong for
	# any of the variables
	
	# Testing when we've got 1 book. Stubs books to 1 to do this.
	# All other vars should be 0.
	def test_end_book_1
		test = Run.new(Random.new(1231), 1)
		test.stub :books, 1 do
			assert_output ("Driver 1 obtained 1 book!\nDriver 1 obtained 0 dinosaur toys!\nDriver 1 attended 0 classes!\n") {
			
				test.end_print
			}
		end 
	end 
	
	# Testing when we've got 1 dino toy. Stubs toys to 1 to do this.
	# All other vars should be 0.
	def test_end_toy_1
		test = Run.new(Random.new(1231), 1)
		test.stub :toys, 1 do
			assert_output ("Driver 1 obtained 0 books!\nDriver 1 obtained 1 dinosaur toy!\nDriver 1 attended 0 classes!\n") {
			
				test.end_print
			}
		end 
	end 
	
	# Testing when we've got 1 class. Stubs class to 1 to do this.
	# All other vars should be 0.
	def test_end_classes_1
		test = Run.new(Random.new(1231), 1)
		test.stub :classes, 1 do
			assert_output ("Driver 1 obtained 0 books!\nDriver 1 obtained 0 dinosaur toys!\nDriver 1 attended 1 class!\n") {
			
				test.end_print
			}
		end 
	end 
	
	# Testing when all vars are 1. Three stubs for the three variables.
	# EDGE CASE
	def test_end_all_1
		test = Run.new(Random.new(1231), 1)
		test.stub :books, 1 do
		test.stub :toys, 1 do 
		test.stub :classes, 1 do 
			assert_output ("Driver 1 obtained 1 book!\nDriver 1 obtained 1 dinosaur toy!\nDriver 1 attended 1 class!\n") {
			
				test.end_print
			}
		end
		end
		end 
	end 
	
	# Testing when all the variables are more than 1. Stubs all three 
	# variables with 5. 
	# EDGE CASE
	def test_end_all_many
		test = Run.new(Random.new(1231), 1)
		test.stub :books, 5 do
		test.stub :toys, 5 do 
		test.stub :classes, 5 do 
			assert_output ("Driver 1 obtained 5 books!\nDriver 1 obtained 5 dinosaur toys!\nDriver 1 attended 5 classes!\n") {
			
				test.end_print
			}
		end 
		end
		end 
	end
	
	# UNIT TESTS FOR Run.run_full
	# @loc = Monroeville or Downtown -> this method will stop
	
	# This test checks if when the loc is Monroeville that the while loop in run_full exits and then end_print is called.
	# end_print is stubbed just to return 1 and step should not be called by this test.
	def test_run_full_Mon
		test = Run.new(Random.new(123), 1)
		test.stub :loc, 'Monroeville' do
			test.stub :end_print, 1 do
				assert_equal 1, test.run_full
			end 
		end 
	end 
	
	# This test checks if when the loc is Downtown that the while loop in run_full exits and then end_print is called.
	# end_print is stubbed just to return 1 and step should not be called by this test.
	def test_run_full_Down
		test = Run.new(Random.new(123), 1)
		test.stub :loc, 'Downtown' do
			test.stub :end_print, 1 do
				assert_equal 1, test.run_full
			end 
		end 
	end 

	
end