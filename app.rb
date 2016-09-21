require 'sinatra'
require "sinatra/reloader" if development?
require 'digest/sha1'
require 'facets'

set :port, 8000

ENCODING_PHRASE = "Trolls live under bridges"

before do
	@client_id = request.ip
end
  
def id_gen(source, exclude)
	id = Digest::SHA1.hexdigest("#{ENCODING_PHRASE}-#{source}-#{exclude}-#{@client_id}")
	return id
end

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

	captcha = JSON.parse(request.env["rack.input"].read)
	if captcha.length==0
		halt 400
	end
	
	text_array = captcha.text.split
	exclude_words = captcha.exclude
	words_to_count = text_array - exclude
	text_to_count = words_to_count.join(" ")
	correct_answer = text_to_count.frequency
	

end