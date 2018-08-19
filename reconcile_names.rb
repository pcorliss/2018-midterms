require 'csv'
require 'pry'
require 'fuzzy_match'

mapping = {}
# mapping[district][party][type][name] = row

CSV.foreach('FEC-2018-08-18T14_56_11.csv', :headers => true) do |row|
  begin
  district_number = row['district_number']
  district_number = '1' if district_number.nil? || district_number.empty?
  district = row['state'] + '-' + district_number
  party = row['party'][0]
  name = row['name']
  mapping[district] ||= {}
  mapping[district][party] ||= {:fec => {}}
  if mapping[district][party][:fec][name]
    #puts "Dupe: #{district} #{name} #{row['receipts']} #{mapping[district][party][:fec][name]['receipts']}"
    if row['receipts'] > mapping[district][party][:fec][name]['receipts']
      mapping[district][party][:fec][name] = row
    end
  else
    mapping[district][party][:fec][name] = row
  end
  rescue StandardError => e
    puts e.inspect
    puts row.inspect
    binding.pry
  end
end

CSV.foreach('PrimaryWinners.csv', :headers => true) do |row|
  begin
  district = row['District']
  name = row['Name']
  party = row['Party']
  mapping[district] ||= {}
  mapping[district][party] ||= {}
  mapping[district][party][:os] ||= {}
  mapping[district][party][:os][name] = row
  rescue StandardError => e
    puts e.inspect
    puts row.inspect
    binding.pry
  end
end

c = CSV.generate do |csv|
  csv << %w(os_name fec_name district party receipts)
  mapping.each do |district, parties|
    parties.each do |party, types|
      next unless types[:fec] && types[:os]
      begin
        fec_candidates = types[:fec].keys
        os_candidates = types[:os].keys
        os_candidates.each do |os|
          os = os.strip
          fec = FuzzyMatch.new(fec_candidates).find(os)
          #puts "#{district},#{party},#{os} : #{fec}"
          csv << [os, fec, district, party, types[:fec][fec]['receipts']] if fec
          #binding.pry if os.start_with? "David Young"
        end
      rescue StandardError => e
        puts e.inspect
        binding.pry
        exit
      end
    end
  end
end

puts c
