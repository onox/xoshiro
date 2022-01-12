[![Build status](https://github.com/onox/xoshiro/actions/workflows/build.yaml/badge.svg)](https://github.com/onox/xoshiro/actions/workflows/build.yaml)
[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/xoshiro.json)](https://alire.ada.dev/crates/xoshiro.html)
[![License](https://img.shields.io/github/license/onox/xoshiro.svg?color=blue)](https://github.com/onox/xoshiro/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/onox/xoshiro.svg)](https://github.com/onox/xoshiro/releases/latest)
[![IRC](https://img.shields.io/badge/IRC-%23ada%20on%20libera.chat-orange.svg)](https://libera.chat)
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/ada-lang/Lobby)

# Xoshiro random number generators

An Ada/SPARK port of the xoshiro128++ and xoshiro256++ pseudo-random number generators.

For a SIMD implementation using SSE2 or AVX2 intrinsics, see the
[orka_simd][url-orka-simd] crate. It is used to create tensors with
some [statistical distribution][url-orka-tensors-stats].

## Usage

```ada
declare
    use Xoshiro256;

    RNG   : Generator;
    Value : Unsigned_64;
begin
    Reset (RNG, Seed => 1);

    Next (RNG, Value);

    Ada.Text_IO.Put_Line (To_Float (Value)'Image);
end;
```

## Dependencies

In order to build the library, you need to have:

 * An Ada 2012 compiler

 * [Alire][url-alire] package manager

## License

The Ada code is licensed under the [Apache License 2.0][url-apache].
The first line of each Ada file should contain an SPDX license identifier tag that
refers to this license:

    SPDX-License-Identifier: Apache-2.0

  [url-alire]: https://alire.ada.dev/
  [url-apache]: https://opensource.org/licenses/Apache-2.0
  [url-orka-simd]: https://github.com/onox/orka/tree/master/orka_simd
  [url-orka-tensors-stats]: https://orka-engine.netlify.app/numerics/tensors/statistics/
