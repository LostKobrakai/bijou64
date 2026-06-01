{list, _} = Code.eval_file("bench/_data.exs")

Benchee.run(
  %{
    "Varint: decode" => {
      fn list ->
        Enum.all?(list, fn binary ->
          match?({_, ""}, Varint.LEB128.decode(binary))
        end)
      end,
      before_scenario: fn input ->
        Enum.map(input, fn int -> Varint.LEB128.encode(int) end)
      end
    },
    "Bijou64: decode" => {
      fn list ->
        Enum.all?(list, fn binary ->
          match?({_, ""}, Bijou64.decode(binary))
        end)
      end,
      before_scenario: fn input ->
        Enum.map(input, fn int -> Bijou64.encode(int) end)
      end
    }
  },
  inputs: %{random_500: list}
)
