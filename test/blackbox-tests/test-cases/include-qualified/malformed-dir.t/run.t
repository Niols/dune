Reproducing bug in https://github.com/ocaml/dune/issues/7600

When using (include_subdirs qualified), valid module names should be checked for
directories too. However, directories can have invalid module names if they are
mentioned in a (data_only_dirs ...) stanza.

  $ dune exec ./foo.exe
  foo

Create a directory whose name is an invalid module name. Check that Dune fails
in a clean way, suggesting an alternative.

  $ mkdir bar-baz

  $ dune exec ./foo.exe
  File "src/baz-bar", line 1, characters 0-0:
  Error: "baz-bar" is an invalid module name.
  Module names must be non-empty and composed only of the following characters:
  'A'..'Z', 'a'..'z', '_', ''' or '0'..'9'.
  Hint: baz_bar would be a correct module name.

Apply the suggestion and check that it now works again.

  $ mv bar-baz bar_baz

  $ dune exec ./foo.exe
  foo

It would also have been possible to declare the directory in question as a
data-only directory.

  $ mv bar_baz bar-baz

  $ echo '(data_only_dirs bar-baz)' >> dune

  $ dune exec ./foo.exe
  foo
