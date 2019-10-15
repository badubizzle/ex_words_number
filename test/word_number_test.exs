defmodule WordNumberTest do
  use ExUnit.Case
  doctest WordNumber
  doctest Numbers

  use ExUnitProperties

  test "invalid words" do
    words = [
      "one two hundred",
      "forty two hundred",
      "thousand one",
      "forty eleven",
      "four eleven",
      "one thirteen"
    ]

    for w <- words do
      try do
        Numbers.words_to_number(w)
        assert false, "Invalid error"
      rescue
        e ->
          IO.inspect(e)
          assert true
      end
    end
  end

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
