require 'csv'
require 'pry'
require 'json'


  json = JSON.parse(File.read('538Forecast-2018-09-03.json'))

  c = CSV.generate do |csv|
    csv << [
      'District',
      'D Lite %',
      'D Deluxe %',
      'D Classic %',
      'R Lite %',
      'R Reluxe %',
      'R Classic %',
    ]

    json['districtForecasts'].each do |district_hash|
      begin
        state = district_hash['state']
        next if district_hash['district'].nil?
        district = state + "-" + district_hash['district']
        party = {}
        district_hash['forecast'].each do |candidate|
          models = candidate['models']
          party[candidate['party']] = [
            models['lite']['winprob'].to_f / 100,
            models['deluxe']['winprob'].to_f / 100,
            models['classic']['winprob'].to_f / 100
          ]
        end

        party['D'] = [0,0,0] if party['D'].nil?
        party['R'] = [0,0,0] if party['R'].nil?

      csv << [
        district,
        party['D'][0],
        party['D'][1],
        party['D'][2],
        party['R'][0],
        party['R'][1],
        party['R'][2],
      ]

     rescue StandardError => e
        puts e.inspect
        binding.pry
        exit
      end

    end
  end

  puts c
