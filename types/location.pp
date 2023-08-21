type Autofs::Location = Variant[
  # host:path
  Struct[{
      Optional[host] => Stdlib::Host,
      path => Stdlib::Absolutepath,
  }],
  # mount options host:path
  Hash[Stdlib::Absolutepath, Struct[{
        Optional[options] => Autofs::Options,
        Optional[host] => Stdlib::Host,
        path => Stdlib::Absolutepath,
  }], 1],
]
