
# takes ARGV as an input, parses it
# returns 
def parse_input (a)
	if a.length > 1 or a.length.zero?
		raise "Enter a seed and only a seed"
	else
		return a[0].to_i
	end
end


class Run
	@@starting_loc = ['Hospital', 'Cathedral', 'Hillman', 'Museum']
	# a hash from a location to a 'path', a street name and a destination 
	@@valid_paths = {
	'Hospital' => [ ['Foo St.', 'Hillman'], ['Fourth Ave.', 'Cathedral'] ],
	'Cathedral' => [ ['Fourth Ave.', 'Monroeville'], ['Bar St.', 'Museum'] ],
	'Museum' => [ ['Bar St.', 'Cathedral'], ['Fifth Ave.', 'Hillman'] ],
	'Hillman' => [ ['Fifth Ave.', 'Downtown'], ['Foo St.', 'Hospital'] ] }
	@@end_loc = ['Downtown', 'Monroeville']
	
	# starts a run 
	def initialize(r, id)
		raise "rand is invalid" unless r.is_a? Random
			
		@rand = r
		@id = id
		@loc = @@starting_loc.sample(random: @rand)
		@books = 0
		@toys = 0
		@classes = 0
	end
	
	# get all the valid paths based on location l
	def get_valid_paths ()
		return @@valid_paths[self.loc]
	end
	
	def step
		paths = self.get_valid_paths
		route = paths.sample(random: @rand)
		puts "Driver #{@id} heading from #{self.loc} to #{route[1]} via #{route[0]}"
		return route[1]
	end
	
	def count_stuff 
		if self.loc == 'Hillman' 
			@books = @books + 1
		elsif self.loc == 'Museum'
			@toys = toys + 1
		elsif self.loc == 'Cathedral'
			if @classes.zero?
				@classes = 1
			else
				@classes = @classes * 2
			end
		end 
	end
	
	
	def end_print
		print "Driver #{@id} obtained #{self.books} "
		if self.books == 1
			puts "book!"
		else 
			puts "books!"
		end 

		print "Driver #{@id} obtained #{self.toys} dinosaur "
		if self.toys == 1
			puts "toy!"
		else 
			puts "toys!"
		end 

		print "Driver #{@id} attended #{self.classes} "
		if self.classes == 1
			puts "class!"
		else 
			puts "classes!"
		end

	end

	def run_full
		until @@end_loc.include? self.loc do
			self.count_stuff
			@loc = self.step
		end
		self.end_print
	end 
	
	
	# attribute readers
	# I am going to assume this does not need a unit test as
	# they have 1 line of code
	def rand
		@rand
	end
	
	def id 
		@id
	end

	def loc 
		@loc
	end
	
	def books
		@books
	end
	
	def toys
		@toys
	end
	
	def classes 
		@classes
	end
	
	
	
	# Tiny little test method\
	# Used in test_classes_not_zero to keep it independent
	# Not actually used in regular program so no need for a 
	# test for itself 
	def classes_1
		@classes = 1
	end 
end 




seed = parse_input(ARGV)

r = Random.new(seed)
(1..5).each { |x|
	sim = Run.new(r, x)
	sim.run_full
}
