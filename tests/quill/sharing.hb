requires qprelude

--------------------------------------------------------------------------------
-- Basic examples for lambda calculus pair

-- This is now broken ¯\_(ツ)_/¯
-- shPair :: ((->) f$2w, ShFun f$30, (>:=) t$3g (f$30 t$36 (f$34 (f$3j t$3g (f$3e t$36 t$33)) t$33)),
--            (->) f$34, (>:=) t$3g (f$34 (f$3j t$3g (f$3e t$36 t$33)) t$33),
--            (>:=) t$36 (f$34 (f$3j t$3g (f$3e t$36 t$33)) t$33)) =>
--            f$2w t$3g (f$30 t$36 (f$34 (f$3j t$3g (f$3e t$36 t$33)) t$33))

shPair :: (SeFun f1, ShFun g1, SeFun h1
          , SeFun j1, SeFun k1                           -- This could not be automatically infered
          , a >:= (b ->{g1} ((a ->{k1} (b ->{j1} c)) ->{h1} c))
          , a >:= ((a ->{k1} (b ->{j1} c)) ->{h1} c)     -- This could not be automatically infered
          , b >:= ((a ->{k1} (b ->{j1} c)) ->{h1} c)
          , (>:=) b (f1 a (g1 b (h1 (k1 a (j1 b c)) c))) -- This could not be automatically infered
           ) => a ->{f1} (b ->{g1} ((a ->{k1} (b ->{j1} c)) ->{h1} c))
shPair = \x -> \&y -> \*sh -> sh x y


sePair :: (SeFun f, SeFun g, SeFun h
           , SeFun j, SeFun k                                  -- This could not be automatically infered
           , a >:= (b ->{g} ((a ->{k} (b ->{j} c)) ->{h} c))
           , a >:= ((a ->{k} (b ->{j} c)) ->{h} c)             -- why do we need this?
           , b >:= ((a ->{k} (b ->{j} c)) ->{h} c)
           ) =>
           a ->{f} (b ->{g} ((a ->{k} (b ->{j} c)) ->{h} c))
sePair = \x -> \*y -> \*sp -> sp x y


-- simple functions
id :: a -> a
id  = \x -> x

-- Because this is a sharing pair, there should not be any Uns on the
-- variables that are not used

-- fst :: ((->) f, b >:= (a ->{f} (b ->{g} a))
--        , ShFun g
--        , a >:= (b ->{g} a))
--        =>  a ->{f} (b ->{g} a)
fst = \x -> \&y -> x

-- snd :: ((->) f, ShFun g
--        , b >:= (a ->{f} (b ->{g} b))
--        , a >:= (b ->{g} b))
--        => a ->{f} (b ->{g} b)
snd = \x -> \&y -> y

-- csnd :: ((->) f, (>:=) c (f a (g b (h c c))),
--          (>:=) b (f a (g b (h c c))), Un a, SeFun g,
--          (>:=) c (g b (h c c)),
--          ShFun h, (>:=) b (h c c)) =>
--                  a ->{f} (b ->{g}(c ->{h} c))
csnd = \z -> \*x -> \&y -> y

-- cfst :: ((->) f, SeFun g, (>:=) a (g b (h c a)),
--              Un b, ShFun h, (>:=) a (h c a), Un c) =>
--                 a ->{f} (b ->{g} (c ->{h} a))
cfst = \z -> \*x -> \&y -> z

-- csnd' :: ((->) f, (>:=) c (f a (g b (h c b))),
--           (>:=) b (f a (g b (h c b))), Un a, SeFun g,
--           (>:=) c (g b (h c b)),
--           ShFun h, (>:=) b (h c b)) =>
--                  a ->{f} (b ->{g} (c ->{h} b))
csnd' = \z -> \*x -> \&y -> x

-- how will fst . shPair typecheck?
-- how will snd . shPair typecheck?

-- This is a linear pair, hence the variables that
-- that are not used should be marked as Un
-- fst' :: ((->) f, SeFun g
--        , a >:= (b ->{g} a)
--        , Un b)
--        =>  a ->{f} (b ->{g} a)
fst' = \x -> \*y -> x

-- snd' :: ((->) f, SeFun g
--        , Un a)
--        => a ->{f} (b ->{g} b)
snd' = \x -> \*y -> y

blah = \u -> \*v -> \&w -> \*z -> u

-- blah' and blah'' fail when explicit types are not provided
blah' ::  (SeFun f, ShFun g, SeFun h, SeFun i
          , c >:= (d ->{i} b)
          , Un a, Un d
          , b >:= (d ->{i} b))
         => a ->{f} b ->{g} c ->{h} d ->{i} b
blah' = \u -> \*v -> \&w -> \*z -> v

blah'' ::  (SeFun f, ShFun g, SeFun h, SeFun i
           , Un a, Un d
           , c >:= (d ->{i} c)
           , b >:= (d ->{i} c)
           )
           => a ->{f} b ->{g} c ->{h} d ->{i} c
blah'' = \u -> \*v -> \&w -> \*z -> w

blah''' = \u -> \*v -> \&w -> \*z -> z