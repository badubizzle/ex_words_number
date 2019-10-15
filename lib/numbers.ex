defmodule Numbers do
  @numbers %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "ten" => 10,
    "eleven" => 11,
    "twelve" => 12,
    "thirteen" => 13,
    "fourteen" => 14,
    "fifteen" => 15,
    "sixteen" => 16,
    "seventeen" => 17,
    "eighteen" => 18,
    "nineteen" => 19,
    "twenty" => 20,
    "thirty" => 30,
    "forty" => 40,
    "fifty" => 50,
    "sixty" => 60,
    "seventy" => 70,
    "eighty" => 80,
    "ninety" => 90,
    "hundred" => 100,
    "thousand" => 1_000,
    "million" => 1_000_000,
    "billion" => 1_000_000_000,
    "trillion" => 1_000_000_000_000
  }

  @numbers_words Enum.zip(Map.values(@numbers), Map.keys(@numbers))
                 |> Enum.sort()
                 |> Enum.reverse()

  @multi ["thousand", "million", "billion", "trillion"]
  @multi_with_hundred ["hundred" | @multi]

  @tens [
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ]

  @ones [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  ]

  @teens [
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ]

  defguard is_valid_start(word)
           when is_binary(word) and (word in @ones or word in @tens or word in @teens)

  defp number(word) do
    case Map.get(@numbers, word) do
      nil ->
        raise "Invalid figure #{word}"

      n ->
        n
    end
  end

  @doc """
    Takes numbers in words and return the number

    #Example

      iex> Numbers.words_to_number("one")
      1
      iex> Numbers.words_to_number("hundred")
      100
      iex> Numbers.words_to_number("seven hundred and five thousand, eight hundred and forty seven")
      705847
      iex> Numbers.words_to_number("two hundred and seventy eight thousand, nine hundred")
      278900
  """

  def words_to_number(words) when is_binary(words) do
    parts = String.split(words, [" ", "-", " and ", ","], trim: true)

    get_number_from_words(parts, words)
  end

  defp get_number_from_words([word], _figure) do
    number(word)
  end

  defp get_number_from_words([h | _] = words, figure) when is_valid_start(h) do
    acc = process_words(figure, words, [])

    number =
      Enum.reduce(acc, 0, fn
        v, t when is_integer(v) ->
          v + t

        _, t ->
          t
      end)

    number
  end

  defp process_acc(value, [prev | acc2]) when prev < 1000 do
    v = value + prev
    [v | acc2]
  end

  defp process_acc(value, acc) do
    [value | acc]
  end

  defp process_words(_, [], acc) do
    Enum.reverse(acc)
  end

  defp process_words(figure, [h | r] = words, acc) do
    error_message = "Invalid figure #{figure} starting from '#{Enum.join(words, " ")}'"

    cond do
      h in @multi ->
        [prev | acc2] = acc
        acc = [number(h) * prev | acc2]
        process_words(figure, r, acc)

      h in ["hundred"] ->
        [prev | acc2] = acc

        if prev < 10 do
          # validation
          # prevent hundred must be preceeded by number less than 10
          # e.g two hundred not twenty hundred
          acc = [number(h) * prev | acc2]
          process_words(figure, r, acc)
        else
          raise error_message
        end

      h in @ones ->
        # validation:
        # prevents something like five three or four forty
        # can only be follow by nothing or hundred or thousand or million or billion

        if Enum.count(r) > 0 and number(List.first(r)) < 100 do
          raise error_message
        end

        process_words(figure, r, process_acc(number(h), acc))

      h in @teens ->
        # validation:
        # prevents something like eleven five  or thirteen forty
        # can only be follow by nothing or thousand or million or billion

        if Enum.count(r) > 0 and number(List.first(r)) <= 100 do
          raise error_message
        end

        process_words(figure, r, process_acc(number(h), acc))

      h in @tens ->
        # validation:
        # prevents something like twenty elevent or thirty forty
        # can only be follow by nothing or ones or thousand or million or billion

        if Enum.count(r) > 0 do
          next_number = number(List.first(r))

          if next_number > 9 and next_number <= 100 do
            raise error_message
          end
        end

        process_words(figure, r, process_acc(number(h), acc))

      true ->
        raise error_message
    end
  end

  def number_to_words(number) when is_integer(number) do
    @numbers_words
    |> number_to_words(number, %{big: [], small: []})
    |> format_words(number)
  end

  defp format_words(%{big: [_ | _] = big, small: [_ | _] = small}, number) when number >= 100 do
    format_words(List.flatten([Enum.reverse(big), [Enum.join(Enum.reverse(small), " ")]]))
  end

  defp format_words(%{big: big, small: small}, _number) do
    Enum.join(List.flatten([Enum.reverse(big), Enum.reverse(small)]), " ")
  end

  defp format_words(l) when is_list(l) do
    last = List.last(l)
    top = Enum.take(l, Enum.count(l) - 1)
    "#{Enum.join(top, ", ")} and #{last}"
  end

  def number_to_words([], _number, acc) do
    acc
  end

  def number_to_words(_, number, acc) when number <= 0 do
    acc
  end

  def number_to_words([{v, k} | r], number, %{big: big} = acc) when number >= v and v >= 100 do
    remainder = rem(number, v)
    count = number_to_words(div(number, v))
    word = "#{count} #{k}"
    big = [word | big]
    acc = Map.put(acc, :big, big)
    number_to_words(r, remainder, acc)
  end

  def number_to_words([{v, k} | r], number, %{small: small} = acc) when number >= v do
    remainder = rem(number, v)
    acc = Map.put(acc, :small, ["#{k}" | small])
    number_to_words(r, remainder, acc)
  end

  def number_to_words([{_, _} | r], number, acc) do
    number_to_words(r, number, acc)
  end
end
