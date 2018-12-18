class Museum
  attr_reader :name,
              :exhibits,
              :patrons,
              :patrons_of_exhibits

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @patrons_of_exhibits = {}
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
    @patrons_of_exhibits[exhibit] = []
  end

  def recommend_exhibits(patron)
    recommended_exhibits = []
    patron.interests.each do |interest|
      exhibits.each do |exhibit|
        if interest == exhibit.name
          recommended_exhibits << exhibit
        end
      end
    end
    return recommended_exhibits
  end

  def admit(patron)
    @patrons << patron
    attend_affordable_exhibits(patron)
  end

  def attend_affordable_exhibits(patron)
    exhibits_interested_in = recommend_exhibits(patron)
    exhibits_interested_in.each do |exhibit|
      if exhibit.cost <= patron.spending_money
        patron.spending_money -= exhibit.cost
        patrons_of_exhibits[exhibit] << patron
      end
    end
  end

  def patrons_by_exhibit_interest
    patrons_by_exhibit = {}
    exhibits.each do |exhibit|
      patrons_by_exhibit[exhibit] = []
      patrons.each do |patron|
        patron.interests.each do |interest|
          if exhibit.name == interest
            patrons_by_exhibit[exhibit] << patron
          end
        end
      end
    end
    return patrons_by_exhibit
  end
end
