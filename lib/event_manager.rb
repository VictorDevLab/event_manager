require 'csv'
require 'google/apis/civicinfo_v2'

template_letter = File.read('form_letter.html')



def clean_zipcode(zipcode)   
    # if zipcode.nil?
    #     zipcode = "00000"
    # elsif zipcode.length < 5
    #     zipcode = zipcode.rjust(5, "0")
    # elsif zipcode.length > 5
    #     zipcode = zipcode[0..4]
    # else
    #     zipcode
    # end
    zipcode.to_s.rjust(5, '0')[0..4] 
end

def legislators_by_zip_code(zip)
    #so you need this key here
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin 
        legislators = civic_info.representative_info_by_address(
            address: zip,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )
            legislators = legislators.officials
            legislator_names = legislators.map(&:name)
            legislator_names.join(", ")
       rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
       end
end

puts "Event manager initialized"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
   
   legislators = legislators_by_zip_code(zipcode)
   
   puts "#{name} #{zipcode} #{legislators}"
end