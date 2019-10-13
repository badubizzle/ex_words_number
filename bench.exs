list = Enum.to_list(1..1000)
map_fun = fn i -> Numbers.number_to_words(i) end

Benchee.run(
  %{
    "number_to_words" => fn -> Enum.map(list, map_fun) end
  },
  time: 10,
  memory_time: 2
)
