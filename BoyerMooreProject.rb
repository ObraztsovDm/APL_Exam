# вхідні дані
def input_data
  puts "Введіть початковий рядок:"
  text = String(STDIN.gets.chomp)

  puts "Введіть шуканий підрядок:"
  sub_text = String(STDIN.gets.chomp)

  if sub_text.length > text.length
    puts "Шуканий підрядок більше ніж вхідний рядок."
    abort
  end

  if text.length == 0 or sub_text.length == 0
    puts "Помилка введення даних."
    abort
  end

  {
    :text => text.split(""),
    :sub_text => sub_text.split("")
  }
end

#метод заповнення таблиці зсувів
def offset_table_method(sub_text)
  offset_table = []
  n_var = sub_text.length

  start_time = Time.now.to_f

  (0..(n_var - 2)).each do |i|
    offset_table[i] = n_var - i - 1

    (i..(n_var - 2)).each do |j|
      if sub_text[i] == sub_text[j]
        offset_table[i] = offset_table[j]
        break
      end
    end
  end

  offset_table[n_var - 1] = n_var

  (0..(n_var - 1)).each do |i|
    if sub_text[n_var - 1] == sub_text[i]
      offset_table[n_var - 1] = offset_table[i]
      break
    end
  end

  end_time = Time.now.to_f

  {
    :n_var => n_var,
    :offset_table => offset_table,
    :time_offset => end_time - start_time
  }
end

#метод реалізації алгоритму Бойера-Мура
def boyer_moore_method(text, sub_text, offset_table)
  n_var = offset_table.dig(:n_var)
  result = []

  i = 0
  j = n_var - 1

  last_char = text[n_var - 1]
  text_len = text.length

  start_time = Time.now.to_f

  while (j + i) < text_len
    result << j + i + 1

    # умова на співпадіння останнього елементу шаблону (sub_text) та вихідного рядка
    if text[j + i] != sub_text[j] || j == 0
      shift_index = -1
      (0..n_var).each do |k|

        # умова на визначення зсуву
        if last_char == sub_text[k]
          shift_index = k
          break
        end
      end

      if shift_index == -1
        i += n_var
      else
        i += offset_table.dig(:offset_table)[shift_index]
      end
      j = n_var - 1
      last_char = text[j + i]
    else
      j -= 1
    end
  end

  end_time = Time.now.to_f

  {
    :indices => result,
    :shift_value => result[-1] - 1,
    :time_method => end_time - start_time
  }
end

input = input_data
text = input.dig(:text)
sub_text = input.dig(:sub_text)
offset_table = offset_table_method(sub_text)
method = boyer_moore_method(text, sub_text, offset_table)

puts "Перевірені індекси: #{method.dig(:indices).join(", ")}
Необхідний зсув по вхідному рядку для знаходження підрядка: #{method.dig(:shift_value)}
Час виконання: #{offset_table.dig(:time_offset) + method.dig(:time_method)} c."
