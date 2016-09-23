require "./spec/spec_helper"
require "json"

describe 'The Word Counting App' do
  def app
    Sinatra::Application
  end

  it "returns 200 and has the right keys" do
    get '/'
    expect(last_response).to be_ok
    parsed_response = JSON.parse(last_response.body)
    expect(parsed_response).to have_key("text")
    expect(parsed_response).to have_key("exclude")
    expect(parsed_response).to have_key("ref_id")
  end
  
  describe "submit captcha responses" do
    before do
      get '/'
      @parsed_response = JSON.parse(last_response.body)
      text_array = @parsed_response["text"].split(" ")
      words_to_count = text_array - @parsed_response["exclude"]
      text_to_count = words_to_count.join(" ")
      correct_answer = word_counts(text_to_count)
      @submit_response = @parsed_response
      @submit_response['counts'] = correct_answer
    end

    it "submits the right payload and returns 200" do
      post '/', @submit_response.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response).to be_ok
    end

    it "submits the wrong word counts and returns 400" do
      if @submit_response['counts'].key?('abcd12345')
        @submit_response['counts']['abcd12345'] += 1
      else
        @submit_response['counts']['abcd12345'] = 1
      end

      post '/', @submit_response.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response.status).to eq 400
    end
  
    it "submits the wrong ref_id and returns 400" do
      submit_response_bad_ref_id = @submit_response
      submit_response_bad_ref_id['ref_id'] << "-bad"
      post '/', submit_response_bad_ref_id.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response.status).to eq 400
    end
  end
end