(* reference solution - for testing only. DO NOT EDIT THIS FILE.
 * 
 * these solutions are purposefully stupid. do not try to imitate them in
 * your own solutions. *)

functor MkRefSeqUtil(structure Seq : SEQUENCE) : SEQ_UTIL =
struct
  structure Seq = Seq
  open Seq

  type 'a hist = ('a * int) seq

  fun histogram (cmp : 'a ord) (s : 'a seq) : 'a hist =
    let
      fun alphaEq x y = case cmp (x,y) of EQUAL => true | _ => false
      fun findAlpha (H : 'a hist) (a : 'a) =
        let val possible = filter ((alphaEq a) o #1) H
        in length possible <> 0
        end
      fun addAlpha (H : 'a hist, a : 'a) =
        if findAlpha H a then
          map (fn (b,n) => if (alphaEq a b) then (a,n+1) else (b,n)) H
        else
          append (H, singleton (a,1))

      val finalUnsorted = iter addAlpha (empty ()) s
    in
      sort (fn ((x,_),(y,_)) => cmp (x, y)) finalUnsorted
    end

  fun choose (hist : 'a hist) (p : real) : 'a =
    let
      fun tupToSeq (x,n) = tabulate (fn _ => x) n
      val unhist = flatten (map tupToSeq hist)

      val ind = Real.ceil (p * (Real.fromInt (length unhist))) - 1
      val ind' = if ind < 0 then 0 else ind
    in
      nth unhist ind'
    end
end