type Autofs::Mount = Variant[
  # mount options host:path
  Struct[{
      mount => Stdlib::Absolutepath,
      path => Stdlib::Absolutepath,
      Optional[host] => Stdlib::Host,
      Optional[options] => Autofs::Options,
  }],
  # mount options targets
  Struct[{
      mount => Stdlib::Absolutepath,
      targets => Array[Autofs::Target, 1],
      Optional[options] => Autofs::Options,
  }]
]
