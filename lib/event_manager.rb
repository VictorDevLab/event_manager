    puts "Event manager Initialized"

    lines = File.readlines("event_attendees.csv")

    lines.each do |line| 
        columns = line.split(",")
        names = columns[2]
        p names
    end
