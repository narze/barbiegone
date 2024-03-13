require 'date'
require 'json'
require 'net/http'

def append_to_file(card_data)
  data = card_data.merge(updated_at: DateTime.now.to_s)

  puts "Append to data.json: #{data}"

  current = File.open('data.json') do |file|
    arr = JSON.parse(file.read)

    # if point and spending changes, append to the file
    if arr.last['point'] != data['point'] || arr.last['spending'] != data['spending']
      arr << data

      File.write('data.json', JSON.pretty_generate(arr))
    else
      puts "No changes in point and spending, skip appending to the file"
    end
  end
end

def fetch!
  url = ENV.fetch('BBG_API_URL')

  response = Net::HTTP.get_response(URI(url))

  if response.code != '200'
    raise "ERROR: Failed to fetch data from #{url}"
  end

  JSON.parse(response.body)[0] # Return the first card data
end

def transform!(card_data)
  card_data.slice(*%w[
    point
    cardType
    cardId
    level
    spending
  ]).tap do |data|
    data[:expireDate] = Date.parse(card_data.dig("pointDetail",0,'expireDate'))
  end
end

def download_image(image_url)
  puts "Downloading card image..."

  response = Net::HTTP.get_response(URI(image_url))

  if response.is_a?(Net::HTTPSuccess)
    File.open("card.png", "wb") do |file|
      file.write(response.body)
    end
  else
    puts "Failed to download the image: #{response.code} #{response.message}"
  end
end

def card_type_changed?(new_card_data)
  current_card_type = File.open('data.json') do |file|
    JSON.parse(file.read).last['cardType']
  end

  current_card_type != new_card_data['cardType']
end

card_data = fetch!
download_image(card_data['imageUrl']) if card_type_changed?(card_data)
append_to_file(transform!(card_data))
puts "Done!"
