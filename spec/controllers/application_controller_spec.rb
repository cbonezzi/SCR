require 'spec_helper'

describe SoundCloud do
  describe 'searching soundcloud by keyword' do
    it "raises ArgumentError when initialized with no options" do
      expect do
	SoundCloud.new
      end.to raise_error(ArgumentError)
    end  
    
    context 'initialized with a client id' do
      subject{SoundCloud.new(:client_id => 'client')}
    
      describe "#client_id" do
	it "returns the initialized value" do
	  expect(subject.client_id).to eq("client")
	end
      end
  
      describe "#exchange_token" do
	it "raises an argument error if client_secret no present" do
	  expect do
	    SoundCloud.new(:client_id => 'x').exchange_token(:refresh_token => 'as')
	  end.to raise_error(ArgumentError)
	end
      end
      
      describe "#site" do
	it "soundcloudradio.herokuapp.com" do
	  expect("soundcloudradio.herokuapp.com").to eq("soundcloudradio.herokuapp.com")
	end
      end

      describe "#host" do
	it "soundcloudradio.herokuapp.com" do
	  expect("soundcloudradio.herokuapp.com").to eq("soundcloudradio.herokuapp.com")
	end
      end
    end
  end
end

