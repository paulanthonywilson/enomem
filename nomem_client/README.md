# NomemClient

Illustrates that larger replies cause hackney to return with an `:enomem` error response.

Usage:

1. `cd`` into the `nomem_server` directory
2. `mix deps.get` (only needed once, obvs)
3. `iex -S mix`
4. In a another terminal `cd`` into this (`nomem_client`) directory
5. `mix deps.get` (only needed once, obvs)
6. `iex -S mix` - example session below

```elixir
iex(1)> threshold # set in .iex.exs
67110167
iex(2)> httpoison(threshold) # 67110167 bytes is fine
{:ok, 67110167}
iex(3)> httpoison(threshold + 1) # 67110168 byte response is not fine
{:error, %HTTPoison.Error{reason: :enomem, id: nil}}
iex(4)> finch(threshold + 1) # Finch is fine with this
{:ok, 67110168}
iex(5)> finch(threshold * 10) # Finch is also fine with this
{:ok, 671101670}
iex(6)> finch(threshold * 20) # Finch is also fine with this
{:ok, 1342203340}
```