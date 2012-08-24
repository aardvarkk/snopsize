namespace :snopsize do
  
  desc 'Decay inactive snops.'
  
  # The => :environment bit lets us call models we've used in the project
  task :decay => :environment do

    # Need to recalculate popularity
    include FaveSnopsHelper

    while true do
      
      # Grab the inactive 
      @inactives = Snop.where("updated_at < :old_date",
        :old_date => 7.days.ago)
      
      # Go through them and decay them with no delta
      @inactives.each do |snop|
        recalc_popularity(snop, 0)
      end

      # Show the inactive ones on screen
      # puts @inactives
      
      # Only repeat this task every hour or so...
      sleep 1.hour
    end
  end

end