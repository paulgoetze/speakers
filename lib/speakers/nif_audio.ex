defmodule Speakers.NifAudio do
  @moduledoc false

  mix_config = Mix.Project.config()
  version = mix_config[:version]
  github_url = mix_config[:package][:links]["GitHub"]

  targets = ~w(
    arm-unknown-linux-gnueabihf
    aarch64-apple-darwin
    aarch64-unknown-linux-gnu
    aarch64-unknown-linux-musl
    x86_64-apple-darwin
    x86_64-pc-windows-gnu
    x86_64-pc-windows-msvc
    x86_64-unknown-linux-gnu
    x86_64-unknown-linux-musl
  )

  use RustlerPrecompiled,
    otp_app: :speakers,
    crate: "speakers_nifaudio",
    base_url: "#{github_url}/releases/download/v#{version}",
    force_build: System.get_env("SPEAKERS_BUILD") in ["1", "true"],
    version: version,
    targets: targets

  def add_to_queue(_file_path), do: error()
  def pause(), do: error()
  def resume(), do: error()
  def get_queue_len(), do: error()
  def get_volume(), do: error()
  def set_volume(_new_volume), do: error()

  defp error(), do: :erlang.nif_error(:nif_not_loaded)
end
