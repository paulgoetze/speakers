#[macro_use]
extern crate lazy_static;

use rustler::{Encoder, Env, Error, Term};
use std::io::BufReader;
use std::fs::File;

mod atoms {
    rustler::atoms! { ok, error }
}

lazy_static! {
    static ref CURRENT_SINK: rodio::Sink = {
        let device = rodio::default_output_device().unwrap();
        let sink = rodio::Sink::new(&device);
        sink
    };
}

#[rustler::nif]
pub fn pause<'a>(env: Env<'a>) -> Result<Term<'a>, Error> {
    CURRENT_SINK.pause();
    Ok((atoms::ok()).encode(env))
}

#[rustler::nif]
pub fn resume<'a>(env: Env<'a>) -> Result<Term<'a>, Error> {
    CURRENT_SINK.play();
    Ok((atoms::ok()).encode(env))
}

#[rustler::nif]
pub fn get_queue_len<'a>(env: Env<'a>) -> Result<Term<'a>, Error> {
    let queue_len = CURRENT_SINK.len();
    Ok((atoms::ok(), queue_len).encode(env))
}

#[rustler::nif]
pub fn add_to_queue<'a>(env: Env<'a>, file_path: String) -> Result<Term<'a>, Error> {
    let file = File::open(&file_path).unwrap();
    let source = rodio::Decoder::new(BufReader::new(file)).unwrap();

    CURRENT_SINK.append(source);

    Ok((atoms::ok()).encode(env))
}

#[rustler::nif]
pub fn get_volume<'a>(env: Env<'a>) -> Result<Term<'a>, Error> {
    let current_volume = CURRENT_SINK.volume();
    Ok((atoms::ok(), current_volume).encode(env))
}

#[rustler::nif]
pub fn set_volume<'a>(env: Env<'a>, new_volume: f32) -> Result<Term<'a>, Error> {
    let new_set_volume = CURRENT_SINK.set_volume(new_volume);
    Ok((atoms::ok(), new_set_volume).encode(env))
}

rustler::init!(
    "Elixir.Speakers.NifAudio",
    [
        add_to_queue,
        pause,
        resume,
        get_queue_len,
        get_volume,
        set_volume
    ]
);
