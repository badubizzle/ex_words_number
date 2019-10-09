defmodule WordNumberTest do
  use ExUnit.Case
  doctest WordNumber
  doctest Numbers

  test "words to numbers" do
    assert 1 == Numbers.words_to_number("one")
    assert 10 == Numbers.words_to_number("ten")
    assert 100 == Numbers.words_to_number("one hundred")
    assert 1_000 == Numbers.words_to_number("one thousand")
    assert 1_000_000 == Numbers.words_to_number("one million")

    assert 123_123_123 ==
             Numbers.words_to_number(
               "one hundred and twenty three million one hundred and twenty three thousand and one hundred and twenty three"
             )

    assert 199_254_740_992 ==
             Numbers.words_to_number(
               "one hundred ninety-nine billion, two hundred fifty-four million, seven hundred forty thousand, nine hundred ninety-two"
             )

    assert Numbers.words_to_number("one hundred thirty-five") == 135

    assert Numbers.words_to_number("two million twenty three thousand and forty nine") ==
             2_023_049

    assert Numbers.words_to_number("two million three thousand nine hundred and eighty four") ==
             2_003_984

    assert Numbers.words_to_number("two million three thousand nine hundred and eighty four") ==
             2_003_984

    assert Numbers.words_to_number("nineteen") == 19
    assert Numbers.words_to_number("two thousand and nineteen") == 2019
    assert Numbers.words_to_number("two million three thousand and nineteen") == 2_003_019
    assert Numbers.words_to_number("three billion") == 3_000_000_000
    assert Numbers.words_to_number("three million") == 3_000_000

    assert Numbers.words_to_number(
             "one hundred twenty three million four hundred fifty six thousand seven hundred and eighty nine"
           ) == 123_456_789

    assert Numbers.words_to_number("eleven") == 11
    assert Numbers.words_to_number("nineteen billion and nineteen") == 19_000_000_019
    assert Numbers.words_to_number("one hundred and forty two") == 142
    assert Numbers.words_to_number("five") == 5

    assert Numbers.words_to_number("two million twenty three thousand and forty nine") ==
             2_023_049

    assert Numbers.words_to_number("two million twenty three thousand and forty nine") ==
             2_023_049

    assert Numbers.words_to_number("one billion two million twenty three thousand and forty nine") ==
             1_002_023_049

    assert Numbers.words_to_number("one hundred thirty-five") == 135
    assert Numbers.words_to_number("hundred") == 100
    assert Numbers.words_to_number("thousand") == 1000
    assert Numbers.words_to_number("million") == 1_000_000
    assert Numbers.words_to_number("billion") == 1_000_000_000
  end

  test "numbers to words" do
    assert "one" == Numbers.number_to_words(1)
    assert "ten" == Numbers.number_to_words(10)
    assert "one hundred" == Numbers.number_to_words(100)
    assert "one thousand" == Numbers.number_to_words(1_000)
    assert "one million" == Numbers.number_to_words(1_000_000)

    assert "one hundred twenty three million one hundred twenty three thousand one hundred twenty three" ==
             Numbers.number_to_words(123_123_123)

    assert "one hundred ninety nine billion two hundred fifty four million seven hundred forty thousand nine hundred ninety two" ==
             Numbers.number_to_words(199_254_740_992)

    assert Numbers.number_to_words(135) == "one hundred thirty five"

    assert Numbers.number_to_words(2_023_049) ==
             "two million twenty three thousand forty nine"

    assert Numbers.number_to_words(2_003_984) ==
             "two million three thousand nine hundred eighty four"

    assert Numbers.number_to_words(2_003_984) ==
             "two million three thousand nine hundred eighty four"

    assert Numbers.number_to_words(19) == "nineteen"
    assert Numbers.number_to_words(2019) == "two thousand nineteen"
    assert Numbers.number_to_words(2_003_019) == "two million three thousand nineteen"
    assert Numbers.number_to_words(3_000_000_000) == "three billion"
    assert Numbers.number_to_words(3_000_000) == "three million"

    assert Numbers.number_to_words(123_456_789) ==
             "one hundred twenty three million four hundred fifty six thousand seven hundred eighty nine"

    assert Numbers.number_to_words(11) == "eleven"
    assert Numbers.number_to_words(19_000_000_019) == "nineteen billion nineteen"

    assert Numbers.number_to_words(2_023_049) ==
             "two million twenty three thousand forty nine"

    assert Numbers.number_to_words(1_002_023_049) ==
             "one billion two million twenty three thousand forty nine"
  end
end
