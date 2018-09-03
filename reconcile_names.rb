require 'csv'
require 'pry'
require 'fuzzy_match'

mapping = {}
os_mapping = {}

CSV.foreach('FEC-2018-08-18T14_56_11.csv', :headers => true) do |row|
  begin
    district_number = row['district_number']
    district_number = '1' if district_number.nil? || district_number.empty? || district_number.to_i == 0
    district = row['state'] + '-' + district_number
    name = row['name']
    mapping[district] ||= {}
    if mapping[district][name]
      if row['receipts'] > mapping[district][name]['receipts']
        mapping[district][name] = row
      end
    else
      mapping[district][name] = row
    end
    #if row['name'].include? 'GALVIN'
      #binding.pry
      #exit
    #end
  rescue StandardError => e
    puts e.inspect
    puts row.inspect
    #binding.pry
    exit
  end
end

CSV.foreach('PrimaryWinners.csv', :headers => true) do |row|
  begin
  district = row['District']
  name = row['Name']
  party = row['Party']
  os_mapping[district] ||= {}
  os_mapping[district][party] ||= {}
  os_mapping[district][party][name] = row
  rescue StandardError => e
    puts e.inspect
    puts row.inspect
    binding.pry
    exit
  end
end

c = CSV.generate do |csv|
  csv << %w(os_name fec_name district party receipts)
  os_mapping.each do |district, parties|
    fec_candidates = mapping[district].keys
    parties.each do |party, os_candidates|
      os_candidates.each do |os, info|
        begin
          # sometimes candidates have different parties than how they're registered
          os = os.strip
          fec = FuzzyMatch.new(fec_candidates).find(os)
          #if district == 'AK-1'
            #binding.pry
            #exit
          #end
          #puts "#{district},#{party},#{os} : #{fec}"

          csv << [os, fec, district, party, mapping[district][fec]['receipts']] if fec
          #binding.pry if os.start_with? "David Young"
        rescue StandardError => e
          puts e.inspect
          binding.pry
          exit
        end
      end
    end
  end
end

puts c
