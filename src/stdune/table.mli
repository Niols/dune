(** Hashtable with a simple polymorphic type, but without the polymorphic equality.

   This module re-wraps the hashtable implementation provided by [Hashtbl.Make] under
   a different interface: we just have a single type [('k, 'v) t], similar to a
   polymorphic hashtable.

   This means that if you want a hash table generic over the type of keys,
   you don't have to put your type inside a functor.

   Unlike the polymorphich hashtable ([('k, 'v) Hashtbl.t]), this does not use polymorphic
   hash and polymorphic equality, so this module does respect abstraction boundaries.
*)

type ('k, 'v) t

module type Key = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
  val to_dyn : t -> Dyn.t
end

val create : (module Key with type t = 'k) -> int -> ('k, 'v) t

val find : ('k, 'v) t -> 'k -> 'v option

val find_exn : ('k, 'v) t -> 'k -> 'v

val set : ('k, 'v) t -> 'k -> 'v -> unit

val add_exn : ('k, 'v) t -> 'k -> 'v -> unit

val add : ('k, 'v) t -> 'k -> 'v -> (unit, 'v) Result.t

val clear : ('k, 'v) t -> unit

val mem : ('k, _) t -> 'k -> bool

val keys : ('k, _) t -> 'k list

val foldi : ('k, 'v) t -> init:'init -> f:('k -> 'v -> 'init -> 'init) -> 'init
