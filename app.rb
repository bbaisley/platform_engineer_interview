require 'sinatra'
require "sinatra/reloader" if development?
require 'digest/sha1'
require 'json'

set :port, 8000

ENCODING_PHRASE = "Trolls live under bridges"
WORD_SPLIT = " "

before do
	@client_id = request.ip
end
  
# Generates a client unique hash key from 2 parameters
#
# @param [source] source text for captcha
# @param [exclude] excluded word list
# @return [String] the hash generated
def id_gen(source, exclude)
	id = Digest::SHA1.hexdigest("#{ENCODING_PHRASE}-#{source}-#{exclude}-#{@client_id}")
	return id
end

# Create a random subset of words to exclude from a string
#
# @param [word_list] text to extract words from
# @return [Array] the list of exclude words
def exclusion_words(word_list)
	# get a subset of words to exclude based on the unique list
	uniq_words = word_list.uniq

	# check there is more than 1 unique word
	if uniq_words.length==1
		exclude = []
	else
		max_exclude = uniq_words.length-1
		exclude_count = rand(1..max_exclude)
		exclude = uniq_words.sample(exclude_count)
	end
	return exclude
end

# Count occurances of each word in a block of text
#
# @param [text] text to counts the words from
# @return [Hash] list of words and their occurance count
def word_counts(text)
	word_list = text.split(WORD_SPLIT)
	counts = Hash.new(0)
	word_list.each { |word| counts[word] += 1 }
	return counts
end

get '/' do

  files = %w(texts/0 texts/1 texts/2 texts/3 texts/4 texts/5)

  text_file = files.sample
  source_text = File.read(text_file).strip
  text_array = source_text.split
	exclude = exclusion_words(text_array)

  # Freeze the parameter data and get a reference id
  source_text.freeze
  exclude.freeze
  ref_id = id_gen(source_text, exclude)
  
  erb :"get.json", locals: { source_text: source_text, exclude: exclude, ref_id: ref_id }
end

post '/' do

	submitted = request.env["rack.input"].read
	captcha = JSON.parse(submitted) rescue Hash.new(0)
	
	# check if required keys are present
	unless captcha.length==4 && captcha.key?('text') && captcha.key?('exclude') && captcha.key?('ref_id') && captcha.key?('counts')
		status 400
	else
		# re-generate the ref_id based on content
		ref_id = id_gen(captcha["text"], captcha["exclude"])
		# check if ref_id is correct
		unless ref_id==captcha["ref_id"]
			status 400
		else
			# create a list of words to count
			text_array = captcha["text"].split(WORD_SPLIT)
			# remove words that shouldn't be counted
			words_to_count = text_array - captcha["exclude"]
			# convert cleaned list back to text
			text_to_count = words_to_count.join(" ")
			correct_answer = word_counts(text_to_count)
			submitted_answer = captcha["counts"]
			
			# compare submitted counts with correct counts
			unless correct_answer==captcha["counts"]
				status 400
			else
				status 200
			end
		end
	end

end