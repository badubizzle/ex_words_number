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

  defp get_number_from_words([word], _figure) when is_valid_start(word) do
    number(word)
  end

  defp get_number_from_words([h | _] = words, figure)
       when is_list(words)
       when is_valid_start(h) do
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

  defp process_words(_, [], acc) do
    Enum.reverse(acc)
  end

  defp process_words(_, [word], [prev | acc2])
       when word in @multi do
    Enum.reverse([number(word) * prev | acc2])
  end

  defp process_words(_, [word], acc) do
    Enum.reverse([number(word) | acc])
  end

  defp process_words(figure, [h | [t | r]] = words, acc) do
    error_message = "Invalid figure #{figure} starting from '#{Enum.join(words, " ")}'"

    cond do
      h in @multi ->
        [prev | acc2] = acc
        acc = [number(h) * prev | acc2]
        process_words(figure, [t | r], acc)

      h in ["hundred"] ->
        [prev | acc2] = acc

        if prev < 10 do
          # validation
          # prevent hundred must be preceeded by number less than 10
          # e.g two hundred not twenty hundred
          acc = [number(h) * prev | acc2]
          process_words(figure, [t | r], acc)
        else
          raise error_message
        end

      h in @ones ->
        cond do
          t in @multi_with_hundred ->
            v = number(h) * number(t)
            process_words(figure, r, [v | acc])

          true ->
            raise error_message
        end

      h in @teens ->
        cond do
          t in @multi ->
            # validation
            # ten to nineteen must be followed by
            v = number(h) * number(t)
            process_words(figure, r, [v | acc])

          true ->
            raise error_message
        end

      h in @tens ->
        cond do
          t in @ones ->
            # validation:
            # prevents something like twenty five three or thirty four forty
            # can only be follow by nohting, thousand, million, billion
            if List.first(r) in (@tens ++ @teens ++ @ones ++ ["hundred"]) do
              raise error_message
            else
              v = number(h) + number(t)

              case acc do
                [prev | acc2] when is_integer(prev) and prev < 1000 ->
                  process_words(figure, r, [v + prev | acc2])

                _ ->
                  process_words(figure, r, [v | acc])
              end
            end

          t in ["thousand", "million", "billion"] ->
            case acc do
              [prev | acc2] when is_integer(prev) and prev < 1000 ->
                v = (prev + number(h)) * number(t)
                process_words(figure, r, [v | acc2])

              _ ->
                v = number(h) * number(t)
                process_words(figure, r, [v | acc])
            end

          true ->
            raise error_message
        end

      true ->
        raise error_message
    end
  end

  def number_to_words(number) when is_integer(number) do
    @numbers_words
    |> number_to_words(number, [])
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  def number_to_words([], _number, acc) do
    acc
  end

  def number_to_words(_, number, acc) when number <= 0 do
    acc
  end

  def number_to_words([{v, k} | r], number, acc) when number >= v and v >= 100 do
    remainder = rem(number, v)
    count = number_to_words(div(number, v))

    number_to_words(r, remainder, ["#{count} #{k}" | acc])
  end

  def number_to_words([{v, k} | r], number, acc) when number >= v do
    remainder = rem(number, v)
    number_to_words(r, remainder, ["#{k}" | acc])
  end

  def number_to_words([{_, _} | r], number, acc) do
    number_to_words(r, number, acc)
  end
end
