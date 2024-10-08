defmodule Simdjsone.Bench do
  use ExUnit.Case, async: true

  @tag timeout: :infinity
  test "Run benchmarks" do
    #bin =
    #  "{\"id\":\"d4b5c697-41f3-4c1c-a3d5-5fd01b5ef2aa\",\"at\":1,\"imp\":[{\"id\":\"974090632\",\"banner\":{\"w\":300,\"h\":250}}],\"site\":{\"id\":\"12345\",\"domain\":\"sitedomain.com\",\"cat\":[\"IAB25-3\"],\"page\":\"https://sitedomain.com/page\",\"keywords\":\"lifestyle, humour\"},\"device\":{\"ua\":\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.63 Safari/537.36\",\"ip\":\"131.34.123.159\",\"geo\":{\"country\":\"IRL\"},\"language\":\"en\",\"os\":\"Linux & UNIX\",\"js\":0,\"ext\":{\"remote_addr\":\"131.34.123.159\",\"x_forwarded_for\":\"\",\"accept_language\":\"en-GB;q=0.8,pt-PT;q=0.6,en;q=0.4,en-US;q=0.2,de;q=0.2,es;q=0.2,fr;q=0.2\"}},\"user\":{\"id\":\"57592f333f8983.043587162282415065\",\"ext\":{\"consent\":\"CO9A8QHPAbnHWBcADBENBJCoAAAAAAAAAAqIHKJU9VybLh0Dq4A170B0OAEYN_r_v40zigeds-8Myd-X3DsX50M7vFy6pr4AuR4km3CBIQFkHOmcTUmw6IkVrRPsak2Mr7NKJ7PEinsbe2dYEHtfn9VTuZKZr97s___zf_-___3_75f__-3_3_vp9UAAAABA5QAkgkDYAKAQRAAJIwKhQAhAuJDoBAAUUIwtE1hASuCmYVAR-ggYAIDUBGAECDEEGIIIAAAAAkgiAkAPBAAgCIBAACAFSAhAARoAgsAJAwCAAUA0LACKAIQJCDI4KjlICAiRaKCeSMASi72MMIQSigAAAAAAAA\",\"prebid\":{\"buyeruids\":{\"platform1\":\"C9446DA7-BB76-44B9-B260-77E16530AA03\",\"platform2\":\"6372709574547581900\",\"platform3\":\"456621142600017315\",\"platform4\":\"3952063610783032691\",\"platform5\":\"KX3KMRTI-11-ZMP\",\"platform6\":\"402e4b19ff476fb23de2c97ebe62a47b\",\"platform7\":\"bu7zD7LkVT2huSwTSvou\"}}}},\"ext\":{\"sub\":1221}}"

    f = fn(bin) ->
      %{
        "thaos"     => fn -> :thoas.decode(bin) end,
        "euneus"    => fn -> :euneus.decode(bin) end,
        "jason"     => fn -> Jason.decode(bin) end,
        "jiffy"     => fn -> :jiffy.decode(bin, [:return_maps]) end,
        "poison"    => fn -> Poison.decode!(bin) end,
        "json"      => fn -> :json.decode(bin) end,
        "simdjsone" => fn -> :simdjson.decode(bin) end
      }
    end

    for i <- ["twitter", "esad", "small"] do
      bin = Path.join([File.cwd!(), "test/data", "#{i}.json"]) |> File.read!()
      :io.format("\n=== Benchmark (file size: ~.1fK) ===\n", [byte_size(bin) / 1024])
      Benchee.run(f.(bin), time: 5, memory_time: 1, parallel: 1, print: [benchmarking: false, configuration: false])
    end
  end
end
