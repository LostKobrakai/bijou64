integers = for _ <- 1..500, do: :rand.uniform(2 ** 64) - 2 ** 63

unsigned_integers = Enum.map(integers, &Bijou64.Zigzag.to_unsigned/1)

Benchee.run(
  %{
    "Varint.Zigzag: encode" => fn list ->
      Enum.each(list, fn int -> Varint.Zigzag.encode(int) end)
    end,
    "Bijou64.Zigzag: to_unsigned" => fn list ->
      Enum.each(list, fn int -> Bijou64.Zigzag.to_unsigned(int) end)
    end
  },
  inputs: %{random_500: integers}
)

Benchee.run(
  %{
    "Varint.Zigzag: decode" => fn list ->
      Enum.each(list, fn int -> Varint.Zigzag.decode(int) end)
    end,
    "Bijou64.Zigzag: from_unsigned" => fn list ->
      Enum.each(list, fn int -> Bijou64.Zigzag.from_unsigned(int) end)
    end
  },
  inputs: %{random_500: unsigned_integers}
)
