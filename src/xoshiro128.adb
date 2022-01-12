--  SPDX-License-Identifier: Apache-2.0
--
--  Copyright (c) 2022 onox <denkpadje@gmail.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

package body Xoshiro128 with SPARK_Mode => On is

   --  This is an Ada port of https://prng.di.unimi.it/xoshiro128plusplus.c.
   --
   --  https://arxiv.org/abs/1805.01407
   --  doi:10.1145/3460772
   --  https://arxiv.org/abs/1910.06437
   --
   --  David Blackman and Sebastiano Vigna.
   --  Scrambled linear pseudorandom number generators. ACM Trans. Math. Softw., 47:1−32, 2021.
   --
   --  The text below is from xoshiro128plusplus.c:
   --
   --  /*  Written in 2019 by David Blackman and Sebastiano Vigna (vigna@acm.org)
   --
   --  To the extent possible under law, the author has dedicated all copyright
   --  and related and neighboring rights to this software to the public domain
   --  worldwide. This software is distributed without any warranty.
   --
   --  See <http://creativecommons.org/publicdomain/zero/1.0/>. */
   --
   --  /* This is xoshiro128++ 1.0, one of our 32-bit all-purpose, rock-solid
   --     generators. It has excellent speed, a state size (128 bits) that is
   --     large enough for mild parallelism, and it passes all tests we are aware
   --     of.
   --
   --     For generating just single-precision (i.e., 32-bit) floating-point
   --     numbers, xoshiro128+ is even faster.
   --
   --     The state must be seeded so that it is not everywhere zero. */

   function Rotate_Left (X : Unsigned_32; K : Integer) return Unsigned_32 is
     ((X * 2**K) or (X / 2**(Unsigned_32'Size - K)));

   procedure Next (S : in out Generator; Value : out Unsigned_32) is
      --  xoshiro128++ (xoshiro128+ is just S (0) + S (3))
      Result : constant Unsigned_32 := Rotate_Left (S (0) + S (3), 7) + S (0);

      T : constant Unsigned_32 := S (1) * 2**9;
   begin
      S (2) := S (2) xor S (0);
      S (3) := S (3) xor S (1);
      S (1) := S (1) xor S (2);
      S (0) := S (0) xor S (3);

      S (2) := S (2) xor T;

      S (3) := Rotate_Left (S (3), 11);

      Value := Result;
   end Next;

   function To_Float (Value : Unsigned_32) return Unit_Interval is
     (Float (Value / 2**8) * 2.0**(-24));
   --  8 and 24 for 32-bit, 11 and 53 for 64-bit

   procedure Reset (S : out Generator; Seed : Unsigned_64) is
      Value : constant Unsigned_32 := Unsigned_32 (Seed mod Unsigned_32'Modulus);
   begin
      for I in S'Range loop
         S (I) := Rotate_Left (Value, I + 1);
      end loop;
   end Reset;

end Xoshiro128;
