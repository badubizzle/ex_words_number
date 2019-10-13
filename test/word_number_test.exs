defmodule WordNumberTest do
  use ExUnit.Case
  doctest WordNumber
  doctest Numbers

  use ExUnitProperties

  property "number to words and words to number" do
    check all(number <- positive_integer() |> resize(1_000)) do
      words = Numbers.number_to_words(number)

      number2 = Numbers.words_to_number(words)
      IO.inspect([words, number, number2])
      assert number == number2
    end

    check all(number <- positive_integer() |> resize(1_000_000)) do
      words = Numbers.number_to_words(number)

      number2 = Numbers.words_to_number(words)
      IO.inspect([words, number, number2])
      assert number == number2
    end

    check all(number <- positive_integer() |> resize(1_000_000_000)) do
      words = Numbers.number_to_words(number)

      number2 = Numbers.words_to_number(words)
      IO.inspect([words, number, number2])
      assert number == number2
    end

    check all(number <- positive_integer() |> resize(1_000_000_000_000)) do
      words = Numbers.number_to_words(number)

      number2 = Numbers.words_to_number(words)
      IO.inspect([words, number, number2])
      assert number == number2
    end
  end
end
