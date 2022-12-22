require 'delegate'

class Star
  attr_accessor :name, :size, :dist_to_earth

  def initialize(name, size, dist_to_earth)
    @name = name
    @size = size
    @dist_to_earth = dist_to_earth
  end
end

class StarDecoratorOne < SimpleDelegator
  def visibility
    if dist_to_earth < 60000
      "Видно з Землі!"
    else
      "Не видно неозброєним оком."
    end
  end
end

class StarDecoratorTwo < SimpleDelegator
  def all_information
    puts("Назва: #{name}\nРозмір: #{size} діаметрів Сонця\nДистанція до Землі: #{dist_to_earth} світлових років")
  end
end
