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

package body Xoshiro256 with SPARK_Mode => On is

   --  This is an Ada port of https://prng.di.unimi.it/xoshiro256plusplus.c
   --
   --  https://arxiv.org/abs/1805.01407
   --  doi:10.1145/3460772
   --  https://arxiv.org/abs/1910.06437
   --
   --  David Blackman and Sebastiano Vigna.
   --  Scrambled linear pseudorandom number generators. ACM Trans. Math. Softw., 47:1−32, 2021.
   --
   --  The text below is from xoshiro256plusplus.c:
   --
   --  /*  Written in 2019 by David Blackman and Sebastiano Vigna (vigna@acm.org)
   --
   --  To the extent possible under law, the author has dedicated all copyright
   --  and related and neighboring rights to this software to the public domain
   --  worldwide. This software is distributed without any warranty.
   --
   --  See <http://creativecommons.org/publicdomain/zero/1.0/>. */
   --
   --  /* This is xoshiro256++ 1.0, one of our all-purpose, rock-solid generators.
   --     It has excellent (sub-ns) speed, a state (256 bits) that is large
   --     enough for any parallel application, and it passes all tests we are
   --     aware of.
   --
   --     For generating just floating-point numbers, xoshiro256+ is even faster.
   --
   --     The state must be seeded so that it is not everywhere zero. If you have
   --     a 64-bit seed, we suggest to seed a splitmix64 generator and use its
   --     output to fill s. */

   function Rotate_Left (X : Unsigned_64; K : Integer) return Unsigned_64 is
     ((X * 2**K) or (X / 2**(Unsigned_64'Size - K)));

   procedure Next (S : in out Generator; Value : out Unsigned_64) is
      --  xoshiro256++ (xoshiro256+ is just S (0) + S (3))
      Result : constant Unsigned_64 := Rotate_Left (S (0) + S (3), 23) + S (0);

      T : constant Unsigned_64 := S (1) * 2**17;
   begin
      S (2) := S (2) xor S (0);
      S (3) := S (3) xor S (1);
      S (1) := S (1) xor S (2);
      S (0) := S (0) xor S (3);

      S (2) := S (2) xor T;

      S (3) := Rotate_Left (S (3), 45);

      Value := Result;
   end Next;

   function To_Float (Value : Unsigned_64) return Unit_Interval is
     (Long_Float (Value / 2**11) * 2.0**(-53));
   --  8 and 24 for 32-bit, 11 and 53 for 64-bit

   procedure Reset (S : out Generator; Seed : Unsigned_64) is
      Value : constant Unsigned_64 := Seed;
   begin
      for I in S'Range loop
         S (I) := Rotate_Left (Value, I + 1);
      end loop;
   end Reset;

end Xoshiro256;
