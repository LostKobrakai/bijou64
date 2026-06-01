{list, _} = Code.eval_file("bench/_data.exs")

Benchee.run(
  %{
    "Varint: encode" => fn list ->
      Enum.each(list, fn int -> Varint.LEB128.encode(int) end)
    end,
    "Bijou64: encode" => fn list ->
      Enum.each(list, fn int -> Bijou64.encode(int) end)
    end
  },
  inputs: %{random_500: list}
)
