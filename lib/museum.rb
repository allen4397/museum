class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
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
  end
end
