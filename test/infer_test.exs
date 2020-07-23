defmodule InferTest do
  use ExUnit.Case

  alias Hackerrank.Infer
  alias Hackerrank.Infer.{IdsProvider, CharsProvider, PPrint}

  setup_all do
    IdsProvider.start_link()
    CharsProvider.start_link()
    :ok
  end

  setup do
    IdsProvider.flush()
    CharsProvider.flush()
    :ok
  end

  def pipe(sample, expected) do
    sample
    |> IO.inspect()
    |> Infer.extract_equations(Infer.env())
    |> IO.inspect()
    |> Infer.resolve()
    |> IO.inspect()
    |> Map.get(sample)
    |> PPrint.pprint()
    |> (fn r -> assert r == expected end).()
  end

  # test "infer let" do
  #   let_sample = {:let, :x, :id, :x}
  #   pipe(let_sample, "forall[a] a -> a")
  # end

  test "infer abstr" do
    # fun x -> let y = fun z -> z in y
    sample = {
      :fun,
        [:x],
        {:let, :y, {:fun, [:z, :z]}, :y}

    }
    expected = "forall[a b] a -> b -> b"
    pipe(sample, expected)
  end

end
